import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../utilities/app_utils.dart';
import 'app_firebase.dart';

class AppUserService {

  /// Register a new user with email and password in Firebase Authentication and Firestore
  static Future<AppUser?> register(String email, String password, [String? displayName]) async {
    email = email.toLowerCase().trim();
    displayName = displayName?.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      displayName ??= 'user_${getRandomString(4)}';

      String? username;
      AppUser? appUserUsername;
      do {
        username = '$displayName#${getRandomString(4)}'.toLowerCase();
        appUserUsername = await AppFirebase.userCollectionRef.where('username', isEqualTo: username).get()
            .then((value) => value.docs[0].data());
      } while (appUserUsername != null);

      AppUser appUser = AppUser(
        uid: user.uid,
        email: email,
        displayName: displayName,
        username: username,
        dailyPokemonDate: getFormattedDate(DateTime.now().add(const Duration(days: -1))),
        pokemons: {},
        friends: [],
      );

      await user.updateDisplayName(displayName);
      await AppFirebase.userCollectionRef.doc(user.uid).set(appUser);
      return appUser;
    } on FirebaseAuthException {
      return null;
    }
  }

  /// Update the user's display name in Firebase Authentication and Firestore
  static Future<AppUser?> login(String email, String password) async {
    email = email.toLowerCase().trim();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      return AppFirebase.userCollectionRef.doc(user.uid).get().then((value) => value.data());
    } on FirebaseAuthException {
      return null;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }


  static Future<void> deleteCurrentUser() async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    await AppFirebase.askFriendCollectionRef
        .where(Filter.or(Filter('from_user', isEqualTo: uuid), Filter('to_user', isEqualTo: uuid)))
        .get().then((value) => value.docs.map((element) async => await element.reference.delete()));

    await AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid).delete();
    await FirebaseAuth.instance.currentUser!.delete();
  }

  static Future<bool> checkIfUserConnected() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      return false;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    return await AppFirebase.userCollectionRef.doc(user.uid).get().then((value) => value.exists);
  }

  static Future<AppUser?> getUser([String? uid]) async {
    uid ??= FirebaseAuth.instance.currentUser!.uid;
    return await AppFirebase.userCollectionRef.doc(uid).get().then((value) {
      AppUser? appUser = value.data();
      return appUser;
    });
  }

  static Future<List<AppUser>> getUsersByUsername(String username) async {
    List<String> usernameSplit = username.split('#');
    if (usernameSplit.length != 2) return [];
    String displayName = usernameSplit[0];
    String tag = usernameSplit[1];

    username = '${displayName.toLowerCase().trim()}#${tag.trim()}';
    QuerySnapshot<AppUser> snapshot = await AppFirebase.userCollectionRef
        .where('username', isEqualTo: username).get();
    return snapshot.docs.map((e) {
      AppUser appUser = e.data();
      return appUser;
    }).toList();
  }

  static Future<void> updateDisplayName(String displayName) async {
    displayName = displayName.trim();
    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
    await AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'display_name': displayName});
  }

  static Future<void> updateEmail(String email) async {
    email = email.toLowerCase().trim();
    await FirebaseAuth.instance.currentUser!.updateEmail(email); // TODO : Check if email is already used, verify email
    await AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'email': email});
  }

  static Future<void> updatePassword(String password) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
  }

  static updateUser(AppUser appUser) {
    AppFirebase.userCollectionRef.doc(appUser.uid).set(appUser);
  }
}