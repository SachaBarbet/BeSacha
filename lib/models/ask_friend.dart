import 'package:cloud_firestore/cloud_firestore.dart';

class AskFriend {
  late final String id;
  late final String fromUser;
  late final String toUser;

  AskFriend({this.id = '', required this.fromUser, required this.toUser});

  factory AskFriend.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    return AskFriend(
      id: snapshot.id,
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