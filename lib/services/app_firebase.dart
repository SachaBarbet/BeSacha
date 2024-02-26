import 'dart:io';

import 'package:android_flutter_app_boilerplate/services/app_user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/app_user.dart';

class AppFirebase {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static CollectionReference<AppUser> userCollectionRef = AppFirebase.database.collection('users').withConverter(
    fromFirestore: AppUser.fromFirestore, toFirestore: (AppUser user, _) => user.toFirestore(),);

  static FirebaseStorage storage = FirebaseStorage.instance;
  static Reference storageRef = storage.ref();
  static Reference usersImagesStorageRef = storageRef.child('users/images/');

  static bool isUserConnected = false;

  static Future<void> initFirebaseAuth() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        isUserConnected = await AppUserService.checkIfUserConnected();
    });

    isUserConnected = await AppUserService.checkIfUserConnected();
  }

  static Future<String?> uploadFile(File file, String? userUUID) async {
    try {
      final String fileName = 'profile_image_$userUUID';
      final Reference ref = usersImagesStorageRef.child(fileName);
      final UploadTask uploadTask = ref.putFile(file);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print(e);
      return null;
    }
  }
}