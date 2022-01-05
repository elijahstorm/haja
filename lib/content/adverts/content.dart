import 'display.dart';
import '../content.dart';

class AdvertisementContent extends ContentContainer {
  static const String collectionName = 'adverts';

  @override
  String get collection => collectionName;

  final contentType = CONTENT.ad;

  final String link;

  AdvertisementContent({
    required this.link,
    required title,
    required caption,
    required id,
  }) : super(
          title: title,
          caption: caption,
          id: id,
        );

  factory AdvertisementContent.fromJson(dynamic data) => AdvertisementContent(
        title: data['title'],
        caption: data['caption'],
        link: data['link'],
        id: data['id'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'link': link,
      };

  @override
  AdvertisementContentDisplayPage navigator() {
    return AdvertisementContentDisplayPage(this);
  }
}
