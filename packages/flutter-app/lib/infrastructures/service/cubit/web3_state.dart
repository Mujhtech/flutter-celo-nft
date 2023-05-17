part of 'web3_cubit.dart';

class Web3State {
  const Web3State();
}

/// Event classes

class InitializeProviderLoading extends Web3State {
  InitializeProviderLoading();
}

class InitializeProviderSuccess extends Web3State {
  const InitializeProviderSuccess({
    required this.accountAddress,
    required this.networkName,
  });

  final String accountAddress;
  final String networkName;
}

class InitializeProviderFailed extends Web3State {
  const InitializeProviderFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class SessionTerminated extends Web3State {
  SessionTerminated();
}

/// Greeter contract
/// Contains Greeter contract related events

class FetchTokenCountLoading extends Web3State {
  FetchTokenCountLoading();
}

class FetchTokenCountSuccess extends Web3State {
  const FetchTokenCountSuccess({required this.counter});
  final int counter;
}

class FetchTokenCountFailed extends Web3State {
  const FetchTokenCountFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

class MintLoading extends Web3State {
  MintLoading();
}

class MintSuccess extends Web3State {
  const MintSuccess();
}

class MintFailed extends Web3State {
  const MintFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}

/// TODO: <another> contract
/// You can add and specify more contracts here