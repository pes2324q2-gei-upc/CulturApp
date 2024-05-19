import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:culturapp/domain/converters/convert_date_format.dart';
import 'package:culturapp/domain/converters/notificacions.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:workmanager/workmanager.dart';

/*late ControladorPresentacion _controladorPresentacion;

void initializeNotifications(ControladorPresentacion controladorPresentacion) {
  _controladorPresentacion = controladorPresentacion;
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "dailyCheckTask",
    "dailyCheckAndScheduleNotifications",
    //frequency: const Duration(hours: 24),
    frequency: const Duration(seconds: 5),
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await checkAndScheduleNotifications();
    return Future.value(true);
  });
}

Future<void> checkAndScheduleNotifications() async {
  List<Actividad> myActivities = await _controladorPresentacion.getUserActivs();

  for (Actividad myActivity in myActivities) {
    DateTime activityDate = convertStringToDateTime(myActivity.dataInici);

    DateTime currentDate = DateTime.now();
    int difference = activityDate.day - currentDate.day;
    //fet d'aquesta manera pq si s'utilitza difference podria ser que la activitat hagues passat ahir

    if (difference == 1) {
      triggerNotificationsActivityDayBefore(myActivity.name);
    }
  }
}*/

void scheduleNotificationsActivityDayBefore(
    String activityCode, String activityName) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: int.parse(activityCode),
      channelKey: 'basic_channel',
      title: 'Pròxima Activitat!',
      body: 'Demà té lloc la activitat $activityName que tens guardada',
    ),
    schedule: NotificationCalendar(
      year: 2024,
      month: 5,
      day: 19,
      hour: 13,
      minute: 2,
      second: 0,
      millisecond: 0,
      repeats: false,
    ),
  );
}
