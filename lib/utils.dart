import 'package:intl/intl.dart';

String formatTimestamp(DateTime dateTime) {
  final DateFormat formatter = DateFormat('MM-dd-yyyy hh:mm a');
  return formatter.format(dateTime);
}
