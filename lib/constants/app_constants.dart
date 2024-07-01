import 'package:logger/logger.dart';

class LogPrinter {
  //TODO: PDPA for logger
  static Function log = (String value) => {logger.d(value)};

  static Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printTime: true,
    ),
  );
}
