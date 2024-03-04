import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Screens/SplashScreen.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:device_preview/device_preview.dart';
import 'package:real_state/services/ThemeService/theme.dart';


void main() {
  developer.postEvent('resize_window', {'width': 600, 'height': 800});
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Set status bar color explicitly
  ));
  runApp(
    ChangeNotifierProvider(
      create: (_) => MyProvider(),
      child:  MyApp()
    ),
  );
}
// DevicePreview(
// builder: (context) => MyApp(), // Wrap your app
// ),
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.light,
      home: const SplashScreen(),
    );
  }
}


