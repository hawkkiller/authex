import 'dart:async';

import 'package:authex/src/core/utils/logger.dart';
import 'package:authex/src/feature/app/logic/app_runner.dart';
import 'package:authex/src/feature/initialization/model/initialization_hook.dart';

/// Run that uses all platforms
void sharedRun(InitializationHook hook) {
  // there could be some shared initialization here
  Logger.runLogging(() {
    runZonedGuarded(
      () => AppRunner().initializeAndRun(hook),
      Logger.logZoneError,
    );
  });
}
