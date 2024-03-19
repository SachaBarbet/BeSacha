import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../../services/settings_service.dart';

class SettingsPage extends StatefulWidget {
  static const double _dividerHeight = 50;

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  String _brightnessMode = SettingsService.getBrightnessMode();

  Color? _textColor;
  Color? _dropdownColor;

  @override
  Widget build(BuildContext context) {
    if (_brightnessMode != 'system') {
      _textColor = _brightnessMode == 'dark' ? AppColors.white : AppColors.black;
      _dropdownColor = _brightnessMode == 'dark' ? AppColors.black : AppColors.lightGrey;
    } else {
      _textColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? AppColors.white : AppColors.black;
      _dropdownColor = MediaQuery.of(context).platformBrightness
          == Brightness.dark ? AppColors.black : AppColors.lightGrey;
    }


    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Paramètres de l\'application', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: ListView(
          children: [
            const Text('Thème', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDesignSystem.defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: const Text('Changer le thème de l\'application', style: TextStyle(
                      fontSize: 20,
                    ), softWrap: true,)
                  ),
                  DropdownButton(
                    value: _brightnessMode,
                    style: TextStyle(fontSize: 20, color: _textColor,),
                    dropdownColor: _dropdownColor,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'system',child: Text('Système'),),
                      DropdownMenuItem(value: 'light',child: Text('Clair'),),
                      DropdownMenuItem(value: 'dark',child: Text('Sombre'),),
                    ],
                    onChanged: (value) async {
                      await SettingsService.setBrightnessMode(context, value as String);

                      setState(() {
                        _brightnessMode = value;

                        if (_brightnessMode != 'system') {
                          _textColor = _brightnessMode == 'dark' ? AppColors.white : AppColors.black;
                          _dropdownColor = _brightnessMode == 'dark' ? AppColors.black : AppColors.white;
                        } else {
                          _textColor = MediaQuery.of(context).platformBrightness
                              == Brightness.dark ? AppColors.white : AppColors.black;
                          _dropdownColor = MediaQuery.of(context).platformBrightness
                              == Brightness.dark ? AppColors.black : AppColors.white;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
              child: SizedBox(height: SettingsPage._dividerHeight, width: double.infinity, child: Divider()),
            ),
            const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            const Text(
              'Activer les notifications',
              style: TextStyle(fontSize: 20, height: 1.2),
              textAlign: TextAlign.left,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDesignSystem.defaultPadding * 1.5),
              child: SizedBox(height: SettingsPage._dividerHeight, width: double.infinity, child: Divider()),
            ),
            const Text('', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
