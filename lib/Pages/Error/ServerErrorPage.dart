
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_state/Provider/MyProvider.dart';


class ServerErrorPage extends StatelessWidget {
  const ServerErrorPage({Key? key, required this.errorString})
      : super(key: key);
  final String errorString;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyProvider>(context);
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop) {
          appState.activeWidget = "LoginWidget";
          appState.currentState = 1;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                  'Internal Server Error',
                style: TextStyle(
                  color: Colors.red
                ),
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () {
                      appState.activeWidget = "LoginWidget";
                      appState.currentState = 1;
                    },
                    child: const Text('BACK TO HOME')))
          ],
        ));
  }
}
