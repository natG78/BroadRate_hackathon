import 'package:intl/intl.dart';

//formats the time in a certain way
String formatTimestamp(DateTime dateTime) {
  final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
  return formatter.format(dateTime);
}
