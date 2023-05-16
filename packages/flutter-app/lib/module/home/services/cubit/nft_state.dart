part of 'nft_cubit.dart';

class NftState {
  const NftState();
}

class FetchNftLoading extends NftState {
  FetchNftLoading();
}

class FetchNftSuccess extends NftState {
  const FetchNftSuccess({required this.nfts});
  final List<NftModel> nfts;
}

class FetchNftFailed extends NftState {
  const FetchNftFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
