import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:culturapp/domain/converters/convert_date_format.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

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

void showAwesomeNotification(RemoteMessage message) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: message.data.hashCode,
      channelKey: 'basic_channel',
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? 'You have received a new message.',
      payload: convertDynamicToStringMap(message.data),
    ),
  );
}

Map<String, String?> convertDynamicToStringMap(Map<String, dynamic> input) {
  return input.map((key, value) => MapEntry(key, value.toString()));
}

//notificacions i el seu contingut
void scheduleNotificationsActivityDayBefore(
    String activityCode, String activityName, String initialDateString) {
  DateTime initialDate = convertStringToDateTime(initialDateString);
  DateTime dayBeforeActivity = initialDate.subtract(const Duration(days: 1));

  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(activityCode),
      channelKey: 'basic_channel',
      title: 'Pròxima Activitat!',
      body: 'Demà té lloc la activitat $activityName que tens guardada.',
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

triggerNotification() {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'basic_channel',
      title: 'Simple Notification',
      body: 'Simple Button',
    ),
  );
}
