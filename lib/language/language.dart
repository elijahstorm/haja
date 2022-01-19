import 'dart:developer';

class Language {
  static const String appName = 'Haja';
  static const String welcome = 'Let\'s do Together';
  static const String appSubtitle = 'Do Together';

  static const String addButton = 'add';
  static const String deleteButton = 'delete';
  static const String makeNewButton = 'new';
  static const String editButton = 'edit info';
  static const String followButton = 'follow';
  static const String unfollowButton = 'follow';
  static const String findMoreButton = 'find more';
  static const String retryButton = 'retry';
  static const String createNewTodoHint = 'start a new Todo';
  static const String searchPrompt = 'search';

  /// Team Language
  static const String teamTitle = 'title';
  static const String teamCaption = 'description';
  static const String teamPrivacy = 'team privacy';
  static const String teamPrivacyAction = 'make your team private';
  static const String teamPicture = 'team picture';
  static const String teamEditorTitle = 'edit your team';
  static const String teamEditorEmpty = '[empty]';
  static const String teamEditorPlaceholder = 'get creative...';
  static const String teamPictureHelp =
      'the teams main picture and can be seen by everyone in the team. if your team is public, this image is visible to everyone.';
  static const String teamTitleHelp = 'this is your team name.';
  static const String teamCaptionHelp = 'some information about your team.';
  static const String teamPrivacyHelp =
      'if you choose to keep this team private, it keeps this team from being searchable.';
  static const String upcomingTodos = 'Upcoming Todos';

  static const String accountSettings = 'account settings';
  static const String debugTestingOption = 'debug page';

  static const String logoutButton = 'log out';
  static const String reloginRequest = 'please make sure you are logged in';
  static const String reloginButton = 'log back in';
  static const String userstateError =
      'Something went wrong... if you keep seeing this, try logging out and logging back in';

  static const String waitingForContent = 'Awaiting Content...';
  static const String noDataFoundError = 'no data found';
  static const String oopsFriendlyError = 'Ooops! 😓';
  static const String pageNotFoundError = 'Page not found';

  static const String alertColorPrompt = 'Choose a new COLOR';
  static const String alertDateChangePrompt = 'Change the task date';

  static const String appNavBarTitlesHome = 'activity';
  static const String appNavBarTitlesTeams = 'teams';
  static const String appNavBarTitlesCalendar = 'calendar';
  static const String appNavBarTitlesNotos = 'likes';
  static const String appNavBarTitlesProfile = 'profile';

  static const String januaryName = 'january';
  static const String februaryName = 'february';
  static const String marchName = 'march';
  static const String aprilName = 'april';
  static const String mayName = 'may';
  static const String juneName = 'june';
  static const String julyName = 'july';
  static const String augustName = 'august';
  static const String septemberName = 'september';
  static const String octoberName = 'october';
  static const String novemberName = 'november';
  static const String decemberName = 'december';

  static const String promotionText = 'PROMOTION';

  static const String appScreenHeaderRecentNotos = 'recent notifications';
  static const String appScreenHeaderYourTeam = 'your teams';
  static const String appScreenHeaderYourCircle = 'in your circle';

  static const String filesName = 'File';
  static const String appScreenHeaderMyFiles = 'My Files';
  static const String appScreenHeaderRecentFiles = 'Recent Files';
  static const String appScreenHeaderStorageInfo = 'Storage Details';
  static const String appScreenHeaderNotos = 'Likes';
  static const String appScreenHeaderActivity = 'Activity';

  static const String loadingActiveTeamTodos = 'Loading active Todos...';

  static const String inDevelopmentApology =
      'Sorry, this feature is still in development.';

  static String countableWithTrailingS(
    int countable,
    String output, {
    bool forceEs = false,
  }) {
    return '$countable $output${countable != 1 ? '${forceEs ? 'e' : ''}s' : ''}';
  }

  static String timeSinceDate(
    DateTime date, {
    bool short = false,
  }) {
    Duration timeSince = DateTime.now().difference(date);

    if (timeSince.inSeconds < 0) return TimingNames.now.names(short);

    String output = '';

    if (timeSince.inDays == 0) {
      if (timeSince.inHours == 0) {
        if (timeSince.inMinutes == 0) {
          output =
              timeSince.inSeconds.toString() + TimingNames.second.names(short);
          if (!short) {
            if (timeSince.inSeconds > 1) output += 's';
            output += ' ago';
          }
        } else {
          output =
              timeSince.inMinutes.toString() + TimingNames.minute.names(short);
          if (!short) {
            if (timeSince.inMinutes > 1) output += 's';
            output += ' ago';
          }
        }
      } else {
        output = timeSince.inHours.toString() + TimingNames.hour.names(short);
        if (!short) {
          if (timeSince.inHours > 1) output += 's';
          output += ' ago';
        }
      }
    } else {
      if (timeSince.inDays >= 365) {
        int years = timeSince.inDays ~/ 365;
        output = years.toString() + TimingNames.year.names(short);
        if (!short) {
          if (years > 1) output += 's';
          output += ' ago';
        }
      } else if (timeSince.inDays >= 29) {
        int months = timeSince.inDays ~/ 30;
        output = months.toString() + TimingNames.month.names(short);
        if (!short) {
          if (months > 1) output += 's';
          output += ' ago';
        }
      } else {
        output = timeSince.inDays.toString() + TimingNames.day.names(short);
        if (!short) {
          if (timeSince.inDays > 1) output += 's';
          output += ' ago';
        }
      }
    }

    return output;
  }
}

enum TimingNames {
  now,
  second,
  minute,
  hour,
  day,
  month,
  year,
}

extension TimingNamesExtension on TimingNames {
  String names(
    bool short,
  ) {
    switch (this) {
      case TimingNames.now:
        return short ? 'now' : 'just now';
      case TimingNames.second:
        return short ? 's' : ' second';
      case TimingNames.minute:
        return short ? 'min' : ' minute';
      case TimingNames.hour:
        return short ? 'h' : ' hour';
      case TimingNames.day:
        return short ? 'd' : ' day';
      case TimingNames.month:
        return short ? 'mth' : ' month';
      case TimingNames.year:
        return short ? 'y' : ' year';
    }
  }
}
