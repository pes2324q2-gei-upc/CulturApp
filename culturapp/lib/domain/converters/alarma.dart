import 'package:culturapp/domain/converters/convert_date_format.dart';
import 'package:culturapp/domain/converters/notificacions.dart';
import 'package:culturapp/domain/models/actividad.dart';
import 'package:culturapp/presentacio/controlador_presentacio.dart';
import 'package:workmanager/workmanager.dart';

late ControladorPresentacion _controladorPresentacion;

void initializeNotifications(ControladorPresentacion controladorPresentacion) {
  _controladorPresentacion = controladorPresentacion;
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerPeriodicTask(
    "1",
    "mirarDataAcivitat",
    frequency: const Duration(days: 1),
  );
  checkAndScheduleNotifications();
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    checkAndScheduleNotifications();
    return Future.value(true);
  });
}

Future<void> checkAndScheduleNotifications() async {
  List<Actividad> myActivities = await _controladorPresentacion.getUserActivs();

  for (Actividad myActivity in myActivities) {
    DateTime activityDate = convertStringToDateTime(myActivity.dataInici);
    // Format: 2024-05-15 00:00:00.000

    DateTime currentDate = DateTime.now();
    int difference = activityDate.day - currentDate.day;

    if (difference == 1) {
      triggerNotificationsActivityDayBefore(myActivity.name);
    }
  }
}
