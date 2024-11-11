import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Queue.dart';

Future<List> fetchFirebaseQueuesHandler() async {
  List queueProfiles = [];
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  var userId = preferences.getString("userId");

  print(userId);

  // Fetches the raw document of a user from Firebase
  var snapshot =
      await FirebaseFirestore.instance.collection("users").doc(userId).get();

  // Converts the retrieved user into a Dart Map
  Map<String, dynamic>? retrievedUser = snapshot.data();

  //* Loops through the queues the user is apart of and sends it to a function to make a type of Queue Profile
  for (var queueId in retrievedUser?['queues']) {
    var snapshot =
        await FirebaseFirestore.instance.collection(queueId).doc('qInfo').get();

    Map<String, dynamic>? retrievedQueue = snapshot.data();

    var processedQueue = QueueProfile(
        queueId,
        retrievedQueue?['groupingEn'],
        retrievedQueue?['landmark'],
        retrievedQueue?['location'],
        retrievedQueue?['name'],
        retrievedQueue?['waitTime']);
    queueProfiles.add(processedQueue);
  }

  return queueProfiles;
}
