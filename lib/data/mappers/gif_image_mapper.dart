import 'package:giphy_challenge/model/image.dart';

class GifImageMapper {
  final String _keyNameUrl = "url";
  final String _keyNameHeigt = "height";
  final String _keyNameWidth = "width";
  GifImage map(Map<String, dynamic> rawData) {
    return GifImage(
      url: rawData[_keyNameUrl],
      height: int.tryParse(rawData[_keyNameHeigt]) ?? 0,
      width: int.tryParse(rawData[_keyNameWidth]) ?? 0,
    );
  }
}
