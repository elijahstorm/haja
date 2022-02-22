import 'package:haja/content/content.dart';
import 'package:haja/content/teams/content.dart';
import 'package:haja/firebase/auth.dart';
import 'package:haja/content/notifications/content.dart';
import 'package:haja/content/todo/content.dart';
import 'package:haja/content/users/content.dart';

class NotificationsApi {
  static _NotificationHandler instance = _NotificationHandler();

  static void send({
    required ContentContainer? to,
    required NotificationContent noto,
  }) async {
    if (AuthApi.activeUser == null || to == null) return;

    UserContent? from = await UserContent.fromId(AuthApi.activeUser!);

    if (from == null || to == from) return;

    noto.sourceId = to.id;

    if (to.collection == TeamContent.collectionName) {
      noto.isTeam = true;
    }

    noto.upload();
  }
}

class _NotificationHandler {
  Map<NotificationContent, bool> active = {};
  Map<TodoContent, NotificationContent> synchedFromContent = {};

  void add({
    required NotificationContent noto,
    required ContentContainer? to,
  }) async {
    active[noto] = true;

    await Future.delayed(const Duration(seconds: 5));

    if (active[noto] ?? false) {
      NotificationsApi.send(
        to: to,
        noto: noto,
      );
    } else {
      active.remove(noto);
    }
  }

  void remove(NotificationContent noto) {
    active[noto] = false;
  }

  NotificationContent? todoLiked(TodoContent todo) {
    if (AuthApi.activeUser == null) return null;

    if (synchedFromContent[todo] != null) return synchedFromContent[todo]!;

    synchedFromContent[todo] = NotificationContent(
      date: DateTime.now(),
      type: '',
      status: '',
      title: '',
      caption: '',
      id: '98fa9s7fa',
      fromId: AuthApi.activeUser!,
    );

    return synchedFromContent[todo]!;
  }

  NotificationContent? todoComplete(TodoContent todo) {
    if (AuthApi.activeUser == null) return null;

    if (synchedFromContent[todo] != null) return synchedFromContent[todo]!;

    synchedFromContent[todo] = NotificationContent(
      date: DateTime.now(),
      type: 'teting',
      status: '',
      title: '',
      caption: '',
      id: '1234',
      fromId: AuthApi.activeUser!,
    );

    return synchedFromContent[todo]!;
  }
}
