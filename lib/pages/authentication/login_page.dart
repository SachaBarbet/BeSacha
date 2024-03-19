import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_design_system.dart';
import '../../services/app_firebase.dart';
import '../../services/app_user_service.dart';
import '../../utilities/toast_util.dart';
import '../../utilities/validators.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_text_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  static const double _appBarHeight = 50;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () {context.pop();},),
          toolbarHeight: _appBarHeight,
        ),

        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: _appBarHeight,
              top: kDefaultPadding,
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(kDefaultPadding),
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: kDefaultPadding),
                  child: Text('Connexion', style: TextStyle(fontSize: 24), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: kDefaultPadding),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          child: AppTextFormField(
                            controller: _emailController,
                            hintText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: (value) => Validators.validateEmail(value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding),
                          child: AppTextFormField(
                            controller: _passwordController,
                            hintText: 'Mot de passe',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            validator: (value) => Validators.validatePassword(value),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(kDefaultPadding,),
                          child: AppElevatedButton(
                            onPressed: () {
                              if (!_loginFormKey.currentState!.validate()) return;

                              context.pushNamed('loading');
                              AppUserService.login(_emailController.text, _passwordController.text).then((value) {
                                if (value != null) {
                                  _emailController.clear();
                                  _passwordController.clear();
                                  AppFirebase.updateUserConnected().then((value) {
                                    context.pop();
                                    context.go('/home');
                                  });
                                } else {
                                  context.pop();
                                  ToastUtil.showErrorToast(context, 'Email ou mot de passe incorrect');
                                }
                              }).onError((error, stackTrace) {
                                context.pop();
                                ToastUtil.showErrorToast(context, 'Erreur de connexion');
                                print(error);
                              });
                            },
                            buttonText: 'Se connecter',
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