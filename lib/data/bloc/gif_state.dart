part of 'gif_bloc.dart';

@immutable
sealed class GifState {}

final class GifInitial extends GifState {}

final class GifInitialized extends GifState {
  final List<Gif> gifs;
  final int paginationOffset;
  GifInitialized({required this.gifs, this.paginationOffset = 0});
}

final class GifError extends GifState {
  final String? message;
  GifError({this.message});
}
