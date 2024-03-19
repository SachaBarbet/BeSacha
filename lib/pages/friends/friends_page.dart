import 'package:be_sacha/services/trade_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../models/pokemon.dart';
import '../../services/friends_service.dart';

class FriendsPage extends StatefulWidget {

  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late Future<List<AppUser?>> _friends;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
        centerTitle: true,
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
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  setState(() {
                    _friends = FriendsService.getFriends();
                  });
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                color: kWhiteColor,
                backgroundColor: kLightPrimaryColor,
                strokeWidth: 4.0,
                child: ListView(
                  children: friends.map((AppUser? friend) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding),
                      child: ListTile(
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
                          onPressed: () async {
                            dynamic result = await TradeService.askTrade(friend!);
                            if (!context.mounted) return;
                            if (result == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Vous avez déjà demandé un échange avec cet ami aujourd\'hui',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kBlackColor,
                              ));
                            } else if (result is bool && result == false) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Demande d\'échange envoyée',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kGreenColor,
                              ));
                            } else if (result is bool && result == true) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Echange déjà effectué avec cet ami aujourd\'hui',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kGreenColor,
                              ));
                            } else if (result is Pokemon) {

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Echange effectué avec succès - Nouveau Pokemon : ${result.name}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kGreenColor,
                              ));
                            }
                          },
                        ),
                        title: Text(friend!.displayName, style: const TextStyle(color: kWhiteColor),),
                        subtitle: Text(friend.username, style: const TextStyle(color: kWhiteColor),),
                      ),
                    );
                  }).toList(),
                ),
              );
            } else {
              return const Center(
                child: Text(
                  'Vous n\'avez pas encore d\'amis :(\n'
                  'Appuyiez sur "+" pour en ajouter et commencer à échanger des Pokemons !',
                  style: TextStyle(fontSize: 20,),
                  textAlign: TextAlign.center,
                ),
              );
            }
          }
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.pushNamed('add-friend');
          if (!context.mounted) return;

          setState(() {
            _friends = FriendsService.getFriends();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
