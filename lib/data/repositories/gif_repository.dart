// ignore_for_file: avoid_print

import 'package:giphy_challenge/data/mappers/gif_mapper.dart';
import 'package:giphy_challenge/model/gif.dart';
import 'package:giphy_challenge/utils/api_handler.dart';

class GifRepository {
  final GifMapper _gifMapper;
  final ApiHandler _apiHandler;
  final List<Gif> _gifCache = [];
  final List<Gif> _gifSearchCache = [];
  final String _keyNameData = "data";

  GifRepository()
      : _gifMapper = GifMapper(),
        _apiHandler = ApiHandler();

  Future<List<Gif>> getTrendingGifs() async {
    if (_gifCache.isEmpty) {
      await _fetchGifs();
    }
    return _gifCache;
  }

  Future<void> _fetchGifs() async {
    try {
      final response = await _apiHandler.getGiphyTrending();
      final List rawGifs = response[_keyNameData];
      final List<Gif> gifs = [];
      for (var rawGif in rawGifs) {
        final Gif gif = _gifMapper.map(rawGif as Map<String, dynamic>);
        gifs.add(gif);
      }
      _gifCache
        ..clear()
        ..addAll(gifs);
    } catch (error) {
      print(error);
    }
  }

  Future<List<Gif>> searchGiphy({required String query, int offset = 0}) async {
    try {
      final response = await _apiHandler.searchGiphy(query, offset: offset);
      final List rawGifs = response[_keyNameData];
      final List<Gif> gifs = [];
      for (var rawGif in rawGifs) {
        final Gif gif = _gifMapper.map(rawGif as Map<String, dynamic>);
        gifs.add(gif);
      }
      if (offset == 0) {
        _gifSearchCache
          ..clear()
          ..addAll(gifs);
      }
      _gifSearchCache.addAll(gifs);
      return _gifSearchCache;
    } catch (error) {
      print(error);
      rethrow;
    }
  }
}
