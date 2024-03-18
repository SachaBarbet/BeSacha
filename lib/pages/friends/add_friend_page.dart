import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/friends_service.dart';
import '../../utilities/toast_util.dart';

class AddFriendPage extends StatefulWidget {

  const AddFriendPage({super.key});

  @override
  State<AddFriendPage> createState() => _AddFriendPageState();
}

class _AddFriendPageState extends State<AddFriendPage> {
  late Future<List<AppUser>> _friendsToAdd;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _friendsToAdd = Future.value([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        leadingWidth: 0,
        title: SearchBar(
          controller: _searchController,
          hintText: 'Rechercher un ami',
          leading: BackButton(
            color: AppColors.white,
            onPressed: () => context.pop(),
            style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => AppColors.white)),
          ),
          trailing: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.white),
              onPressed: () {
                setState(() {
                  _friendsToAdd = FriendsService.searchNewFriend(_searchController.text);
                });
              },
            )
          ],
          onChanged: (search) {
            setState(() {
              _friendsToAdd = FriendsService.searchNewFriend(search);
            });
          },
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: FutureBuilder(
          future: _friendsToAdd,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'Une erreur est survenue, Veuillez réessayer plus tard.',
                  style: TextStyle(fontSize: 20, color: AppColors.primary),
                  textAlign: TextAlign.center,
                ),
              );
            }

            List<AppUser> friends = snapshot.data as List<AppUser>;

            if (friends.isNotEmpty) {
              return ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  AppUser friend = friends[index];
                  return ListTile(
                    title: Text(friend.displayName),
                    subtitle: Text(friend.username),
                    trailing: ElevatedButton(
                      onPressed: () {
                        FriendsService.askFriend(friend);
                        setState(() {
                          friends.removeAt(index);
                        });
                        ToastUtil.showSuccessToast(context, 'Demande envoyée');
                      },
                      child: const Text('Ajouter'),
                    ),
                  );
                },
              );
            } else {
              if (_searchController.text.isEmpty) {
                return const Center(
                  child: Text(
                    'Recherchez un ami par son username.\nEx: username#tag\nPeut être trouvé dans les paramètres de votre compte.',
                    style: TextStyle(fontSize: 20), textAlign: TextAlign.center,
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'Aucun utilisateur trouvé.\nVeuillez réessayer avec un autre username.',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
            }
          }
        ),
      ),
    );
  }
}
