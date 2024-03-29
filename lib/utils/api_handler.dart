// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:giphy_challenge/utils/enum_utils.dart';
import 'package:giphy_challenge/utils/enums.dart';
import 'package:http/http.dart' as http;

class ApiHandler {
  late final String apiKey;
  static const String _keyNameApiKey = "api_key";
  static const String _keyNameLimit = "limit";
  static const String _keyNameOffset = "offset";
  static const String _keyNameRating = "rating";
  static const String _keyNameBundle = "bundle";
  static const String _keyNameLang = "lang";
  static const String _keyNameQuery = "q";
  ApiHandler() {
    apiKey = dotenv.get("GIPHY_API_KEY");
  }

  Future<Map> getGiphyTrending({
    int limit = 10,
    int offset = 0,
    Rating rating = Rating.g,
    Bundle bundle = Bundle.messaging_non_clips,
  }) async {
    Uri url = Uri.https("api.giphy.com", "/v1/gifs/trending", {
      _keyNameApiKey: apiKey,
      _keyNameLimit: limit.toString(),
      _keyNameOffset: offset.toString(),
      _keyNameRating: enumToString(rating),
      _keyNameBundle: enumToString(bundle),
    });

    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map;
    return data;
  }

  Future<Map> searchGiphy(
    String query, {
    int limit = 10,
    int offset = 0,
    String lang = "en",
    Rating rating = Rating.g,
    Bundle bundle = Bundle.messaging_non_clips,
  }) async {
    Uri url = Uri.https("api.giphy.com", "/v1/gifs/search", {
      _keyNameApiKey: apiKey,
      _keyNameQuery: query,
      _keyNameLimit: limit.toString(),
      _keyNameOffset: offset.toString(),
      _keyNameRating: enumToString(rating),
      _keyNameLang: lang,
      _keyNameBundle: enumToString(bundle),
    });

    final response = await http.get(url);
    final data = jsonDecode(response.body) as Map;
    return data;
  }
}
