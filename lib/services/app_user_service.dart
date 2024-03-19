import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../utilities/app_utils.dart';

class AppUserService {
  static final CollectionReference<AppUser> userCollectionRef = FirebaseFirestore.instance.collection('users')
      .withConverter(fromFirestore: AppUser.fromFirestore, toFirestore: (AppUser user, _) => user.toFirestore(),);

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
        QuerySnapshot<AppUser> appUserUsernameList = await userCollectionRef
            .where('username', isEqualTo: username).get();
        appUserUsername = appUserUsernameList.docs.isNotEmpty ? appUserUsernameList.docs.first.data() : null;

      } while (appUserUsername != null);

      AppUser appUser = AppUser(
        uid: user.uid,
        email: email,
        displayName: displayName,
        username: username,
        dailyPokemonDate: getFormattedDate(DateTime.now().add(const Duration(days: -1))),
        pokemons: {},
        friends: [],
        dailyPokemonId: 0,
      );

      await user.updateDisplayName(displayName);
      await userCollectionRef.doc(user.uid).set(appUser);
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
      return userCollectionRef.doc(user.uid).get().then((value) => value.data());
    } on FirebaseAuthException {
      return null;
    }
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }


  static Future<void> deleteCurrentUser() async {
    String uuid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('ask_friends')
        .where(Filter.or(Filter('from_user', isEqualTo: uuid), Filter('to_user', isEqualTo: uuid)))
        .get().then((value) => value.docs.map((element) async => await element.reference.delete()));

    await userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid).delete();
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
    return await userCollectionRef.doc(user.uid).get().then((value) => value.exists);
  }

  static Future<AppUser?> getUser([String? uid]) async {
    uid ??= FirebaseAuth.instance.currentUser!.uid;
    return await userCollectionRef.doc(uid).get().then((value) {
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
    QuerySnapshot<AppUser> snapshot = await userCollectionRef
        .where('username', isEqualTo: username).get();
    return snapshot.docs.map((e) {
      AppUser appUser = e.data();
      return appUser;
    }).toList();
  }

  static Future<void> updateDisplayName(String displayName) async {
    displayName = displayName.trim();
    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
    await userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'display_name': displayName});
  }

  static Future<void> updateEmail(String email) async {
    email = email.toLowerCase().trim();
    await FirebaseAuth.instance.currentUser!.updateEmail(email); // TODO : Check if email is already used, verify email
    await userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'email': email});
  }

  static Future<void> updatePassword(String password) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
  }

  static updateUser(AppUser appUser) {
    userCollectionRef.doc(appUser.uid).set(appUser);
  }
}