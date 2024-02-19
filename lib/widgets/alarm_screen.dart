import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

class AlarmScreen extends StatefulWidget {
  final List<Map<String, dynamic>> alertData;

  const AlarmScreen({Key? key, required this.alertData}) : super(key: key);

  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late bool isBlinking;
  late Timer blinkTimer;
  // late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    isBlinking = true;
    // audioPlayer = AudioPlayer();
    _startBlinking();
    _playSound();
  }

  @override
  void dispose() {
    blinkTimer.cancel();
    // audioPlayer.dispose();
    super.dispose();
  }

  void _startBlinking() {
    const Duration blinkDuration = Duration(milliseconds: 5);
    blinkTimer = Timer.periodic(blinkDuration, (timer) {
      setState(() {
        isBlinking = !isBlinking;
      });
    });

    // Stop blinking after 10 seconds
    Timer(const Duration(seconds: 10), () {
      blinkTimer.cancel();
      setState(() {
        isBlinking = false;
      });
    });
  }

  void _playSound() async {
    // await audioPlayer.play(AssetSource('assets/sounds/alarm_sound.mp3')); // Replace with your sound file
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            color: isBlinking ? Colors.red : Colors.orange,
            width: 200,
            height: 200,
            child: const Center(
              child: Text(
                '🚨', // Alarm emoji
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle "I'm safe" button click
            },
            child: const Text("I'm Safe"),
          ),
          const SizedBox(height: 16),
          Text(
            'Areas: ${widget.alertData.map((area) => area['areaName']).join(', ')}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
