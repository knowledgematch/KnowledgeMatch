import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: false,
  ),
  level: kReleaseMode ? Level.nothing : Level.debug,
);

