import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../models/app_user.dart';
import '../../services/app_user_service.dart';
import '../../utilities/toast_util.dart';
import '../../utilities/validators.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_text_form_field.dart';
import '../../widgets/square_icon_button.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  static const double _dividerHeight = 50;

  late Future<AppUser?> _appUser;

  final GlobalKey<FormState> _usernameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  Color _usernameButtonBackgroundColor = AppColors.grey;
  Color _emailButtonBackgroundColor = AppColors.grey;

  @override
  void initState() {
    _appUser = AppUserService.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
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

          final AppUser appUser = snapshot.data as AppUser;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDesignSystem.defaultPadding * 1.5,
              vertical: AppDesignSystem.defaultPadding,
            ),
            child: ListView(
              children: [
                const Text(
                  'Vos informations',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: _dividerHeight),
                const Padding(
                  padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
                  child: Text(
                    'Nom d\'utilisateur',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                          validator: (value) => Validators.validateDisplayName(value, appUser.displayName),
                          controller: _usernameController,
                          onChanged: () {
                            setState(() {
                              _usernameButtonBackgroundColor = _usernameFormKey.currentState!.validate() ?
                                AppColors.primary : AppColors.grey;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: AppDesignSystem.defaultPadding),
                        child: SquaredIconButton(
                          backgroundColor: _usernameButtonBackgroundColor,
                          onPressed: () {
                            if (!_usernameFormKey.currentState!.validate()) return;
                            context.pushNamed('loading');

                            AppUserService.updateDisplayName(_usernameController.text).then((value) {
                              _usernameController.clear();
                              context.pop();
                              ToastUtil.showSuccessToast(context, 'Votre nom d\'utilisateur a été mis à jour');
                            }).onError((error, stackTrace) {
                              context.pop();
                              ToastUtil.showErrorToast(context, 'Erreur de connexion');
                            });
                          },
                          iconData: Icons.save,
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
                  child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding * 0.6),
                  child: Text(
                    'Adresse email',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                          validator: (value) => Validators.validateEmail(value, appUser.email),
                          controller: _emailController,
                          onChanged: () {
                            setState(() {
                              _emailButtonBackgroundColor = _emailFormKey.currentState!.validate() ?
                                AppColors.primary : AppColors.grey;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: AppDesignSystem.defaultPadding),
                        child: SquaredIconButton(
                          backgroundColor: _emailButtonBackgroundColor,
                          onPressed: () {
                            if (!_emailFormKey.currentState!.validate()) return;
                            context.pushNamed('loading');

                            AppUserService.updateEmail(_emailController.text).then((value) {
                              _emailController.clear();
                              context.pop();
                              ToastUtil.showSuccessToast(context, 'Votre adresse email a été mise à jour');
                            }).onError((error, stackTrace) {
                              context.pop();
                              ToastUtil.showErrorToast(context, 'Erreur de connexion');
                            });
                          },
                          iconData: Icons.save,
                        ),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
                  child: SizedBox(height: _dividerHeight, width: double.infinity, child: Divider()),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: AppDesignSystem.defaultPadding),
                  child: Text(
                    'Changer de mot de passe',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: _passwordFormKey,
                  child: Column(
                    children: [
                      AppTextFormField(
                        hintText: 'Mot de passe actuel',
                        validator: (value) => Validators.validatePassword(value),
                        controller: _currentPasswordController,
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.defaultPadding),
                        child: AppTextFormField(
                          hintText: 'Nouveau mot de passe',
                          validator: (value) => Validators.validatePassword(value),
                          controller: _newPasswordController,
                          obscureText: true,
                        ),
                      ),
                      AppTextFormField(
                        hintText: 'Confirmer le nouveau mot de passe',
                        validator: (value) => Validators.validateConfirmPassword(_newPasswordController.text, value),
                        controller: _confirmNewPasswordController,
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.defaultPadding * 1.5),
                        child: AppElevatedButton(
                          onPressed: () {
                            if (!_passwordFormKey.currentState!.validate()) return;
                            context.pushNamed('loading');

                            AppUserService.updatePassword(_newPasswordController.text,).then((value) {
                              _currentPasswordController.clear();
                              _newPasswordController.clear();
                              _confirmNewPasswordController.clear();
                              context.pop();
                              ToastUtil.showSuccessToast(context, 'Votre mot de passe a été mis à jour');

                            }).onError((error, stackTrace) {
                              context.pop();
                              ToastUtil.showErrorToast(context, 'Erreur de connexion');
                            });
                          },
                          buttonText: 'Changer de mot de passe',
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
