import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../services/app_user_service.dart';
import '../../utilities/toast_util.dart';
import '../app_text_form_field.dart';

class AlertWarningDeleteAccount extends StatefulWidget {
  const AlertWarningDeleteAccount({super.key});

  @override
  State<StatefulWidget> createState() => _AlertWarningDeleteAccount();
}

class _AlertWarningDeleteAccount extends State<AlertWarningDeleteAccount> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      icon: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding * 0.8),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close_outlined, size: kDefaultIconSize * 2,),
            ),
          ),
        ],
      ),
      iconPadding: const EdgeInsets.only(
        top: kDefaultPadding * 0.8,

      ),
      title: const Text('ATTENTION', style: TextStyle(color: kRedColor), textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text('Toutes vos données seront perdues et ne pourront être récupérer !\n'
              'Entrez votre mot de passe pour confirmer la suppression de votre compte',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AppTextFormField(
              controller: _passwordController,
              hintText: 'Mot de passe',
              obscureText: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'ANNULER',
                    style: TextStyle(color: PlatformDispatcher.instance.platformBrightness
                        == Brightness.dark ? kWhiteColor : kBlackColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    AppUserService.login(FirebaseAuth.instance.currentUser!.email!, _passwordController.text)
                        .then((value) {
                      if (value != null) {
                        context.pushNamed('loading');
                        AppUserService.deleteCurrentUser().then((value) {
                          _passwordController.clear();
                          showSuccessToast(context, 'Votre compte a bien été supprimé.');
                          context.pop();
                          context.go('/authentication');
                        }).onError((error, stackTrace) {
                          context.pop();
                          showErrorToast(context, 'Erreur de connexion');
                        });
                      } else {
                        showShortErrorToast(context, 'Mot de passe invalide');
                      }
                    });
                  },
                  child: const Text('SUPPRIMER', style: TextStyle(color: kRedColor),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}