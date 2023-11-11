import 'dart:async';
import 'dart:io';

import 'package:bloc_concurrency/bloc_concurrency.dart' as bloc_concurrency;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:window_manager/window_manager.dart';
import 'package:ymusic/domain/app_bloc_observer.dart';
import 'package:ymusic/presentation/app.dart';
import 'package:ymusic/utils/logging.dart';
import 'package:ymusic/utils/service_locator.dart';

class Main {
  static final _log = Logger('Main');

  static Future<void> _initWindow() async {
    if (Platform.isWindows) {
      // await windowManager.setFullScreen(true);
      // await windowManager.setBounds((await windowManager.getBounds()).inflate(1));
      // await windowManager.setBounds((await windowManager.getBounds()).inflate(-1));
    }
    // windowManager.setClosable(false);
    await windowManager.show();
    // await windowManager.focus();
    // await windowManager.hide();
  }

  static Future<void> _init() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (Platform.isAndroid) {
      SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      await windowManager.ensureInitialized();
    }

    ServiceLocator.setup();
    Logging.setup();

    Bloc.observer = AppBlocObserver.instance();
    Bloc.transformer = bloc_concurrency.sequential<Object?>();

    if (!Platform.isAndroid) {
      WindowOptions windowOptions = const WindowOptions(
        // minimumSize: Platform.isWindows ? const Size(1920, 1080) : null,
        backgroundColor: Colors.transparent,
        titleBarStyle: TitleBarStyle.hidden,
        skipTaskbar: true,
        // windowButtonVisibility: false,
      );
      windowManager.waitUntilReadyToShow(
        windowOptions,
        () => unawaited(_initWindow()),
      );
    }

    runApp(const App());
  }

  static void run() {
    runZonedGuarded<void>(
      () => unawaited(_init()),
      (err, stackTrace) => _log.shout('Unhandled exception', err, stackTrace),
    );
  }
}

void main() {
  Main.run();
}
