import 'package:intl/intl.dart';

//anar apuntant diferents formats necessaris

DateTime convertStringToDateTime(String originalDate) {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  return dateFormat.parse(originalDate); // Outputs: 2024-05-15 00:00:00.000
}

String convertDateFormat(String originalDate) {
  if (originalDate.isNotEmpty && originalDate != " ") {
    DateTime dateTime = DateTime.parse(originalDate);

    DateFormat formatter = DateFormat('dd-MM-yyyy');

    return formatter.format(dateTime);
  } else {
    return "";
  }
}

String convertTimeFormat(String originalDate) {
  if (originalDate.isNotEmpty && originalDate != " ") {
    DateTime dateTime = DateTime.parse(originalDate);

    DateFormat formatter = DateFormat('HH:mm');

    return formatter.format(dateTime);
  } else {
    return "";
  }
}
