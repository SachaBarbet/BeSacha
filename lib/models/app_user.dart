import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  late String? uid;
  late String? email;
  late String? username;
  late String? displayName;

  AppUser({this.uid, this.email, this.username, this.displayName});

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    return AppUser(
      email: data?['email'],
      username: data?['username'],
      displayName: data?['display_name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'display_name': displayName,
    };
  }
}