import 'package:flutter/material.dart';
class EmptyPropertyPage extends StatelessWidget {
  final String text;
  const EmptyPropertyPage({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(text),
      ),
    );
  }
}
