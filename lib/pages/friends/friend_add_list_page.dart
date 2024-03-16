import 'package:be_sacha/utilities/toast_util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/friends_service.dart';

class FriendAddListPage extends StatefulWidget {

  const FriendAddListPage({super.key});

  @override
  State<FriendAddListPage> createState() => _FriendAddListPageState();
}

class _FriendAddListPageState extends State<FriendAddListPage> {
  static const double _dividerHeight = 50;
  late Future<List<AppUser>> _askFriends;
  int _currentIndex = 0;

  @override
  void initState() {
    _askFriends = FriendsService.getAskFromFriends();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: ListView(
          children: [
            Text(_currentIndex == 0 ? 'Demandes reçues' : 'Demandes envoyées',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
              child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
            ),
            FutureBuilder(
              future: _askFriends,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ));
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Une erreur est survenue lors du chargement des demandes',
                      style: TextStyle(color: AppColors.red),
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
                      return ListTile(
                        title: Text(friend.displayName!),
                        subtitle: Text(friend.username!),
                        leading: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            FriendsService.cancelAskFriend(friend);
                            setState(() {
                              friends.removeAt(index);
                            });
                            ToastUtil.showSuccessToast(context, 'Demande refusée');
                          },
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            FriendsService.acceptAskFriend(friend);
                            setState(() {
                              friends.removeAt(index);
                            });
                            ToastUtil.showSuccessToast(context, 'Demande acceptée');
                          },
                        )
                      );
                    },
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      AppUser friend = friends[index];
                      return ListTile(
                        title: Text(friend.displayName!),
                        subtitle: Text(friend.username!),
                        trailing: ElevatedButton(
                          onPressed: () {
                            FriendsService.cancelAskFriend(friend);
                            setState(() {
                              friends.removeAt(index);
                            });
                            ToastUtil.showInfoToast(context, 'Demande annulée');
                          },
                          child: const Text('Annuler'),
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
        backgroundColor: AppColors.lightPrimary,
        selectedItemColor: AppColors.black,
        unselectedItemColor: AppColors.white,
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
