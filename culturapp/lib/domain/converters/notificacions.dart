import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:culturapp/domain/converters/convert_date_format.dart';

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
