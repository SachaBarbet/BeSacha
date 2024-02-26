import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  late String? uid;
  late String? email;
  late String? displayName;
  late String? phoneNumber;
  late String? photoUrl;

  AppUser({this.uid, this.email, this.displayName, this.phoneNumber, this.photoUrl});

  factory AppUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    return AppUser(
      email: data?["email"],
      displayName: data?["display_name"],
      phoneNumber: data?["phone_number"],
      photoUrl: data?["photo_url"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "email": email,
      "display_name": displayName,
      "phone_number": phoneNumber,
      "photo_url": photoUrl,
    };
  }
}