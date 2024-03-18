import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/friends_service.dart';
import '../../utilities/toast_util.dart';

class FriendsPage extends StatefulWidget {

  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  static const double _dividerHeight = 50;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppDesignSystem.defaultPadding),
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
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
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
                  const Text('Vos amis', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),),
                  const SizedBox(height: _dividerHeight),
                  for (AppUser? friend in friends)
                    ListTile(
                      tileColor: AppColors.lightPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDesignSystem.defaultPadding),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
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
                          ToastUtil.showInfoToast(context, 'Fonctionnalité à venir');
                        },
                      ),
                      title: Text(friend!.displayName!),
                      subtitle: Text(friend.username!),
                    ),
                ],
              );
            } else {
              return ListView(
                children: const [
                  Text('Vos amis', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),),
                  SizedBox(height: 50),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Vous n\'avez pas encore d\'amis.\nAjoutez-en pour commencer à échanger des Pokemons !',
                        style: TextStyle(fontSize: 20,),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
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
