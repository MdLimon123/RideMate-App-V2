import 'package:flutter/material.dart';

class PaymentOrverView extends StatefulWidget {
  const PaymentOrverView({super.key});

  @override
  State<PaymentOrverView> createState() => _PaymentOrverViewState();
}

class _PaymentOrverViewState extends State<PaymentOrverView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [Center(child: Text('Payment Over View Screen'))],
        ),
      ),
    );
  }
}