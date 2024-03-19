import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/app_user_service.dart';
import '../../services/settings_service.dart';
import '../../utilities/validators.dart';
import '../../widgets/alert_dialogs/alert_warning_delete_account.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_text_form_field.dart';
import '../../widgets/square_icon_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<AppUser?> _appUser;

  final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  Color _usernameButtonBackgroundColor = kGreyColor;
  Color _emailButtonBackgroundColor = kGreyColor;
  Color? _backgroundColor;

  final String _brightnessMode = SettingsService.getBrightnessMode();

  void openWarningDeleteAccountAlertDialog(BuildContext context) {
    showDialog(context: context, builder: (context) => const AlertWarningDeleteAccount(),);
  }

  @override
  void initState() {
    _appUser = AppUserService.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_brightnessMode != 'system') {
      _backgroundColor = _brightnessMode == 'dark' ? kBlackColor : kLightGreyColor;
    } else {
      _backgroundColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? kBlackColor : kLightGreyColor;
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Vos informations', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: _appUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          AppUser appUser = snapshot.data as AppUser;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding * 1.5,
              vertical: kDefaultPadding,
            ),
            child: ListView(
              children: [
                TextButton(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: appUser.username));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Nom d\'utilisateur copié dans le presse-papier',
                          textAlign:  TextAlign.center,
                          style: TextStyle(color: kWhiteColor,),
                        ),
                        backgroundColor: kGreenColor,
                      ));
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    backgroundColor: _backgroundColor,
                  ),
                  child: Center(
                    child: Text('Appuie pour copier : ${appUser.username}',
                      style: const TextStyle(fontSize: 16), textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: kDividerHeight),
                const Padding(
                  padding: EdgeInsets.only(bottom: kDefaultPadding * 0.6),
                  child: Text('Nom d\'utilisateur', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Form(
                  key: _usernameFormKey,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          hintText: appUser.displayName,
                          validator: (value) => validateDisplayName(value, appUser.displayName),
                          controller: _usernameController,
                          onChanged: () {
                            setState(() {
                              _usernameButtonBackgroundColor = _usernameFormKey.currentState!.validate() ?
                                kPrimaryColor : kGreyColor;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: kDefaultPadding),
                        child: SquaredIconButton(
                          backgroundColor: _usernameButtonBackgroundColor,
                          onPressed: () {
                            if (!_usernameFormKey.currentState!.validate()) return;
                            context.pushNamed('loading');

                            AppUserService.updateDisplayName(_usernameController.text).then((value) {
                              setState(() {
                                appUser.displayName = _usernameController.text;
                              });
                              _usernameController.clear();
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Votre nom d\'utilisateur a été mis à jour',
                                  textAlign:  TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kGreenColor,
                              ));
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
                          },
                          iconData: Icons.save,
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
                  child: SizedBox(height: kDividerHeight, width: double.infinity, child: Divider()),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: kDefaultPadding * 0.6),
                  child: Text('Adresse email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Form(
                  key: _emailFormKey,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppTextFormField(
                          hintText: appUser.email,
                          validator: (value) => validateEmail(value, appUser.email),
                          controller: _emailController,
                          onChanged: () {
                            setState(() {
                              _emailButtonBackgroundColor = _emailFormKey.currentState!.validate() ?
                                kPrimaryColor : kGreyColor;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: kDefaultPadding),
                        child: SquaredIconButton(
                          backgroundColor: _emailButtonBackgroundColor,
                          onPressed: () {
                            if (!_emailFormKey.currentState!.validate()) return;
                            context.pushNamed('loading');

                            AppUserService.updateEmail(_emailController.text).then((value) {
                              setState(() {
                                appUser.email = _emailController.text;
                              });
                              _emailController.clear();
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Votre adresse email a été mise à jour',
                                  textAlign:  TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kRedColor,
                              ));
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
                          },
                          iconData: Icons.save,
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
                  child: SizedBox(height: kDividerHeight, width: double.infinity, child: Divider()),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: kDefaultPadding),
                  child: Text('Changer de mot de passe', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                ),
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        hintText: 'Mot de passe actuel',
                        validator: (value) => validatePassword(value),
                        controller: _currentPasswordController,
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                        child: AppTextFormField(
                          hintText: 'Nouveau mot de passe',
                          validator: (value) => validatePassword(value),
                          controller: _newPasswordController,
                          obscureText: true,
                        ),
                      ),
                      AppTextFormField(
                        hintText: 'Confirmer le nouveau mot de passe',
                        validator: (value) => validateConfirmPassword(_newPasswordController.text, value),
                        controller: _confirmNewPasswordController,
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: kDefaultPadding * 1.5),
                        child: AppElevatedButton(
                          onPressed: () {
                            if (!_passwordFormKey.currentState!.validate()) return;
                            context.pushNamed('loading');

                            AppUserService.updatePassword(_newPasswordController.text,).then((value) {
                              _currentPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmNewPasswordController.clear();
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text('Votre mot de passe a été mis à jour',
                                  textAlign:  TextAlign.center,
                                  style: TextStyle(color: kWhiteColor,),
                                ),
                                backgroundColor: kGreenColor,
                              ));
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
                          },
                          buttonText: 'Changer de mot de passe',
                          buttonColor: PlatformDispatcher.instance.platformBrightness
                              == Brightness.dark ? kBlackColor : kLightGreyColor,
                          textColor: PlatformDispatcher.instance.platformBrightness
                              == Brightness.dark ? kWhiteColor : kBlackColor,
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
                  child: SizedBox(height: kDividerHeight, width: double.infinity, child: Divider()),
                ),
                AppElevatedButton(
                  onPressed: () {
                    context.pushNamed('loading');
                    AppUserService.logout().then((value) {
                      context.pop();
                      context.go('/authentication');
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
                  },
                  buttonText: 'Se déconnecter',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 1.5),
                  child: SizedBox(height: kDividerHeight, width: double.infinity, child: Divider()),
                ),
                AppElevatedButton(
                  onPressed: () => openWarningDeleteAccountAlertDialog(context),
                  buttonText: 'Supprimer mon compte',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
