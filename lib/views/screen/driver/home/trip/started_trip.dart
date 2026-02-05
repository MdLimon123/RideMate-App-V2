import 'package:flutter/material.dart';

class StartedTrip extends StatefulWidget {
  const StartedTrip({super.key});

  @override
  State<StartedTrip> createState() => _StartedTripState();
}

class _StartedTripState extends State<StartedTrip> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [Center(child: Text('Started Trip Screen'))]),
      ),
    );
  }
}
