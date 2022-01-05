import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'display.dart';
import '../content.dart';

class FileContent extends ContentContainer {
  static const String collectionName = 'files';

  @override
  String get collection => collectionName;
  final contentType = CONTENT.file;

  @override
  bool get privateData => true;

  final String cloudLink;
  final int fileType;
  final DateTime createdOn, editedOn;

  FileContent({
    required this.cloudLink,
    required this.fileType,
    required this.createdOn,
    required this.editedOn,
    required title,
    required caption,
    required id,
  }) : super(
          title: title,
          caption: caption,
          id: id,
        );

  factory FileContent.fromJson(dynamic data) => FileContent(
        title: data['title'],
        caption: data['caption'],
        cloudLink: data['cloudLink'],
        fileType: data['fileType'],
        createdOn: data['createdOn'].toDate(),
        editedOn: data['editedOn'].toDate(),
        id: data['id'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'caption': caption,
        'cloudLink': cloudLink,
        'fileType': fileType,
        'createdOn': Timestamp.fromDate(createdOn),
        'editedOn': Timestamp.fromDate(editedOn),
      };

  @override
  FileContentDisplayPage navigator() {
    return FileContentDisplayPage(this);
  }

  Widget get icon {
    String asset = 'assets/icons/doc_file.svg';

    switch (fileType) {
      case 0:
        asset = 'assets/icons/xd_file.svg';
        break;
      case 1:
        asset = 'assets/icons/Figma_file.svg';
        break;
      case 2:
        asset = 'assets/icons/doc_file.svg';
        break;
      case 3:
        asset = 'assets/icons/sound_file.svg';
        break;
      case 4:
        asset = 'assets/icons/media_file.svg';
        break;
      case 5:
        asset = 'assets/icons/pdf_file.svg';
        break;
      case 6:
        asset = 'assets/icons/excle_file.svg';
        break;
      default:
        asset = 'assets/icons/doc_file.svg';
        break;
    }

    return SvgPicture.asset(
      asset,
    );
  }
}
