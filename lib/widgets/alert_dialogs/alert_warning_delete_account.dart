import 'package:android_flutter_app_boilerplate/pages/authentication/authentication_page.dart';
import 'package:android_flutter_app_boilerplate/widgets/app_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../services/app_firebase.dart';
import '../../services/app_user_service.dart';
import '../../utilities/toast_util.dart';

class AlertWarningDeleteAccount extends StatefulWidget {
  const AlertWarningDeleteAccount({super.key});

  @override
  State<StatefulWidget> createState() => _AlertWarningDeleteAccount();
}

class _AlertWarningDeleteAccount extends State<AlertWarningDeleteAccount> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

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
      title: const Padding(
        padding: EdgeInsets.only(bottom: 8.0),
        child: Text('ATTENTION', style: TextStyle(color: AppColors.red), textAlign: TextAlign.center,),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Toutes vos données seront perdues et ne pourront être récupérer !\n'
            'Entrez votre mot de passe pour confirmer la suppression de votre compte',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AppTextFormField(
              controller: _passwordController,
              hintText: 'Mot de passe',
              obscureText: _obscureText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('CANCEL')),
                TextButton(
                  onPressed: () {
                    AppUserService.login(FirebaseAuth.instance.currentUser!.email!, _passwordController.text).then((value) {
                      if (value != null) {
                        _passwordController.clear();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthenticationPage()));
                        AppFirebase.userCollectionRef.doc(FirebaseAuth.instance.currentUser!.uid).delete().whenComplete(() {
                          FirebaseAuth.instance.currentUser!.delete().whenComplete(() {
                            AppFirebase.usersImagesStorageRef.child("${FirebaseAuth.instance.currentUser!.uid}.png").delete().whenComplete(() => ToastUtil.showSuccessToast(context, 'Account deleted'));
                          });
                        });
                      } else {
                        ToastUtil.showShortErrorToast(context, 'Error: Invalid password');
                      }
                    });
                  },
                  child: const Text('CONFIRM'))
              ],
            ),
          )
        ],
      ),
    );
  }

}