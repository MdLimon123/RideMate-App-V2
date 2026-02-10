import 'package:flutter/material.dart';

class AcceptedTrip extends StatefulWidget {
  const AcceptedTrip({super.key});

  @override
  State<AcceptedTrip> createState() => _AcceptedTripState();
}

class _AcceptedTripState extends State<AcceptedTrip> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(children: [Center(child: Text('Accepted Trip Screen'))]),
      ),
    );
  }
}
