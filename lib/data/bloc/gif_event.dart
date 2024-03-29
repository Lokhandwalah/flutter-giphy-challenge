part of 'gif_bloc.dart';

@immutable
sealed class GifEvent {}

class GetTrendingEvent extends GifEvent {}

class GifSearchEvent extends GifEvent {
  final String query;
  GifSearchEvent({required this.query});
}

class GifSearchPaginateEvent extends GifEvent {
  final String query;
  final int offset;
  GifSearchPaginateEvent({required this.query, required this.offset});
}

class ErrorEvent extends GifEvent {
  final String? message;
  ErrorEvent({this.message});
}
