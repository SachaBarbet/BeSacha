import 'dart:async';

import 'package:be_sacha/services/pokemon_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'assets/app_colors.dart';
import 'assets/app_design_system.dart';
import 'firebase_options.dart';
import 'pages/authentication/authentication_page.dart';
import 'pages/authentication/login_page.dart';
import 'pages/authentication/register_page.dart';
import 'pages/friends/add_friend_page.dart';
import 'pages/friends/friend_add_list_page.dart';
import 'pages/friends/friends_page.dart';
import 'pages/game_explanation_page.dart';
import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/pokedex_page.dart';
import 'pages/settings/cgu_page.dart';
import 'pages/settings/confidentiality_page.dart';
import 'pages/settings/settings_home_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/settings/user_page.dart';
import 'properties/app_properties.dart';
import 'services/app_firebase.dart';
import 'services/settings_service.dart';
import 'services/shared_preferences_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppFirebase.initFirebaseAuth();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferencesService.init();
  await SettingsService.init();
  await PokemonService.initPokemonDatabase();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: AppColors.white,
  //   statusBarIconBrightness: Brightness.dark,
  //   statusBarBrightness: Brightness.dark,
  //   systemNavigationBarColor: AppColors.white,
  //   systemNavigationBarIconBrightness: Brightness.dark,
  // ));
  runApp(const BeSacha());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingPage(),
      redirect: (_, __) {
        bool? hadRules = SharedPreferencesService.read('rules');
        return hadRules != null && hadRules ? AppFirebase.isUserConnected ? '/home' : '/authentication' : '/rules';
      },
    ),
    GoRoute(path: '/rules',
    name:'rules',
    builder: (context, state) => const GameExplanationPage(),
    redirect: (_, __) {
        bool? hadRules = SharedPreferencesService.read('rules');
        return hadRules != null && hadRules ? null : AppFirebase.isUserConnected ? '/home' : '/authentication';
     },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'settings',
          name: 'settings',
          redirect: (_, __) => AppFirebase.isUserConnected ? null : '/authentication',
          builder: (context, state) => const SettingsHomePage(),
          routes: [
            GoRoute(
              path: 'user',
              name: 'user',
              builder: (context, state) => const UserPage(),
            ),
            GoRoute(
              path: 'setting',
              name: 'setting',
              builder: (context, state) => const SettingsPage(),
            ),
            GoRoute(
              path: 'cgu',
              name: 'cgu',
              builder: (context, state) => const CGUPage(),
            ),
            GoRoute(
              path: 'confidentiality',
              name: 'confidentiality',
              builder: (context, state) => const ConfidentialityPage(),
            ),
          ],
        ),
        GoRoute(
          path: 'pokedex',
          name: 'pokedex',
          builder: (context, state) => const PokedexPage(),
        ),
        GoRoute(
          path: 'friends',
          name: 'friends',
          builder: (context, state) => const FriendsPage(),
          routes: [
            GoRoute(
              path: 'add-friend-list',
              name: 'add-friend-list',
              builder: (context, state) => const FriendAddListPage(),
            ),
            GoRoute(
              path: 'add-friend',
              name: 'add-friend',
              builder: (context, state) => const AddFriendPage(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: '/authentication',
      name: 'authentication',
      builder: (context, state) => const AuthenticationPage(),
      routes: [
        GoRoute(
          path: 'login',
          name: 'login',
          builder: (context, state) => LoginPage(),
        ),
        GoRoute(
          path: 'register',
          name: 'register',
          builder: (context, state) => RegisterPage(),
        ),
      ],
    ),
  ],
);

class BeSacha extends StatefulWidget {
  const BeSacha({super.key});

  @override
  State<BeSacha> createState() => _BeSacha();

  static void updateTheme(BuildContext context) {
    context.findAncestorStateOfType<_BeSacha>()!.changeTheme();
  }
}

class _BeSacha extends State<BeSacha> {
  ThemeMode _themeMode = SettingsService.getBrightnessMode() == 'system' ?
    ThemeMode.system : SettingsService.getBrightnessMode() == 'light' ? ThemeMode.light : ThemeMode.dark;

  void changeTheme() {
    setState(() {
      _themeMode = SettingsService.getBrightnessMode() == 'system' ?
        ThemeMode.system : SettingsService.getBrightnessMode() == 'light' ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppProperties.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => AppColors.black)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColors.grey, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.black),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.black),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          hintStyle: const TextStyle(color: AppColors.grey),
          labelStyle: const TextStyle(color: AppColors.black),
          fillColor: AppColors.grey.withOpacity(0.25),
          filled: true,
          contentPadding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
        ),
        dialogBackgroundColor: AppColors.white,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          backgroundColor: AppColors.white,
          surfaceTintColor: AppColors.white,
          elevation: AppDesignSystem.defaultElevation,
          alignment: Alignment.center,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          focusColor: AppColors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
            foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.black),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
            )),
          )
        ),
        iconTheme: const IconThemeData(color: AppColors.primary, size: 30,),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.black),
          bodyMedium: TextStyle(color: AppColors.black),
          bodySmall: TextStyle(color: AppColors.black),
          labelLarge: TextStyle(color: AppColors.black),
          labelMedium: TextStyle(color: AppColors.black),
          labelSmall: TextStyle(color: AppColors.black),
          displayLarge: TextStyle(color: AppColors.black),
          displayMedium: TextStyle(color: AppColors.black),
          displaySmall: TextStyle(color: AppColors.black),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: AppColors.black),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.black,
          titleTextStyle: TextStyle(color: AppColors.black),
          iconTheme: IconThemeData(color: AppColors.black),
          actionsIconTheme: IconThemeData(color: AppColors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.black),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: AppColors.white,
          iconColor: AppColors.black,
          textColor: AppColors.black,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
          textStyle: MaterialStateTextStyle.resolveWith((states) => const TextStyle(color: AppColors.white)),
          shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          )),
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightBlack,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => AppColors.white)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
            borderSide: const BorderSide(color: AppColors.grey, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.white),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.red),
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          hintStyle: const TextStyle(color: AppColors.grey),
          labelStyle: const TextStyle(color: AppColors.white),
          fillColor: AppColors.grey.withOpacity(0.25),
          filled: true,
          contentPadding: const EdgeInsets.all(AppDesignSystem.defaultPadding),
        ),
        dialogBackgroundColor: AppColors.lightBlack,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          ),
          backgroundColor: AppColors.black,
          surfaceTintColor: AppColors.black,
          elevation: AppDesignSystem.defaultElevation,
          alignment: Alignment.center,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          focusColor: AppColors.grey,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.black),
            foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDesignSystem.defaultBorderRadius),
            )),
          )
        ),
        iconTheme: const IconThemeData(color: AppColors.primary, size: 30,),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.white),
          bodyMedium: TextStyle(color: AppColors.white),
          bodySmall: TextStyle(color: AppColors.white),
          labelLarge: TextStyle(color: AppColors.white),
          labelMedium: TextStyle(color: AppColors.white),
          labelSmall: TextStyle(color: AppColors.white),
          displayLarge: TextStyle(color: AppColors.white),
          displayMedium: TextStyle(color: AppColors.white),
          displaySmall: TextStyle(color: AppColors.white),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: AppColors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightBlack,
          foregroundColor: AppColors.white,
          titleTextStyle: TextStyle(color: AppColors.white),
          iconTheme: IconThemeData(color: AppColors.white),
          actionsIconTheme: IconThemeData(color: AppColors.white),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) => AppColors.white),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: AppColors.lightBlack,
          iconColor: AppColors.white,
          textColor: AppColors.white,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStateColor.resolveWith((states) => AppColors.primary),
          textStyle: MaterialStateTextStyle.resolveWith((states) => const TextStyle(color: AppColors.white)),
          shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppDesignSystem.defaultBorderRadius)),
          )),
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
