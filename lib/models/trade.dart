import 'package:cloud_firestore/cloud_firestore.dart';

class Trade {
  late String id;
  late List<dynamic> betweenUsers;
  late String lastTradeDate;
  late String lastRequester;

  Trade({
    this.id = '',
    required this.betweenUsers,
    required this.lastTradeDate,
    this.lastRequester = '',
  });

  factory Trade.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    Map<String, dynamic>? data = snapshot.data();
    return Trade(
      id: snapshot.id,
      betweenUsers: data?['between_users'],
      lastTradeDate: data?['last_trade_date'],
      lastRequester: data?['last_requester'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'between_users': betweenUsers,
      'last_trade_date': lastTradeDate,
      'last_requester': lastRequester,
    };
  }
}