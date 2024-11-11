import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zap_android_user/screens/home_screen.dart';
import 'package:zap_android_user/screens/onboarding/registration_screen.dart';
import 'package:zap_android_user/screens/queue_manager/grouping_screen.dart';
import 'package:zap_android_user/screens/queue_manager/join_queue_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Await the Firebase initialization
  await Firebase.initializeApp();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  var activeScreen = prefs.getInt("activeScreenIndex");

  List<Widget> screens = [RegistrationScreen(), HomeScreen()];

  if (activeScreen == null) {
    await prefs.setInt('number', 0);
    activeScreen =
        0; // Assign the default value for `data` after setting it to 0
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: screens[activeScreen],
    // home: RegistrationScreen(),
  ));
}
