import 'package:android_flutter_app_boilerplate/assets/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_design_system.dart';
import '../../services/app_user_service.dart';
import '../../utilities/toast_util.dart';
import '../../utilities/validators.dart';
import '../app_text_form_field.dart';

class AlertUpdatePassword extends StatefulWidget {
  const AlertUpdatePassword({super.key});

  @override
  State<StatefulWidget> createState() => _AlertUpdatePassword();
}

class _AlertUpdatePassword extends State<AlertUpdatePassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _updatePasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppDesignSystem.defaultPadding * 0.8),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_outlined, size: AppDesignSystem.defaultIconSize * 2,),
            ),
          ),
        ],
      ),

      iconPadding: const EdgeInsets.only(
        top: AppDesignSystem.defaultPadding * 0.8,
        bottom: AppDesignSystem.defaultPadding * 0.5,
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: const Text('Changement de mot de passe', textAlign: TextAlign.center,),
      ),
      content: Form(
        key: _updatePasswordFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextFormField(
              controller: _passwordController,
              hintText: 'Mot de passe actuel',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => Validators.validatePassword(value),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.defaultPadding / 2),
              child: AppTextFormField(
                controller: _newPasswordController,
                hintText: 'Nouveau mot de passe',
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) => Validators.validatePassword(value),
              ),
            ),
            AppTextFormField(
              controller: _confirmPasswordController,
              hintText: 'Confirmer le nouveau mot de passe',
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) => Validators.validateConfirmPassword(_newPasswordController.text, value),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ANNULER', style: TextStyle(color: AppColors.red),),
                ),
                TextButton(
                  onPressed: () {
                    if (!_updatePasswordFormKey.currentState!.validate()) return;

                    AppUserService.login(FirebaseAuth.instance.currentUser!.email!, _passwordController.text)
                        .then((value) {
                      if (value == null) {
                        ToastUtil.showShortErrorToast(context, 'Mot de passe incorrect');
                        return;
                      }

                      FirebaseAuth.instance.currentUser!.updatePassword(_newPasswordController.text).then((value) {
                        ToastUtil.showSuccessToast(context, 'Mot de passe changé avec succès');
                        _passwordController.clear();
                        _newPasswordController.clear();
                        _confirmPasswordController.clear();
                        context.pop();
                      }).onError((error, stackTrace) {
                        ToastUtil.showShortErrorToast(context, 'Erreur de changement de mot de passe');
                      });
                    });
                  },
                  child: const Text('CHANGER', style: TextStyle(color: AppColors.primary),)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}