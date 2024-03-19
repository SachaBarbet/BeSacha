import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../assets/app_colors.dart';
import '../../assets/app_design_system.dart';

class CGUPage extends StatelessWidget {
  const CGUPage({super.key});

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
        title: const Text('CGU', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _spacerHeight,
          vertical: AppDesignSystem.defaultPadding,
        ),
        child: ListView(
          children: const [
            Text('Dernière mise à jour: 13/03/2024', style: TextStyle(fontSize: 16, color: AppColors.grey),),
            Text('Attention, les conditions d\'utilisation ici présente ne sont pas définitives et ne sont pas à '
                'prendre en comtpe comme telles. Elles sont là à titre d\'exemple.'
            ),
            SizedBox(height: AppDesignSystem.defaultPadding * 2,), // Spacer
            Text('1. Acceptation des conditions', style: _subTitleTextStyle,),
            Text('En accédant à cette application mobile, vous acceptez d\'être lié par ces conditions d\'utilisation, '
                'toutes les lois et réglementations applicables, et acceptez que vous êtes responsable du respect des '
                'lois locales applicables. Si vous n\'êtes pas d\'accord avec l\'une de ces conditions, il vous est '
                'interdit d\'utiliser ou d\'accéder à cette application. Les matériaux contenus dans cette application '
                'sont protégés par le droit d\'auteur et le droit des marques.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('2. Compte utilisateur', style: _subTitleTextStyle,),
            Text('Pour accéder à certaines fonctionnalités de l\'application, vous devrez créer un compte utilisateur. '
                'Vous êtes responsable de maintenir la confidentialité de votre compte et de votre mot de passe et '
                'êtes entièrement responsable de toutes les activités qui se produisent sous votre compte. Vous '
                'acceptez de notifier immédiatement à l\'administrateur de l\'application toute utilisation non '
                'autorisée de votre compte ou de toute autre violation de la sécurité. L\'administrateur de '
                'l\'application ne sera pas responsable de toute perte que vous pourriez subir du fait de quelqu\'un '
                'd\'autre utilisant votre mot de passe ou de votre compte, soit avec ou sans votre consentement.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('3. Utilisation des données personnelles', style: _subTitleTextStyle,),
            Text('En utilisant cette application, vous consentez à la collecte, à l\'utilisation et à la divulgation '
                'de vos données personnelles telles que décrites dans notre Politique de confidentialité.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('4. Utilisation de l\'application', style: _subTitleTextStyle,),
            Text('L\'administrateur de l\'application vous accorde une licence limitée pour accéder et utiliser cette '
                'application à des fins personnelles. Vous ne pouvez pas télécharger ou modifier tout ou partie de '
                'cette application sans l\'autorisation expresse de l\'administrateur de l\'application.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('5. Droits de propriété intellectuelle', style: _subTitleTextStyle,),
            Text('Cette application et son contenu, y compris, mais sans s\'y limiter, le texte, les graphiques, les '
                'images, les logos, les vidéos, les logiciels, les bases de données, les sons, les articles, les '
                'blogs, les forums, les scripts et tout autre contenu, sont la propriété de l\'administrateur de '
                'l\'application et sont protégés par les lois sur le droit d\'auteur.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('6. Limitations de Responsabilité', style: _subTitleTextStyle,),
            Text('L\'administrateur de l\'application ne sera en aucun cas responsable de tout dommage direct, '
                'indirect, spécial ou consécutif résultant de l\'utilisation ou de l\'impossibilité d\'utiliser cette '
                'application, même si l\'administrateur de l\'application a été informé de la possibilité de tels '
                'dommages.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('7. Modifications des CGU', style: _subTitleTextStyle,),
            Text('L\'administrateur de l\'application se réserve le droit de réviser ces conditions d\'utilisation à '
                'tout moment et sans préavis. En utilisant cette application, vous acceptez d\'être lié par la version '
                'alors en vigueur de ces conditions d\'utilisation.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('8. Loi applicable', style: _subTitleTextStyle,),
            Text('Tout litige découlant de l\'utilisation de cette application est régi par les lois de France et sera '
                'soumis à la juridiction exclusive des tribunaux compétents de Paris.'
            ),
            SizedBox(height: _spacerHeight,), // Spacer
            Text('9. Contact', style: _subTitleTextStyle,),
            Text('Si vous avez des questions concernant ces conditions d\'utilisation, veuillez nous contacter à '
                'sacha.barbet@gmail.com'
            )
          ],
        ),
      ),
    );
  }
}
