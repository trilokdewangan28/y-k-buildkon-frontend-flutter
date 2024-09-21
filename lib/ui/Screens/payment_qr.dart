import 'package:flutter/material.dart';
class PaymentQr extends StatefulWidget {
  const PaymentQr({super.key});

  @override
  State<PaymentQr> createState() => _PaymentQrState();
}

class _PaymentQrState extends State<PaymentQr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Image.asset("assets/images/payment.jpg"),
      ),
    );
  }
}
