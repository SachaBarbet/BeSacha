import 'package:be_sacha/models/ask_friend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import 'app_user_service.dart';

class AppFirebase {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static CollectionReference<AppUser> userCollectionRef = AppFirebase.database.collection('users')
      .withConverter(fromFirestore: AppUser.fromFirestore, toFirestore: (AppUser user, _) => user.toFirestore(),);
  static CollectionReference<AskFriend> askFriendCollectionRef = AppFirebase.database.collection('ask-friends')
      .withConverter(
    fromFirestore: AskFriend.fromFirestore,
    toFirestore: (AskFriend askFriend, _) => askFriend.toFirestore(),
  );

  static bool isUserConnected = false;

  static Future<void> initFirebaseAuth() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        isUserConnected = await AppUserService.checkIfUserConnected();
    });

    isUserConnected = await AppUserService.checkIfUserConnected();
  }

  static Future<void> updateUserConnected() async {
    isUserConnected = await AppUserService.checkIfUserConnected();
  }
}