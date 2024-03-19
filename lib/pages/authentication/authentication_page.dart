import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../assets/app_images.dart';
import '../../widgets/app_elevated_button.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                Image.asset(
                  kAppIconNoBackground,
                  height: 192,
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: kDefaultPadding * 7,
                    top: kDefaultPadding,
                  ),
                  child: Text(
                      'Bienvenue sur BeSacha !',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kWhiteColor),
                      textAlign: TextAlign.center
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                    vertical: kDefaultPadding * 0.5,
                  ),
                  child: AppElevatedButton(
                    buttonColor: kBlackColor,
                    textColor: kWhiteColor,
                    onPressed: () {
                      context.pushNamed('login');
                    },
                    buttonText: 'Connexion',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: AppElevatedButton(
                    buttonColor: kWhiteColor,
                    textColor: kBlackColor,
                    onPressed: () {
                      context.pushNamed('register');
                    },
                    buttonText: 'Inscription',
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
