import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../services/app_user_service.dart';
import '../../utilities/validators.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_text_form_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  static const double appBarHeight = 50;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          toolbarHeight: appBarHeight,
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: appBarHeight,
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: kDefaultPadding,),
                  child: Text('Inscription', style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding),
                  child: Form(
                    key: _registerFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            bottom: kDefaultPadding,
                          ),
                          child: AppTextFormField(
                            controller: _displayNameController,
                            hintText: 'Nom d\'utilisateur',
                            keyboardType: TextInputType.name,
                            obscureText: false,
                            validator: (value) => validateDisplayName(value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: AppTextFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: (value) => validateEmail(value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: AppTextFormField(
                            controller: _passwordController,
                            hintText: 'Mot de passe',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) => validatePassword(value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: kDefaultPadding,
                            right: kDefaultPadding,
                            bottom: kDefaultPadding,
                          ),
                          child: AppTextFormField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirmez votre mot de passe',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) => validateConfirmPassword(_passwordController.text, value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: AppElevatedButton(
                            onPressed: () {
                              if (_registerFormKey.currentState!.validate()) {
                                context.pushNamed('loading');
                                AppUserService.register(_emailController.text, _passwordController.text,
                                    _displayNameController.text).then((value) {
                                  if (value != null) {
                                    _displayNameController.clear();
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _confirmPasswordController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Compte créé avec succès!',
                                        textAlign:  TextAlign.center,
                                        style: TextStyle(color: kWhiteColor,),
                                      ),
                                      backgroundColor: kGreenColor,
                                    ));
                                    context.pop();
                                    context.goNamed('authentication');
                                  } else {
                                    context.pop();
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Erreur lors de la création du compte',
                                        textAlign:  TextAlign.center,
                                        style: TextStyle(color: kWhiteColor,),
                                      ),
                                      backgroundColor: kRedColor,
                                    ));
                                  }
                                }).onError((error, stackTrace) {
                                  context.pop();
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Erreur de connexion',
                                      textAlign:  TextAlign.center,
                                      style: TextStyle(color: kWhiteColor,),
                                    ),
                                    backgroundColor: kRedColor,
                                  ));
                                });
                              }
                            },
                            buttonText: 'S\'inscrire',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}