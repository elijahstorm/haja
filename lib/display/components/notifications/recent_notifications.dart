import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:haja/content/notifications/content.dart';
import 'package:haja/content/notifications/cache.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';

class RecentNotifications extends StatelessWidget {
  final _notificationContainerSize = 50.0;

  const RecentNotifications({
    Key? key,
  }) : super(key: key);

  void _delete(NotificationCache cache, int index) {
    var item = cache.items[index];
    item.delete();
    cache.remove(item);
  }

  Widget _buildNotificationList(
    BuildContext context,
    NotificationCache cache,
  ) =>
      Column(
        children: List.generate(
          cache.items.length,
          (index) {
            return GestureDetector(
              onTap: () {
                cache.items[index].navigateTo(context);
              },
              child: Slidable(
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      label: Language.deleteButton,
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) {
                        _delete(cache, index);
                      },
                    ),
                  ],
                ),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      label: Language.deleteButton,
                      backgroundColor: Colors.red,
                      icon: Icons.delete,
                      onPressed: (context) {
                        _delete(cache, index);
                      },
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: index == cache.items.length - 1
                        ? 0
                        : Constants.defaultPadding,
                  ),
                  child: _buildNotificationItem(context, cache.items[index]),
                ),
              ),
            );
          },
        ),
      );

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationContent notification,
  ) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          notification.hasStory
              ? Container(
                  width: _notificationContainerSize,
                  height: _notificationContainerSize,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).colorScheme.secondary,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                      ),
                      child: notification.fromWho.icon,
                    ),
                  ),
                )
              : Container(
                  width: _notificationContainerSize,
                  height: _notificationContainerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    child: notification.fromWho.icon,
                  ),
                ),
          const SizedBox(width: Constants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: Constants.defaultPadding / 4,
                    ),
                    Text(
                      Language.timeSinceDate(
                        notification.date,
                        short: true,
                      ),
                      style: TextStyle(
                        color:
                            Theme.of(context).iconTheme.color!.withOpacity(.7),
                      ),
                    ),
                  ],
                ),
                Text(
                  notification.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: Constants.defaultPadding),
          notification.postImage != null
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: _notificationContainerSize,
                  height: _notificationContainerSize,
                  child: ClipRRect(
                    child: notification.postImage,
                  ),
                )
              : Container(
                  height: 35,
                  width: 110,
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      Language.followButton,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ],
      );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Language.appScreenHeaderRecentNotos,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          const SizedBox(height: Constants.defaultPadding),
          Consumer<NotificationCache>(
            builder: (context, cache, child) => _buildNotificationList(
              context,
              cache,
            ),
          ),
        ],
      );
}
