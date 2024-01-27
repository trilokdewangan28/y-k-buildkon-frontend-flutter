import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';
import 'package:real_state/Screens/SplashScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MyProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        primaryColor: Colors.white, // Set the primary color
        hintColor: Color.fromARGB(255, 13, 70, 155), // Set the accent color
        //backgroundColor: Colors.white, // Set the background color
        //useMaterial3: true,

      ),
        darkTheme: ThemeData.dark().copyWith(
          // Dark mode colors
          primaryColor: Color.fromARGB(255, 13, 70, 155),
          hintColor: Colors.white,
          secondaryHeaderColor: Colors.amber

          // Add more dark mode colors as needed
        ),
        themeMode: Provider.of<MyProvider>(context).currentThemeMode,
      home: SplashScreen(),
    );
  }
}


