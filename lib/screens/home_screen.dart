import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zap_android_user/screens/queue_manager/join_queue_screen.dart';
import 'package:zap_android_user/widgets/home/queue_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Your Queues",
          style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700),
        ),
        actions: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Use Navigator.push() to keep the HomeScreen in the stack
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JoinQueueScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      "Join Queue",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                    const Icon(Icons.add_circle_rounded),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
      body: const QueueList(),
    );
  }
}
