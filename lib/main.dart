import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Screens/SplashScreen.dart';
import 'dart:developer' as developer;
import 'package:device_preview/device_preview.dart';


void main() {
  developer.postEvent('resize_window', {'width': 600, 'height': 800});
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
      theme: ThemeData(
        fontFamily: 'Montserrat',
        //backgroundColor: Colors.white,
        primaryColor: const Color.fromARGB(255, 13, 70, 155), // Set the primary color
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.white,// Set the accent color
        //splashColor: Colors.black,
        //highlightColor: Colors.green,
        errorColor: Colors.red,
        useMaterial3: true,

      ),
        // darkTheme: ThemeData.dark().copyWith(
        //   // Dark mode colors
        //   primaryColor: const Color.fromARGB(255, 13, 70, 155),
        //   hintColor: Colors.white,
        //   secondaryHeaderColor: Colors.amber,
        //
        //
        //   // Add more dark mode colors as needed
        // ),
        // themeMode: Provider.of<MyProvider>(context).currentThemeMode,
      home: const SplashScreen(),
    );
  }
}


