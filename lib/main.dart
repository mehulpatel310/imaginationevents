import 'package:flutter/material.dart';
import 'package:imaginationevents/Organizer/AddEvents.dart';
import 'package:imaginationevents/Organizer/OrganizerHome.dart';
import 'package:imaginationevents/Organizer/OrganizerLogin.dart';
import 'package:imaginationevents/auth/Login.dart';
import 'package:imaginationevents/auth/SignUp.dart';
import 'package:imaginationevents/common/BottomNavigationPage.dart';
import 'package:imaginationevents/common/Home.dart';
import 'package:imaginationevents/common/OrganizerUser.dart';
import 'package:imaginationevents/events/Events.dart';
import 'package:imaginationevents/common/SplashScreen.dart';
import 'package:imaginationevents/events/EventsDetails.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}


