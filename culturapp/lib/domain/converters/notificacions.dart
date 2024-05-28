import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:culturapp/domain/converters/convert_date_format.dart';
import 'package:culturapp/domain/models/notification_id_manager.dart';
import 'package:culturapp/translations/AppLocalizations';
import 'package:flutter/widgets.dart';
import 'dart:async';

void initializeAwesomeNotifications() {
  AwesomeNotifications().initialize(
    null, //'assets/logoCulturApp.png',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for everything',
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
          channelGroupKey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );
}

Map<String, String?> convertDynamicToStringMap(Map<String, dynamic> input) {
  return input.map((key, value) => MapEntry(key, value.toString()));
}

//notificacions i el seu contingut
void scheduleNotificationsActivityDayBefore(String activityCode,
    String activityName, String initialDateString, BuildContext context) {
  DateTime initialDate = convertStringToDateTime(initialDateString);
  DateTime dayBeforeActivity = initialDate.subtract(const Duration(days: 1));

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(activityCode.substring(activityCode.length - 5)),
      channelKey: 'basic_channel',
      title: 'next_activity'.tr(context),
      body: 'ad_next_activity'.trWithArg(context, {"String": activityName}),
    ),
    schedule: NotificationCalendar(
      year: dayBeforeActivity.year,
      month: dayBeforeActivity.month,
      day: dayBeforeActivity.day,
      hour: 11,
      minute: 00,
      second: 0,
      millisecond: 0,
      repeats: false,
    ),
  );
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

// Create an instance of the debouncer
final Debouncer _debouncer = Debouncer(milliseconds: 1000);

notificacioSimple(String titol, String body) {
  _debouncer.run(() {
    int notificationId = NotificationIdManager.getNextId();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: 'basic_channel',
        title: titol,
        body: body,
      ),
    );
  });
}
