import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_celo_composer/internal/ethereum_credentials.dart';
import 'package:flutter_celo_composer/internal/web3_contract.dart';
import 'package:flutter_celo_composer/internal/web3_utils.dart';
import 'package:flutter_celo_composer/module/home/models/nft_model.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:web3dart/web3dart.dart';

part 'web3_state.dart';

class Web3Cubit extends Cubit<Web3State> {
  Web3Cubit({
    required this.web3Client,
    required this.nftCollectionContract,
  }) : super(const Web3State());

  // core declarations
  final Web3Client web3Client;
  final DeployedContract nftCollectionContract;
  late String sender;
  late SessionStatus sessionStatus;
  late EthereumWalletConnectProvider provider;
  late WalletConnect walletConnector;
  late WalletConnectEthereumCredentials wcCredentials;

  // contract-specific declarations
  late Timer fetchTokenCountTimer;

  /// Terminates metamask, provider, contract connections
  void closeConnection() {
    fetchTokenCountTimer.cancel();
    walletConnector.killSession();
    walletConnector.close();

    emit(SessionTerminated());
  }

  /// Initialize provider provided by [session] and [connector]
  void initializeProvider({
    required WalletConnect connector,
    required SessionStatus session,
  }) {
    walletConnector = connector;
    sessionStatus = session;
    sender = connector.session.accounts[0];
    provider = EthereumWalletConnectProvider(connector);
    wcCredentials = WalletConnectEthereumCredentials(provider: provider);

    /// periodically fetch greeting from chain
    fetchTokenCountTimer =
        Timer.periodic(const Duration(seconds: 5), (_) => fetchTokenCount());
    emit(InitializeProviderSuccess(
        accountAddress: sender, networkName: getNetworkName(session.chainId)));
  }

  /// Greeter contract

  /// Get greeting from
  Future<void> fetchTokenCount() async {
    try {
      List<dynamic> response = await web3Client.call(
        contract: nftCollectionContract,
        function: nftCollectionContract.function(getTokenCounterFunction),
        params: <dynamic>[],
      );
      emit(FetchTokenCountSuccess(counter: (response[0] as BigInt).toInt()));
    } catch (e) {
      emit(FetchTokenCountFailed(errorCode: '', message: e.toString()));
    }
  }

  Future<void> mint(String nftUrl) async {
    emit(MintLoading());
    try {
      String txnHash = await web3Client.sendTransaction(
        wcCredentials,
        Transaction.callContract(
          contract: nftCollectionContract,
          function: nftCollectionContract.function(minFunction),
          from: EthereumAddress.fromHex(sender),
          parameters: <dynamic>[nftUrl],
        ),
        chainId: sessionStatus.chainId,
      );

      late Timer txnTimer;
      txnTimer = Timer.periodic(
          Duration(milliseconds: getBlockTime(sessionStatus.chainId)),
          (_) async {
        TransactionReceipt? t = await web3Client.getTransactionReceipt(txnHash);
        if (t != null) {
          emit(const MintSuccess());
          fetchTokenCount();
          txnTimer.cancel();
        }
      });
    } catch (e) {
      emit(MintFailed(errorCode: '', message: e.toString()));
    }
  }

  Future<List<NftModel>> fetchAllNft(int totalTokenCounter) async {
    try {
      final List<NftModel> nfts = <NftModel>[];
      for (int i = 0; i < totalTokenCounter; i++) {
        List<dynamic> response = await web3Client.call(
          contract: nftCollectionContract,
          function: nftCollectionContract.function(tokenURIFunction),
          params: <dynamic>[BigInt.from(i)],
        );

        nfts.add(NftModel(tokenId: i, tokenUri: response[0]));
      }

      return nfts;
    } catch (e) {
      //

      throw e.toString();
    }
  }
}
