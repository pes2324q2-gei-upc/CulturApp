import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void checkingDateToTriggerNotification() {
  /*mirarem si el dia es igual, no mirarem hora pq sin gastaria molts recursos*/
  DateTime currentDate = DateTime.now();
  Duration difference = activityDate.difference(currentDate);

  if (difference.inDays == 1) {
    triggerNotificationsDayBefore();
  }
}

void triggerNotificationsDayBefore() {
  print("Triggered function a day before the activity date.");
}

void scheduleAlarm(DateTime activityDate) {
  final int alarmId = 0;
  DateTime scheduledTime = activityDate.subtract(Duration(days: 1));

  AndroidAlarmManager.oneShotAt(
    scheduledTime,
    alarmId,
    triggerNotificationsDayBefore,
    exact: true,
    wakeup: true,
  );
}
