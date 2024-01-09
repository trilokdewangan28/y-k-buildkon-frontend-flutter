import 'package:flutter/material.dart';
class EmptyPropertyPage extends StatelessWidget {
  const EmptyPropertyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('empty property'),
      ),
    );
  }
}
