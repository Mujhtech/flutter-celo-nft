import 'dart:convert';

import 'package:flutter_celo_composer/module/home/model/nft_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

part 'nft_state.dart';

class NftCubit extends Cubit<NftState> {
  NftCubit({required this.connector}) : super(const NftState());
  final WalletConnect connector;

  Future<void> fetchNfts() async {
    try {
      emit(FetchNftLoading());

      final http.Response res = await http.Client().get(
          Uri.parse(
              'https://deep-index.moralis.io/api/v2/${connector.session.accounts[0]}/nft?chain=eth&format=decimal&media_items=false'),
          headers: <String, String>{
            'Accept': 'application/json',
            'X-API-Key': dotenv.get('NFTCOLLECTION_CONTRACT_ADDRESS')
          });

      if (!<int>[200, 201, 202].contains(res.statusCode)) {
        throw 'Failed to fetch data';
      }

      List<dynamic> rawdata = json.decode(res.body)['result'];

      emit(FetchNftSuccess(
          nfts: rawdata
              .map((dynamic e) => NftModel.fromMap(e as Map<String, dynamic>))
              .toList()));
    } catch (e) {
      emit(FetchNftFailed(errorCode: '', message: e.toString()));
    }
  }
}
