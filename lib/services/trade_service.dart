import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/app_user.dart';
import '../models/pokemon.dart';
import '../models/trade.dart';
import '../utilities/app_utils.dart';
import 'app_user_service.dart';
import 'pokemon_service.dart';

class TradeService {
  static final CollectionReference<Trade> tradeCollectionRef =
      FirebaseFirestore.instance.collection('trade').withConverter(
            fromFirestore: Trade.fromFirestore,
            toFirestore: (Trade trade, _) => trade.toFirestore(),
          );

  static Future<Pokemon> doTrade(Trade trade) async {
    AppUser? connectedUser = await AppUserService.getUser();
    String connectedUserId = connectedUser!.uid;

    AppUser? friend = await AppUserService
        .getUser(trade.betweenUsers.firstWhere((element) => element != connectedUserId));

    int connectedUserPokemonId = connectedUser.dailyPokemonId;
    int friendPokemonId = friend!.dailyPokemonId;

    connectedUser.dailyPokemonId = friendPokemonId;
    connectedUser.pokemons[connectedUserPokemonId.toString()] = getFormattedDate();

    friend.dailyPokemonId = connectedUserPokemonId;
    friend.pokemons[friendPokemonId.toString()] = getFormattedDate();

    await AppUserService.updateUser(connectedUser);
    await AppUserService.updateUser(friend);

    trade.lastTradeDate = getFormattedDate();
    trade.lastRequester = '';
    await tradeCollectionRef.doc(trade.id).update(trade.toFirestore());

    return await PokemonService.fetchPokemon(friendPokemonId);
  }

  /// Returns a boolean to indicate if the trade was accepted or not
  /// Returns null if the trade has already been requested by the user
  static Future<dynamic> askTrade(AppUser friend) async {
    String connectedUserId = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Trade> potentialTrades =
        await tradeCollectionRef.where('between_users', whereIn: [[connectedUserId, friend.uid], [friend.uid, connectedUserId]]).get();
    Trade? trade;
    if (potentialTrades.docs.isEmpty) {
      trade = Trade(
          betweenUsers: [connectedUserId, friend.uid],
          lastTradeDate: getFormattedDate(),
          lastRequester: connectedUserId);

      trade = await tradeCollectionRef.add(trade).then((value) {
        trade!.id = value.id;
        return trade;
      });

      return false; // trade created
    } else {
      trade = potentialTrades.docs.first.data();

      if (trade.lastTradeDate == getFormattedDate() && trade.lastRequester != '') {
        // trade ongoing
        if (trade.lastRequester == connectedUserId) {
          return null; // trade already requested
        } else {
          return await doTrade(trade); // trade accepted
        }
      } else if (trade.lastTradeDate != getFormattedDate()) {
        trade.lastTradeDate = getFormattedDate();
        trade.lastRequester = connectedUserId;
        await tradeCollectionRef.doc(trade.id).update(trade.toFirestore());
        return false; // trade created
      }

      return true; // trade already done
    }
  }
}
