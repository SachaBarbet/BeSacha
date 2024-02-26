import 'package:flutter/material.dart';

import '../../assets/app_design_system.dart';
import '../../services/app_user_service.dart';
import '../../utilities/toast_util.dart';
import '../../utilities/validators.dart';
import '../app_elevated_button.dart';
import '../app_text_form_field.dart';

class AlertUpdateUsername extends StatelessWidget {
  AlertUpdateUsername({super.key});

  final TextEditingController _newUsername = TextEditingController();
  final GlobalKey<FormState> _updateUsernameFormKey = GlobalKey<FormState>();


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
      title: const Text('Changez votre nom', textAlign: TextAlign.center,),
      content: Form(
        key: _updateUsernameFormKey,
        child: Column(
          children: [
            AppTextFormField(
              controller: _newUsername,
              hintText: 'Nouveau nom',
              keyboardType: TextInputType.name,
              validator: (value) => Validators.validateDisplayName(value),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AppElevatedButton(
                buttonText: 'Changer',
                isSmall: true,
                onPressed: () {
                  if (!_updateUsernameFormKey.currentState!.validate()) return;

                  try {
                    AppUserService.updateDisplayName(_newUsername.text);
                    ToastUtil.showSuccessToast(context, 'Nom changé avec succès');
                    _newUsername.clear();
                    Navigator.pop(context);
                  } catch (_) {
                    ToastUtil.showErrorToast(context, 'Une erreur est survenue');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}