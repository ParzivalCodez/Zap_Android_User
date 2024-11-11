import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zap_android_user/screens/home_screen.dart';

Future<void> groupingJoinHandler(queueId, context, members) async {
  final prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString("userId");

  // Fetches the user from Firestore
  var fetchedUserDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  Map<String, dynamic>? retrievedDoc = fetchedUserDoc.data();

  DateTime now = DateTime.now();

  // Define the desired format
  DateFormat format = DateFormat('MMMM d, y \'at\' h:mm:ss a');

  // Format the current DateTime object (optional if you want to store a string)
  String formattedDate = format.format(now);

  var firebase = await FirebaseFirestore.instance.collection(queueId).add({
    'id': userId,
    'name': retrievedDoc?['name'],
    'phone': retrievedDoc?['phone'],
    'timestamp': now,
    'usermail': retrievedDoc?['usermail'],
    'members': members,
  });

  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
}
