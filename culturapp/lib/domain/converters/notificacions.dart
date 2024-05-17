import 'package:awesome_notifications/awesome_notifications.dart';

void triggerNotificationsActivityDayBefore(String activityName) {
  //funció de la notificació d'activitat d'un dia abans
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 0,
      channelKey: 'basic_channel',
      title: 'Pròxima Activitat!',
      body: 'Demà té lloc la activitat $activityName que tens guardada',
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
