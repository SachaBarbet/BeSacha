import 'package:cloud_firestore/cloud_firestore.dart';

class Trade {
  late String id;
  late List<dynamic> betweenUsers;
  late String lastTradeDate;

  Trade({
    this.id = '',
    required this.betweenUsers,
    required this.lastTradeDate,
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
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'between_users': betweenUsers,
      'last_trade_date': lastTradeDate,
    };
  }
}