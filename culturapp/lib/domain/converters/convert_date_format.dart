import 'package:intl/intl.dart';

//anar apuntant diferents formats necessaris

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
