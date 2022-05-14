import 'package:flutter/material.dart';

class MoodCalendar extends StatelessWidget {
  const MoodCalendar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalenderübersicht'),
      ),
      body: const Center(
          child: Text('Hier kommt der Kalender hin')
      ),
    );
  }
}
