import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../assets/app_colors.dart';
import '../assets/app_design_system.dart';
import '../models/app_user.dart';
import '../services/app_user_service.dart';
import '../utilities/toast_util.dart';
import '../widgets/alert_dialogs/alert_update_password.dart';
import '../widgets/alert_dialogs/alert_update_username.dart';
import '../widgets/alert_dialogs/alert_warning_delete_account.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<StatefulWidget> createState() => _UserPage();
}

class _UserPage extends State<UserPage> {
  late final Future<AppUser?> _user;

  @override
  void initState() {
    _user = AppUserService.getUser();
    super.initState();
  }

  Future openPopupChangeUsername() => showDialog(
    context: context,
    builder: (BuildContext context) => AlertUpdateUsername(),
  );

  Future openPopupChangePassword() => showDialog(
    context: context,
    builder: (BuildContext context) => const AlertUpdatePassword(),
  );

  Future openPopupDeleteAccount() => showDialog(
    context: context,
    builder: (BuildContext context) => const AlertWarningDeleteAccount(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightGrey,
        leading: BackButton(onPressed: () => context.pop(),),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: FutureBuilder<AppUser?>(
          future: _user,
          builder: (BuildContext context, AsyncSnapshot<AppUser?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: AppColors.red),
                ),
              );
            }

            if (snapshot.hasData) {
              final AppUser user = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Votre compte',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    'Bonjour ${user.displayName}',
                    style: const TextStyle(fontSize: 20, height: 1),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => openPopupChangeUsername(),
                    child: const Text('Change Username'),
                  ),
                  ElevatedButton(
                    onPressed: () => openPopupChangePassword(),
                    child: const Text('Change Password'),
                  ),
                  ElevatedButton(
                    onPressed: () => openPopupDeleteAccount(),
                    child: const Text('Delete Account'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await AppUserService.updateUserPhoto(context, user);
                        ToastUtil.showInfoToast(context, 'Photo mise à jour avec succès');
                      } catch (e) {
                        print(e);
                        ToastUtil.showErrorToast(context, 'Une erreur est survenue');
                      }
                    },
                    child: const Text('Update Photo'),
                  ),
                  ElevatedButton(
                    onPressed: () { AppUserService.logout().then((value) => context.go('/authentication')); },
                    child: const Text('Logout'),
                  ),
                ],
              );
            }

            return const Center(
              child: Text('No user found'),
            );
          },
        ),
      ),
    );
  }
}