import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../utilities/app_utils.dart';
import 'app_firebase.dart';

class AppUserService {

  /// Register a new user with email and password in Firebase Authentication and Firestore
  static Future<AppUser?> register(String email, String password, [String? displayName, String? phoneNumber, String? photoUrl]) async {
    email = email.toLowerCase().trim();
    displayName = displayName?.trim();
    phoneNumber = phoneNumber?.trim();
    photoUrl = photoUrl?.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      displayName ??= 'user_${AppUtil.getRandomString(8)}';
      AppUser appUser = AppUser(
        uid: user.uid,
        email: email,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );
      await user.updateDisplayName(displayName); // Need firebase app check
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
    await FirebaseAuth.instance.currentUser!.delete();
    await AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid).delete();
  }

  static Future<bool> checkIfUserConnected() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
    } catch (e) {
      return false;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (FirebaseAuth.instance.currentUser == null) return false;
    return await AppFirebase.userCollectionRef.doc(user!.uid).get().then((value) => value.exists);
  }

  static Future<bool> isEmailInDB(String email) async {
    // check si connecté à internet
    bool connectedToInternet = false;
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      await deviceInfoPlugin.webBrowserInfo;
      connectedToInternet = true;
    } catch (e) {
      List<InternetAddress> result = await InternetAddress.lookup('8.8.8.8');
      connectedToInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    }

    if (!connectedToInternet) return false;

    QuerySnapshot<AppUser> snapshot = await AppFirebase.userCollectionRef.where('email', isEqualTo: email).get();
    return snapshot.docs.isNotEmpty;
  }

  static Future<String> getCurrentDisplayName() async {
    try {
      return FirebaseAuth.instance.currentUser!.displayName!;
    } catch (e) {
      return e.toString();
    }
  }

  static Future<AppUser?> getUser([String? uid]) async {
    uid ??= FirebaseAuth.instance.currentUser!.uid;
    return await AppFirebase.userCollectionRef.doc(uid).get().then((value) => value.data());
  }

  static Future<void> updateDisplayName(String displayName) async {
    displayName = displayName.trim();
    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
    await AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'display_name': displayName});
  }

  static Future<void> updateEmail(String email) async {
    email = email.toLowerCase().trim();
    await FirebaseAuth.instance.currentUser!.updateEmail(email);
    await AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'email': email});
  }

  static Future<void> updatePassword(String password) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
  }
}