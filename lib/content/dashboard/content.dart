import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'display.dart';
import '../content.dart';

class DashboardContent extends ContentContainer {
  static const String collectionName = 'dashboard';

  @override
  String get collection => collectionName;

  final contentType = CONTENT.dashboard;

  @override
  bool get privateData => true;

  final String type;
  final Map<String, dynamic> data;

  DashboardContent({
    required this.type,
    required this.data,
    required title,
    required caption,
    required id,
  }) : super(
          title: title,
          caption: caption,
          id: id,
        );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'type': type,
        'data': data,
      };
  static dynamic fromJson(dynamic data) => DashboardContent(
        title: data['title'],
        caption: data['caption'],
        type: data['type'],
        data: data['data'],
        id: data['id'],
      );

  @override
  bool find(String query) {
    return type == query;
  }

  @override
  DashboardContentDisplayPage navigator() {
    return DashboardContentDisplayPage(this);
  }

  Color color(BuildContext context) {
    Color color = Theme.of(context).primaryColor;

    switch (data['fileSource']) {
      case 'document':
        color = Theme.of(context).primaryColor;
        break;
      case 'google':
        color = const Color(0xFFFFA113);
        break;
      case 'one drive':
        color = const Color(0xFFA4CDFF);
        break;
      case 'dropbox':
        color = const Color(0xFF007EE5);
        break;
      default:
        color = Theme.of(context).primaryColor;
        break;
    }

    return color;
  }

  Widget get icon {
    String asset = 'assets/icons/Documents.svg';
    Color? color;

    if (type == 'overview') {
      switch (data['fileSource']) {
        case 'document':
          asset = 'assets/icons/Documents.svg';
          break;
        case 'google':
          asset = 'assets/icons/google_drive.svg';
          color = const Color(0xFFFFA113);
          break;
        case 'one drive':
          asset = 'assets/icons/one_drive.svg';
          color = const Color(0xFFA4CDFF);
          break;
        case 'dropbox':
          asset = 'assets/icons/drop_box.svg';
          color = const Color(0xFF007EE5);
          break;
        default:
          asset = 'assets/icons/Documents.svg';
          break;
      }
    } else if (type == 'storage') {
      switch (data['fileSource']) {
        case 'document':
          asset = 'assets/icons/Documents.svg';
          break;
        case 'media':
          asset = 'assets/icons/media.svg';
          color = const Color(0xFF26E5FF);
          break;
        case 'other':
          asset = 'assets/icons/folder.svg';
          color = const Color(0xFFFFCF26);
          break;
        case 'unknown':
          asset = 'assets/icons/unknown.svg';
          color = const Color(0xFFEE2727);
          break;
        default:
          asset = 'assets/icons/Documents.svg';
          break;
      }
    }

    return SvgPicture.asset(
      asset,
      color: color,
    );
  }
}
