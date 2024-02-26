import 'package:android_flutter_app_boilerplate/widgets/app_elevated_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/alert_dialogs/alert_leave_app.dart';
import 'user_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {

  Future alertLeaveApp() => showDialog(
    context: context,
    builder: (BuildContext context) => const AlertLeaveApp(),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => alertLeaveApp(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Boilerplate'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                   context.pushNamed('user');
                },
              ),
            ),
          ],
        ),

        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hello'),
            ],
          ),
        ),
      ),
    );
  }
}
