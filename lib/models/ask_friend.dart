import 'package:cloud_firestore/cloud_firestore.dart';

class AskFriend {
  late String? uid;
  late String? fromUser;
  late String? toUser;

  AskFriend({this.uid, this.fromUser, this.toUser});

  factory AskFriend.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    return AskFriend(
      fromUser: data?['from_user'],
      toUser: data?['to_user'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'from_user': fromUser,
      'to_user': toUser,
    };
  }
}