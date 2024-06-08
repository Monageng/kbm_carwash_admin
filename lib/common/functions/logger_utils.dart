import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(methodCount: 0, colors: true),
);

void printTime(String method) {
  DateTime currentTime = DateTime.now();

  String formattedTime =
      "${currentTime.hour}:${currentTime.minute}:${currentTime.second}:${currentTime.millisecond}";

  logger.i("Method $method : Current Time: $formattedTime");
}
