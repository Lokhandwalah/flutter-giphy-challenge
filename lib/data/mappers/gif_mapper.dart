import 'package:giphy_challenge/data/mappers/gif_image_mapper.dart';
import 'package:giphy_challenge/model/gif.dart';
import 'package:giphy_challenge/model/image.dart';
import 'package:giphy_challenge/utils/enum_utils.dart';
import 'package:giphy_challenge/utils/enums.dart';

class GifMapper {
  final String _keyNamType = "type";
  final String _keyNamId = "id";
  final String _keyNameSlug = "slug";
  final String _keyNameUrl = "url";
  final String _keyNamebitlyUrl = "bitly_url";
  final String _keyNameEmbedUrl = "embed_url";
  final String _keyNameSource = "source";
  final String _keyNameRating = "rating";
  final String _keyNameTitle = "title";
  final String _keyNameImages = "images";
  final String _keyNameOriginal = "original";

  final GifImageMapper _gifImageMapper = GifImageMapper();

  Gif map(Map<String, dynamic> rawData) {
    return Gif(
      type: rawData[_keyNamType],
      id: rawData[_keyNamId],
      slug: rawData[_keyNameSlug],
      url: rawData[_keyNameUrl],
      bitlyUrl: rawData[_keyNamebitlyUrl],
      embedUrl: rawData[_keyNameEmbedUrl],
      source: rawData[_keyNameSource],
      title: rawData[_keyNameTitle],
      rating: convertStringToEnum(Rating.values, rawData[_keyNameRating]),
      image: getImage(Map<String, dynamic>.from(rawData[_keyNameImages][_keyNameOriginal])),
    );
  }

  GifImage getImage(Map<String, dynamic> imageData) {
    final GifImage gifImage = _gifImageMapper.map(imageData);
    return gifImage;
  }
}
