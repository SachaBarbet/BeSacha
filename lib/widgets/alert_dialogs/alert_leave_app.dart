import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';
import '../app_elevated_button.dart';

class AlertLeaveApp extends StatelessWidget {
  const AlertLeaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actionsOverflowButtonSpacing: AppDesignSystem.defaultPadding * 0.5,
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
      title: const Text('Fermeture de l\'application', textAlign: TextAlign.center),
      content: const Padding(
        padding: EdgeInsets.all(AppDesignSystem.defaultPadding),
        child: Text('Êtes vous sûr de vouloir quitter l\'application ?', textAlign: TextAlign.center),
      ),
      actions: [
        AppElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            SystemNavigator.pop();
          },
          buttonText: 'QUITTER',
          isSmall: true,
        ),
        AppElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          buttonText: 'ANNULER',
          isSmall: true,
          buttonColor: AppColors.grey,
          textColor: AppColors.black,
        ),
      ],
    );
  }
}