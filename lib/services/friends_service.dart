import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../models/ask_friend.dart';
import 'app_user_service.dart';

class FriendsService {
  static final CollectionReference<AskFriend> askFriendCollectionRef = FirebaseFirestore.instance
      .collection('ask-friends').withConverter(
    fromFirestore: AskFriend.fromFirestore,
    toFirestore: (AskFriend askFriend, _) => askFriend.toFirestore(),
  );


  static Future<List<AppUser>> getFriends() async {
    AppUser? appUser = await AppUserService.getUser();
    if (appUser == null) return [];

    List<dynamic> friendsIds = appUser.friends;
    if (friendsIds.isEmpty) return [];

    List<AppUser>? friends = [];
    for (String friendId in friendsIds) {
      AppUser? friend = await AppUserService.getUser(friendId);
      if (friend != null) friends.add(friend);
    }
    return friends.isEmpty ? [] : friends;
  }

  static Future<List<AppUser>> getAskToFriends() async {
    String appUserId = FirebaseAuth.instance.currentUser!.uid;

    List<AskFriend> askFriends = await askFriendCollectionRef.where('from_user', isEqualTo: appUserId)
        .get().then((value) => value.docs.map((e) =>e.data()).toList());

    List<AppUser> users = [];
    for (AskFriend askFriend in askFriends) {
      AppUser? user = await AppUserService.getUser(askFriend.toUser);
      if (user != null) users.add(user);
    }

    return users;
  }

  static Future<List<AppUser>> getAskFromFriends() async {
    String appUserId = FirebaseAuth.instance.currentUser!.uid;

    List<AskFriend> askFriends = await askFriendCollectionRef.where('to_user', isEqualTo: appUserId)
        .get().then((value) => value.docs.map((e) =>e.data()).toList());

    List<AppUser> users = [];
    for (AskFriend askFriend in askFriends) {
      AppUser? user = await AppUserService.getUser(askFriend.fromUser);
      if (user != null) users.add(user);
    }

    return users;
  }

  static Future<List<AppUser>> searchNewFriend(String search) async {
    if (search.isEmpty) return [];

    List<AppUser> users = await AppUserService.getUsersByUsername(search);
    if (users.isEmpty) return [];

    // Exclure les amis déjà ajoutés
    List<AppUser> friends = await getFriends();
    if (friends.isNotEmpty) users.removeWhere((user) => friends.contains(user));

    // Exclure l' utilisateur connecté
    AppUser? connectedUser = await AppUserService.getUser();
    if (connectedUser != null) users.removeWhere((user) => user.uid == connectedUser.uid);
    return users;
  }

  static Future<void> addFriend(AppUser friend) async {
    AppUser? appUser = await AppUserService.getUser();
    if (appUser == null) return;
    if (appUser.uid == friend.uid) return; // Ne pas ajouter soi-même

    if (appUser.friends.contains(friend.uid)) return;

    appUser.friends.add(friend.uid);
    friend.friends.add(appUser.uid);

    cancelAskFriend(friend);

    await AppUserService.updateUser(appUser);
    await AppUserService.updateUser(friend);
  }

  static Future<void> removeFriend(AppUser friend) async {
    AppUser? appUser = await AppUserService.getUser();
    if (appUser == null) return;
    if (appUser.uid == friend.uid) return; // Ne pas supprimer soi-même

    if (!appUser.friends.contains(friend.uid)) return;

    appUser.friends.remove(friend.uid);
    await AppUserService.updateUser(appUser);

    if (!friend.friends.contains(appUser.uid)) return;
    friend.friends.remove(appUser.uid);
    await AppUserService.updateUser(friend);
  }

  static Future<void> askFriend(AppUser friend) async {
    AppUser? appUser = await AppUserService.getUser();
    if (appUser == null) return;
    if (appUser.uid == friend.uid) return; // Ne pas ajouter soi-même

    AskFriend askFriend = AskFriend(
      fromUser: appUser.uid,
      toUser: friend.uid,
    );

    askFriendCollectionRef.where('from_user', isEqualTo: appUser.uid).where('to_user', isEqualTo: friend.uid).get().then((value) {
      if (value.docs.isNotEmpty) return;

      askFriendCollectionRef.where('from_user', isEqualTo: friend.uid).where('to_user', isEqualTo: appUser.uid).get().then((value) {
        if (value.docs.isNotEmpty) {
          askFriendCollectionRef.doc(value.docs.first.id).delete();
          addFriend(friend);
        } else {
          askFriendCollectionRef.add(askFriend);
        }
      });
    });
  }

  static Future<void> cancelAskFriend(AppUser appUser) async {
    AppUser? connectedUser = await AppUserService.getUser();
    if (connectedUser == null) return;

    askFriendCollectionRef.where(
      Filter.or(
          Filter.and(Filter('from_user', isEqualTo: connectedUser.uid), Filter('to_user', isEqualTo: appUser.uid)),
          Filter.and(Filter('from_user', isEqualTo: appUser.uid), Filter('to_user', isEqualTo: connectedUser.uid)))
      ).get().then((value) {
      if (value.docs.isNotEmpty) askFriendCollectionRef.doc(value.docs.first.id).delete();
    });
  }

  static Future<void> acceptAskFriend(AppUser appUser) async {
    return await addFriend(appUser);
  }
}