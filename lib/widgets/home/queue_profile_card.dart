import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zap_android_user/models/Queue.dart';

class QueueProfileCard extends StatefulWidget {
  const QueueProfileCard({
    super.key,
    required this.queueProfile,
    required this.queueId,
    required this.queueLandmark,
    required this.queueLocation,
    required this.queueName,
    required this.waitTime,
    required this.queueRebuilder,
  });

  final QueueProfile queueProfile;
  final String queueId;
  final String queueLandmark;
  final String queueLocation;
  final String queueName;
  final int waitTime;
  final Function queueRebuilder;

  @override
  State<QueueProfileCard> createState() => _QueueProfileCardState();
}

class _QueueProfileCardState extends State<QueueProfileCard>
    with AutomaticKeepAliveClientMixin<QueueProfileCard> {
  int userQueuePosition = 0;
  int queueMemberCount = 0;
  int seconds = 59;
  int minutes = 0;
  Color cardColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    widget.queueProfile.initializer(timerManager, widget.queueRebuilder);
    widget.queueProfile.getUserQueuePosition(queuePositionManager);
  }

  void queuePositionManager(int userPosition, int queueUsersLength) {
    if (mounted) {
      setState(() {
        userQueuePosition = userPosition;
        queueMemberCount = queueUsersLength;
      });
    }
  }

  void timerManager(int newSeconds, int newMinutes) {
    if (mounted) {
      setState(() {
        cardColor = Colors.orange;
        seconds = newSeconds;
        minutes = newMinutes;
      });
    }
  }

  @override
  bool get wantKeepAlive =>
      true; // Prevent widget from being disposed of when scrolled out of view

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Don't forget to call super.build(context) for AutomaticKeepAliveClientMixin

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16), // Adjust the radius as needed
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.queueName,
                  style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 245, 245, 221),
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Text(
                  "${widget.waitTime.toString()} ${minutes <= 1 ? "Min" : "Mins"}",
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Location ${widget.queueLocation}",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Text(
              "Landmark ${widget.queueLandmark}",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            Text(
              "Landmark ${widget.queueId}",
              style: GoogleFonts.poppins(
                  color: Colors.white, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
            Center(
              child: Visibility(
                  visible: widget.queueProfile.isTimerActive,
                  child: Text(
                    "${minutes.toString()}:${seconds.toString()}",
                    style:
                        GoogleFonts.poppins(color: Colors.white, fontSize: 25),
                  )),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(userQueuePosition.toString(),
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w600)),
                  Text("out of ${queueMemberCount.toString()}",
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
