import 'package:giphy_challenge/model/image.dart';
import 'package:giphy_challenge/utils/enums.dart';

class Gif {
  final String type;
  final String id;
  final String slug;
  final String url;
  final String bitlyUrl;
  final String embedUrl;
  final String source;
  final String title;
  final Rating rating;
  final GifImage image;

  Gif({
    required this.type,
    required this.id,
    required this.slug,
    required this.url,
    required this.bitlyUrl,
    required this.embedUrl,
    required this.source,
    required this.rating,
    required this.title,
    required this.image,
  });
}
