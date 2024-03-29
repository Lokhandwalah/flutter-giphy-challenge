import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:giphy_challenge/data/repositories/gif_repository.dart';
import 'package:giphy_challenge/model/gif.dart';

part 'gif_event.dart';
part 'gif_state.dart';

class GifBloc extends Bloc<GifEvent, GifState> {
  final GifRepository _repository;
  GifBloc()
      : _repository = GifRepository(),
        super(GifInitial()) {
    on<GetTrendingEvent>(_handleGetTrending);
    on<GifSearchEvent>(_handleSearch);
    on<GifSearchPaginateEvent>(_handleSearchPaginate);
    on<ErrorEvent>(_handleError);
  }

  void _handleGetTrending(
      GetTrendingEvent event, Emitter<GifState> emit) async {
    final List<Gif> gifs = await _repository.getTrendingGifs();
    emit(GifInitialized(gifs: gifs));
  }

  void _handleSearch(GifSearchEvent event, Emitter<GifState> emit) async {
    try {
      final List<Gif> gifs = await _repository.searchGiphy(query: event.query);
      emit(GifInitialized(gifs: gifs));
    } catch (error) {
      emit(GifError(message: "Something went wrong"));
    }
  }

  void _handleSearchPaginate(
      GifSearchPaginateEvent event, Emitter<GifState> emit) async {
    try {
      final List<Gif> gifs = await _repository.searchGiphy(
          query: event.query, offset: event.offset);
      emit(GifInitialized(gifs: gifs, paginationOffset: event.offset));
    } catch (error) {
      emit(GifError(message: "Something went wrong"));
    }
  }

  void _handleError(ErrorEvent event, Emitter<GifState> emit) async {
    emit(GifError(message: event.message));
  }
}
