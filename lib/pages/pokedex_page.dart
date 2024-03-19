import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../models/app_user.dart';
import '../models/pokemon.dart';
import '../services/app_user_service.dart';
import '../services/pokemon_service.dart';
import '../services/settings_service.dart';

class PokedexPage extends StatefulWidget {
  const PokedexPage({super.key});

  @override
  State<PokedexPage> createState() => _PokedexPageState();
}

class _PokedexPageState extends State<PokedexPage> {
  static const int _pageSize = 20;
  late final Future<AppUser?> _appUser;

  final PagingController<int, Pokemon> _pagingController = PagingController(firstPageKey: 1);

  final TextEditingController _searchController = TextEditingController();
  String _ownedDropdown = 'all';
  String _typeDropdown = 'all';

  final String _brightnessMode = SettingsService.getBrightnessMode();


  Color? _textColor;
  Color? _dropdownColor;

  @override
  void initState() {
    _appUser = AppUserService.getUser();
    super.initState();
  }

  Future<void> _fetchPage(int pageKey, List<int>? ownedPokemons) async {
    try {
      final List<Pokemon> newItems = await PokemonService.fetchPokemons(pageKey, _pageSize, _searchController.text,
          _typeDropdown, _ownedDropdown, ownedPokemons);
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
    if (_brightnessMode != 'system') {
      _textColor = _brightnessMode == 'dark' ? kWhiteColor : kBlackColor;
      _dropdownColor = _brightnessMode == 'dark' ? kBlackColor : kLightGreyColor;
    } else {
      _textColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kWhiteColor : kBlackColor;
      _dropdownColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kBlackColor : kLightGreyColor;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Pokedex', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          FutureBuilder(
            future: _appUser,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              AppUser? appUser = snapshot.data;

              if (appUser == null) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.only(right: kDefaultPadding * 1.25),
                child: Text('${appUser.pokemons!.length} / 1025'),
              );
            }
          ),
        ],
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 1.5,
          vertical: kDefaultPadding,
        ),
        child: FutureBuilder(
          future: _appUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Une erreur est survenue, Veuillez réessayer plus tard.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                ),
              );
            }

            AppUser? appUser = snapshot.data;

            if (appUser == null) {
              return const Center(
                child: Text(
                  'Vous n\'êtes pas connecté, Veuillez vous connecter pour accéder au pokedex.',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                ),
              );
            }

            List<int> unlockedPokemons = appUser.pokemons!;

            _pagingController.addPageRequestListener((pageKey) {
              _fetchPage(pageKey, unlockedPokemons);
            });

            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SearchBar(
                  controller: _searchController,
                  hintText: 'Rechercher un pokemon',
                  leading: IconButton(
                    icon: const Icon(Icons.search, color: kWhiteColor),
                    onPressed: () {
                      setState(() {
                        _pagingController.itemList = [];
                        _fetchPage(1, unlockedPokemons);
                      });
                    },
                  ),
                  onChanged: (search) {
                    setState(() {
                      _pagingController.itemList = [];
                      _fetchPage(1, unlockedPokemons);
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton(
                        style: TextStyle(color: _textColor,),
                        dropdownColor: _dropdownColor,
                        underline: Container(),
                        value: _ownedDropdown,
                        items: const [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text('Tous'),
                          ),
                          DropdownMenuItem(
                            value: 'locked',
                            child: Text('Vérrouillés'),
                          ),
                          DropdownMenuItem(
                            value: 'unlocked',
                            child: Text('Déverrouillés'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _ownedDropdown = value!;
                            _pagingController.itemList = [];
                            _fetchPage(1, unlockedPokemons);
                          });
                        },
                      ),
                      Row(
                        children: [
                          const Text('Type : '),
                          DropdownButton(
                            value: _typeDropdown,
                            style: TextStyle(color: _textColor,),
                            dropdownColor: _dropdownColor,
                            underline: Container(),
                            items: const [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text('Tous'),
                              ),
                              DropdownMenuItem(
                                value: 'normal',
                                child: Text('Normal'),
                              ),
                              DropdownMenuItem(
                                value: 'fire',
                                child: Text('Feu'),
                              ),
                              DropdownMenuItem(
                                value: 'water',
                                child: Text('Eau'),
                              ),
                              DropdownMenuItem(
                                value: 'electric',
                                child: Text('Electrique'),
                              ),
                              DropdownMenuItem(
                                value: 'grass',
                                child: Text('Plante'),
                              ),
                              DropdownMenuItem(
                                value: 'ice',
                                child: Text('Glace'),
                              ),
                              DropdownMenuItem(
                                value: 'fighting',
                                child: Text('Combat'),
                              ),
                              DropdownMenuItem(
                                value: 'poison',
                                child: Text('Poison'),
                              ),
                              DropdownMenuItem(
                                value: 'ground',
                                child: Text('Sol'),
                              ),
                              DropdownMenuItem(
                                value: 'flying',
                                child: Text('Vol'),
                              ),
                              DropdownMenuItem(
                                value: 'psychic',
                                child: Text('Psy'),
                              ),
                              DropdownMenuItem(
                                value: 'bug',
                                child: Text('Insecte'),
                              ),
                              DropdownMenuItem(
                                value: 'rock',
                                child: Text('Roche'),
                              ),
                              DropdownMenuItem(
                                value: 'ghost',
                                child: Text('Spectre'),
                              ),
                              DropdownMenuItem(
                                value: 'dragon',
                                child: Text('Dragon'),
                              ),
                              DropdownMenuItem(
                                value: 'dark',
                                child: Text('Ténèbres'),
                              ),
                              DropdownMenuItem(
                                value: 'steel',
                                child: Text('Acier'),
                              ),
                              DropdownMenuItem(
                                value: 'fairy',
                                child: Text('Fée'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _typeDropdown = value!;
                                _pagingController.itemList = [];
                                _fetchPage(1, unlockedPokemons);
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: PagedGridView(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Pokemon>(
                      itemBuilder: (context, item, index) {
                        bool isUnlocked = unlockedPokemons.contains(item.id);
                        return Container(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                            color: _dropdownColor,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text('#${item.id.toString().padLeft(4, '0')}', style: const TextStyle(fontSize: 12,)),
                                ],
                              ),
                              Image.network(item.defaultSprite, color: isUnlocked ? null : Colors.black, height: 80, width: 80),
                              Text(isUnlocked ? item.name[0].toUpperCase() + item.name.substring(1) : '????'),
                              Text('Type : ${isUnlocked ? item.type[0].toUpperCase() + item.type.substring(1) : '????'}'),
                            ],
                          ),
                        );
                      },
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: kDefaultPadding,
                      mainAxisSpacing: kDefaultPadding,
                    )
                  ),
                ),
              ],
            );
          }
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
