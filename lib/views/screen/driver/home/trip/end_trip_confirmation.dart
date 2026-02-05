import 'package:flutter/material.dart';

class EndTripConfirmation extends StatefulWidget {
  const EndTripConfirmation({super.key});

  @override
  State<EndTripConfirmation> createState() => _EndTripConfirmationState();
}

class _EndTripConfirmationState extends State<EndTripConfirmation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Center(child: Text('End Trip Confirmation Screen'))],
        ),
      ),
    );
  }
}
