import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../models/pokemon.dart';
import '../services/settings_service.dart';
import '../services/pokeapi.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  static const int _pageSize = 20;

  final PagingController<int, Pokemon> _pagingController = PagingController(firstPageKey: 1);

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<Pokemon> newItems = await PokeApi.fetchPokemons(pageKey, _pageSize);
      if (newItems.length < _pageSize) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    String brightnessMode = SettingsService.getBrightnessMode();
    Color backgroundColor = brightnessMode == 'system' ?
      MediaQuery.of(context).platformBrightness == Brightness.dark ?
        AppColors.black : AppColors.lightGrey : brightnessMode == 'dark' ? AppColors.black : AppColors.lightGrey;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Pokedex', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppDesignSystem.defaultPadding),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Rechercher un pokemon',
                leading: IconButton(
                  icon: const Icon(Icons.search, color: AppColors.white),
                  onPressed: () {
                    setState(() {
                      _pagingController.refresh();
                      // _fetchPage(pageKey);
                      // _friendsToAdd = FriendsService.searchNewFriend(_searchController.text);
                    });
                  },
                ),
                onChanged: (search) {
                  setState(() {
                    // _friendsToAdd = FriendsService.searchNewFriend(search);
                  });
                },
              ),
            ),
            Expanded(
              child: PagedGridView(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Pokemon>(
                  itemBuilder: (context, item, index) {
                    return Container(
                      padding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
                        color: backgroundColor,
                      ),
                      child: Column(
                        children: [
                          Image.network(item.defaultSprite),
                          Text(item.name[0].toUpperCase() + item.name.substring(1)),
                          Text('Type : ${item.type[0].toUpperCase() + item.type.substring(1)}')
                        ],
                      ),
                    );
                  },
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDesignSystem.defaultPadding,
                  mainAxisSpacing: AppDesignSystem.defaultPadding,
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
