import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/friends_service.dart';

class FriendsPage extends StatefulWidget {

  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<AppUser?>> _friends;

  @override
  void initState() {
    _friends = FriendsService.getFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Vos amis', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            child: IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () {
                context.pushNamed('add-friend-list');
                setState(() {
                  _friends = FriendsService.getFriends();
                });
              },
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 1.5,
          vertical: kDefaultPadding,
        ),
        child: FutureBuilder(
          future: _friends,
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

            List<AppUser?> friends = snapshot.data as List<AppUser?>;
            if (friends.isNotEmpty) {
              return ListView(
                children: [
                  for (AppUser? friend in friends)
                    ListTile(
                      tileColor: kLightPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kDefaultPadding),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.close, color: kWhiteColor),
                        onPressed: () async {
                          await FriendsService.removeFriend(friend!);
                          setState(() {
                            _friends = FriendsService.getFriends();
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.compare_arrows, color: Colors.white),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Fonctionnalité à venir',
                              textAlign:  TextAlign.center,
                              style: TextStyle(color: kWhiteColor,),
                            ),
                            backgroundColor: kRedColor,
                          ));
                        },
                      ),
                      title: Text(friend!.displayName),
                      subtitle: Text(friend.username),
                    ),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'Vous n\'avez pas encore d\'amis :(\nAppuyiez sur "+" pour en ajouter et commencer à échanger des Pokemons !',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed('add-friend');
          setState(() {
            _friends = FriendsService.getFriends();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
