part of 'art_cubit.dart';

class ArtState {
  const ArtState();
}

class FetchArtLoading extends ArtState {
  FetchArtLoading();
}

class FetchArtSuccess extends ArtState {
  const FetchArtSuccess({required this.url});
  final String url;
}

class FetchArtFailed extends ArtState {
  const FetchArtFailed({
    required this.errorCode,
    required this.message,
  });

  final String errorCode;
  final String message;
}
