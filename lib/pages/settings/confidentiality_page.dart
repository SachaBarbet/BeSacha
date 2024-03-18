import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';

class ConfidentialityPage extends StatelessWidget {
  const ConfidentialityPage({super.key});

  static const TextStyle _subTitleTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const double _spacerHeight = AppDesignSystem.defaultPadding * 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop(),),
        title: const Text('Politique de confidentialité', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignSystem.defaultPadding * 1.5,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: ListView(
          children: const [
            Text('Dernière mise à jour: 13/03/2024', style: TextStyle(fontSize: 16, color: AppColors.grey),),
            Text('Attention, la politique de confidentialité ici présente n\'est pas définitive et n\'est pas à prendre'
                ' en compte comme telles. Elle est là à titre d\'exemple.'
            ),
            SizedBox(height: AppDesignSystem.defaultPadding * 2,), // Spacer
            Text('1. Collecte des données', style: _subTitleTextStyle,),
            Text('Nous collectons les informations que vous nous fournissez volontairement, telles que votre nom '
                'd\'utilisateur, votre adresse e-mail et votre mot de passe lorsque vous créez un compte utilisateur. '
                'Nous pouvons également collecter des informations automatiquement lorsque vous utilisez notre '
                'application, telles que votre adresse IP, votre type de navigateur, votre système d\'exploitation et '
                'votre comportement d\'utilisation de l\'application.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('2. Utilisation des données', style: _subTitleTextStyle,),
            Text('Nous pouvons utiliser les informations que nous collectons pour: '
                '  - Personnaliser et améliorer votre expérience utilisateur '
                '  - Créer des rapports sur l\'utilisation de notre application '
                '  - Envoyer des e-mails de confirmation et des mises à jour '
                '  - Communiquer avec vous '
                '  - Trouver et empêcher la fraude'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('3. Partage des données', style: _subTitleTextStyle,),
            Text('Nous ne partageons pas vos informations personnelles avec des tiers. En cas de fusion, de vente '
                'd\'actifs ou de faillite, si des informations sont transférées en tant qu\'actif de l\'entreprise, '
                'les informations resteront soumises à la politique de confidentialité existante.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('4. Sécurité des données', style: _subTitleTextStyle,),
            Text('Nous mettons en œuvre une variété de mesures de sécurité pour protéger la sécurité de vos '
                'informations personnelles. Nous utilisons un cryptage avancé pour protéger les informations '
                'sensibles transmises en ligne. Nous protégeons également vos informations hors ligne. Seuls les '
                'employés qui ont besoin d\'effectuer un travail spécifique (par exemple, la facturation ou le '
                'service à la clientèle) ont accès aux informations personnelles identifiables. Les ordinateurs et '
                'serveurs utilisés pour stocker des informations personnelles identifiables sont conservés dans un '
                'environnement sécurisé.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('5. Consentement', style: _subTitleTextStyle,),
            Text('En utilisant notre application, vous consentez à notre politique de confidentialité.'),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('6. Modification de la politique de confidentialité', style: _subTitleTextStyle,),
            Text('Nous nous réservons le droit de modifier cette politique de confidentialité à tout moment. Si nous '
                'apportons des modifications importantes à cette politique, nous vous en informerons ici même, par '
                'e-mail ou par le biais d\'un avis sur notre application.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('7. Contactez-nous', style: _subTitleTextStyle,),
            Text('Si vous avez des questions concernant cette politique de confidentialité, vous pouvez nous '
                'contacter en utilisant cette adresse : sacha.barbet@gmail.com'
            )
          ],
        ),
      )
    );
  }
}
