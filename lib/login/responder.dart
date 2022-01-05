import 'package:haja/constants.dart';

class ResponseData {
  String user, pass, provider;
  bool validated = false;
  String? failure = 'Check the network connection';

  ResponseData({
    this.user = '',
    this.pass = '',
    this.provider = '',
  });
}

class AppDebugLogin {
  static const bool bypass = false;
  static const String debugUserEmail = 'elijahstormai@gmail.com';
  static const String debugUserPass = 'tester';

  static const String username = 'fake user';
  static const String email = 'fake_email@gmail.com';
  static const String id = 'fake_id';
  static const String icon = '${Constants.liveSvgs}fake_icon.svg';
}
