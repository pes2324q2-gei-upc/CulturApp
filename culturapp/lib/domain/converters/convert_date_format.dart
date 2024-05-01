import 'package:intl/intl.dart';

//anar apuntant diferents formats necessaris

String convertDateFormat(String originalDate) {
  DateTime dateTime = DateTime.parse(originalDate);

  DateFormat formatter = DateFormat('dd-MM-yyyy');

  return formatter.format(dateTime);
}

String convertTimeFormat(String originalDate) {
  DateTime dateTime = DateTime.parse(originalDate);

  DateFormat formatter = DateFormat('HH:mm');

  return formatter.format(dateTime);
}
