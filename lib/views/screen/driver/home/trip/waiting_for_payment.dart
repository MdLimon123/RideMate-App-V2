import 'package:flutter/material.dart';

class WaitingForPayment extends StatefulWidget {
  const WaitingForPayment({super.key});

  @override
  State<WaitingForPayment> createState() => _WaitingForPaymentState();
}

class _WaitingForPaymentState extends State<WaitingForPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waiting for Payment')),
      body: const Center(child: Text('Waiting for payment to be completed')),
    );
  }
}
