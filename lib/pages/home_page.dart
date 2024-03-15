import 'package:be_sacha/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../services/app_user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  static const double _dividerHeight = 50;

  late final Future<AppUser?> _appUser;

  @override
  void initState() {
    _appUser = AppUserService.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppDesignSystem.defaultPadding),
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                   context.pushNamed('settings');
                },
              ),
            ),
          ],
        ),

        body: Center(
          child: FutureBuilder(
            future: _appUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                );
              }

              if (snapshot.hasError) {
                return const Text('Une erreur est survenue');
              }

              final AppUser appUser = snapshot.data!;

              return Column(
                children: [
                  Text('Bonjour ${appUser.displayName}', style: const TextStyle(fontSize: 24),),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 5),
                    child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
                  ),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
