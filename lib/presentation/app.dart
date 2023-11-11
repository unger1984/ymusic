import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';

@immutable
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  initState() {
    super.initState();
    _handleInitSysTray();
  }

  Future<void> _handleInitSysTray() async {
    final appWindow = AppWindow();
    final systemTray = SystemTray();
    await systemTray.initSystemTray(
      title: "system tray",
      iconPath: Platform.isWindows ? 'assets/png/app_icon.ico' : 'assets/png/app_icon.png',
    );

    final Menu menu = Menu();
    await menu.buildFrom([
      MenuItemLabel(label: 'Show', onClicked: (menuItem) => windowManager.show()),
      MenuItemLabel(label: 'Hide', onClicked: (menuItem) => windowManager.hide()),
      MenuItemLabel(label: 'Exit', onClicked: (menuItem) => windowManager.destroy()),
    ]);

    // set context menu
    await systemTray.setContextMenu(menu);

    systemTray.registerSystemTrayEventHandler((eventName) {
      debugPrint("eventName: $eventName");
      if (eventName == kSystemTrayEventClick) {
        Platform.isWindows ? windowManager.show() : systemTray.popUpContextMenu();
      } else if (eventName == kSystemTrayEventRightClick) {
        Platform.isWindows ? systemTray.popUpContextMenu() : windowManager.show();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'yMusic', home: Scaffold(body: Center(child: Text('Test'))));
  }
}
