import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QueueProfile {
  final String queueId;
  final bool groupingEn;
  final String landmark;
  final String location;
  final String name;
  int waitTime;
  bool isTimerActive;
  Function? timerHandler;
  Function? queueRebuilder;

  QueueProfile(this.queueId, this.groupingEn, this.landmark, this.location,
      this.name, this.waitTime)
      : isTimerActive = false,
        timerHandler = null,
        queueRebuilder = null;

  void initializer(timerManager, queueRebuilderArg) {
    timerHandler = timerManager;
    queueRebuilder = queueRebuilderArg;
  }

  void startTimer() {
    int seconds = 59; // Start the countdown at 59 seconds
    isTimerActive = true;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--; // Decrement the seconds
        timerHandler!(seconds, waitTime);
      } else {
        // When seconds reach 0
        timer.cancel(); // Stop the current timer
        if (waitTime > 0) {
          waitTime--; // Decrement the waitTime (minutes)
          startTimer(); // Restart the timer with reset seconds
        } else {
          // When both waitTime and seconds are 0, execute removeUser
          removeUser();
          print('End of timer reached');
        }
      }
    });
  }

  Future<void> getUserQueuePosition(queuePositionManager) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    List activeMembers = [];
    int index = 0;
    int queueMembersCount = 0;

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(queueId)
        .where(FieldPath.documentId, isNotEqualTo: "qInfo")
        .get();

    // Loop through the documents and print them
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      activeMembers.add({
        'timestamp': data['timestamp'].toDate(), // Keep as DateTime object
        'data': data,
      });

      queueMembersCount++;
    }
    activeMembers.sort((a, b) =>
        a['timestamp'].compareTo(b['timestamp'])); // Sort from oldest to newest

    index =
        activeMembers.indexWhere((element) => element['data']['id'] == userId);

    print(activeMembers);

    if (index == 0) {
      index = 1;
      // print("Index updated to ${index}");
      startTimer();
    } else {
      index += 1;
      // print("No Else ${index}");
    }

    queuePositionManager(index, queueMembersCount);

    FirebaseFirestore.instance
        .collection(queueId)
        .snapshots(
            includeMetadataChanges: true) // Optional: includes metadata changes
        .listen((snapshot) {
      // Ignore the initial snapshot (if it exists)
      if (snapshot.metadata.isFromCache) {
        return;
      }

      for (var change in snapshot.docChanges) {
        if (change.doc.id == 'qInfo') {
          continue;
        }

        if (change.type == DocumentChangeType.added) {
          activeMembers.add({
            'timestamp': (change.doc.data()?['timestamp'] as Timestamp)
                .toDate()
                .toIso8601String(),
            'data': change.doc.data(),
          });
          activeMembers
              .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

          index = activeMembers
              .indexWhere((element) => element['data']['id'] == userId);

          queueMembersCount++;

          if (index == 0) {
            index = 1;
            print("Index updated to ${index}");
            startTimer();
          } else {
            index += 1;
            print("No Else ${index}");
          }
          queuePositionManager(index, queueMembersCount);
        }
        if (change.type == DocumentChangeType.removed) {
          var data = change.doc.data() as Map<String, dynamic>;

          // Find the index of the user to remove
          int deletedUserIndex = activeMembers
              .indexWhere((element) => element['data']['id'] == data['id']);

          if (deletedUserIndex != -1) {
            // Remove the user from the list
            activeMembers.removeAt(deletedUserIndex);

            // Decrement the member count
            queueMembersCount--;

            // Re-sort the active members by timestamp (oldest to newest)
            activeMembers
                .sort((a, b) => a['timestamp'].compareTo(b['timestamp']));

            // Find the new index of the current user
            index = activeMembers
                .indexWhere((element) => element['data']['id'] == userId);

            // Adjust index if needed
            if (index == 0) {
              index = 1; // If the current user is at the start, set index to 1
              print("Index updated to ${index}");
              startTimer(); // Restart the timer if the user is now at the top
            } else {
              index += 1; // Adjust index accordingly
              print("No Else ${index}");
            }
            queuePositionManager(index, queueMembersCount); // Update position
          }
        }
      }
    }, onError: (error) {
      print('Error in snapshot stream: $error');
    });
  }

  Future<void> removeUser() async {
    try {
      // Get SharedPreferences instance
      final SharedPreferences pref = await SharedPreferences.getInstance();
      var userId = pref.getString("userId");

      // Ensure userId and queueId are not null
      if (userId == null || queueId.isEmpty) {
        print("UserId or QueueId is null or empty");
        return;
      }

      final collectionRef = FirebaseFirestore.instance.collection('users');
      await collectionRef.doc(userId.toUpperCase()).update({
        'queues': FieldValue.arrayRemove([queueId]),
      });

      // Reference to the queue collection
      final collectionRefQueue = FirebaseFirestore.instance.collection(queueId);

      // Query to find documents that meet the condition
      final querySnapshot = await collectionRefQueue
          .where("id", isEqualTo: userId.toUpperCase())
          .get();

      // Delete each document that matches the condition
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      queueRebuilder!();
      print("Queue removed successfully.");
    } catch (e) {
      print("Error removing queue: $e");
    }
  }
}
