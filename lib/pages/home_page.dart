import 'package:be_sacha/assets/app_design_system.dart';
import 'package:be_sacha/properties/app_properties.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/alert_dialogs/alert_leave_app.dart';

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
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppDesignSystem.defaultPadding),
              child: IconButton(
                icon: const Icon(Icons.settings),
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
