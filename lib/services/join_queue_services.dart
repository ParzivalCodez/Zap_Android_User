import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:zap_android_user/screens/queue_manager/grouping_screen.dart';

Future<void> joinQueueHandler(String queueId, context) async {
  // Locally retrieves the User's Id
  final prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString("userId");

  // Fetches the user from Firestore
  var fetchedUserDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

  Map<String, dynamic>? retrievedDoc = fetchedUserDoc.data();

  // Updates the Users Queue ArrayList
  DocumentReference userDoc =
      FirebaseFirestore.instance.collection('users').doc(userId);

  await userDoc.update({
    'queues': FieldValue.arrayUnion([queueId.toString()]),
  }).then((_) {
    print("Item added successfully.");
  }).catchError((error) {
    print("Failed to add item: $error");
  });

  // Retrieves the Inputted code from Firebase
  var firebase =
      await FirebaseFirestore.instance.collection(queueId).doc("qInfo").get();
  Map<String, dynamic>? inputtedQueue = firebase.data();

  if (inputtedQueue?["groupingEn"] == false) {
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
    });
    Navigator.pop(context);
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupingScreen(queueId)),
    );
  }
}
