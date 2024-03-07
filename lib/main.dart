import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:real_state/controller/MyProvider.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart';
import 'package:real_state/services/ThemeService/ThemeServices.dart';
import 'package:real_state/services/ThemeService/theme.dart';
import 'ui/Screens/SplashScreen.dart';


void main() async{
  developer.postEvent('resize_window', {'width': 600, 'height': 800});
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.white, // Set status bar color explicitly
  ));
  //WidgetsFlutterBinding.ensureInitialized();
  //await controller.initializeController();
  
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
    return GetMaterialApp(
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: const SplashScreen(),
    );
  }
}


