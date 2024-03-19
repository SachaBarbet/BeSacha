import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/friends_service.dart';
import '../../services/settings_service.dart';

class FriendAddListPage extends StatefulWidget {

  const FriendAddListPage({super.key});

  @override
  State<FriendAddListPage> createState() => _FriendAddListPageState();
}

class _FriendAddListPageState extends State<FriendAddListPage> {
  late Future<List<AppUser>> _askFriends;
  int _currentIndex = 0;

  final String _brightnessMode = SettingsService.getBrightnessMode();

  Color? _textColor;
  Color? _backgroundColor;

  @override
  void initState() {
    _askFriends = FriendsService.getAskFromFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_brightnessMode != 'system') {
      _textColor = _brightnessMode == 'dark' ? kWhiteColor : kBlackColor;
      _backgroundColor = _brightnessMode == 'dark' ? kBlackColor : kLightGreyColor;
    } else {
      _textColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kWhiteColor : kBlackColor;
      _backgroundColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kBlackColor : kLightGreyColor;
    }
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: Text(_currentIndex == 0 ? 'Demandes reçues' : 'Demandes envoyées',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding,
        ),
        child: ListView(
          children: [
            FutureBuilder(
              future: _askFriends,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ));
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: kDefaultPadding * 2),
                      child: Text(
                        'Une erreur est survenue lors du chargement des demandes',
                        style: TextStyle(color: kRedColor),
                      ),
                    ),
                  );
                }

                final List<AppUser> friends = snapshot.data as List<AppUser>;

                if (friends.isEmpty) {
                  if (_currentIndex == 0) {
                    return const Center(
                      child: Text(
                        'Aucune demande reçue',
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Aucune demande envoyée',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                }

                if (_currentIndex == 0) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      AppUser friend = friends[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: kDefaultPadding),
                        child: ListTile(
                          tileColor: _backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kDefaultPadding),
                          ),
                          title: Text(friend.displayName),
                          subtitle: Text(friend.username),
                          leading: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              FriendsService.cancelAskFriend(friend);
                              setState(() {
                                friends.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Demande refusée',
                                  textAlign:  TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kBlackColor,
                              ));
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () {
                              FriendsService.acceptAskFriend(friend);
                              setState(() {
                                friends.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Demande acceptée',
                                  textAlign:  TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kBlackColor,
                              ));
                            },
                          )
                        ),
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      AppUser friend = friends[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: kDefaultPadding / 2),
                        child: ListTile(
                          tileColor: _backgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kDefaultPadding),
                          ),
                          title: Text(friend.displayName),
                          subtitle: Text(friend.username),
                          trailing: ElevatedButton(
                            onPressed: () {
                              FriendsService.cancelAskFriend(friend);
                              setState(() {
                                friends.removeAt(index);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Demande d\'ami retirée',
                                  textAlign:  TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kBlackColor,
                              ));
                            },
                            child: const Text('Annuler'),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: _backgroundColor,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: _textColor,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.call_received),
            label: 'Demandes reçues',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_made),
            label: 'Demandes envoyées',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _askFriends = index == 0 ? FriendsService.getAskFromFriends() : FriendsService.getAskToFriends();
          });
        },
      ),
    );
  }
}
