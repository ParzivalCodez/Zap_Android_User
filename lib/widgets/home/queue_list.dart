import 'package:flutter/material.dart';
import 'package:zap_android_user/widgets/home/queue_profile_card.dart';

import '../../services/home_screen_services.dart';

class QueueList extends StatefulWidget {
  const QueueList({super.key});

  @override
  State<QueueList> createState() => _QueueListState();
}

class _QueueListState extends State<QueueList> {
  List fetchedQueues = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchQueuesHandler();
  }

  Future<void> fetchQueuesHandler() async {
    fetchedQueues = await fetchFirebaseQueuesHandler();
    setState(() {
      fetchedQueues = fetchedQueues;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      // Optional: Ensures the ListView takes only as much space as needed
      children: fetchedQueues.map((queue) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: QueueProfileCard(
            queueProfile: queue,
            queueId: queue.queueId,
            queueLandmark: queue.landmark,
            queueLocation: queue.location,
            queueName: queue.name,
            waitTime: queue.waitTime,
            queueRebuilder: fetchQueuesHandler,
          ),
        );
      }).toList(),
    );
  }
}
