import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'assets/app_colors.dart';
import 'assets/app_design_system.dart';
import 'firebase_options.dart';
import 'models/app_user.dart';
import 'pages/authentication/authentication_page.dart';
import 'pages/authentication/login_page.dart';
import 'pages/authentication/register_page.dart';
import 'pages/daily_pokemon_page.dart';
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
import 'services/app_user_service.dart';
import 'services/pokemon_service.dart';
import 'services/settings_service.dart';
import 'services/shared_preferences_service.dart';
import 'utilities/app_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await AppFirebase.initFirebaseAuth();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPreferencesService.init();
  await SettingsService.init();
  await PokemonService.initPokemonDatabase();
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: kWhiteColor
  //  ,
  //   statusBarIconBrightness: Brightness.dark,
  //   statusBarBrightness: Brightness.dark,
  //   systemNavigationBarColor: kWhiteColor
  //  ,
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
      redirect: (_, __) async {
        AppUser? user = await AppUserService.getUser();
        if (user == null) {
          return '/authentication';
        }

        if (user.dailyPokemonDate != getFormattedDate()) {
          return '/home/daily_pokemon_page';
        }
        return null;
      },
      routes: [
        GoRoute(path: 'daily_pokemon_page',
          name: 'daily_pokemon_page',
          builder: (context, state) => const DailyPokemonScreen(),
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
      title: kAppName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: kWhiteColor,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => kBlackColor)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kGreyColor, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kBlackColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kBlackColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          hintStyle: const TextStyle(color: kGreyColor),
          labelStyle: const TextStyle(color: kBlackColor),
          fillColor: kGreyColor.withOpacity(0.25),
          filled: true,
          contentPadding: const EdgeInsets.all(kDefaultPadding),
        ),
        dialogBackgroundColor: kWhiteColor,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          backgroundColor: kWhiteColor,
          surfaceTintColor: kWhiteColor,
          elevation: kDefaultElevation,
          alignment: Alignment.center,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          foregroundColor: kWhiteColor,
          focusColor: kGreyColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => kWhiteColor),
            foregroundColor: MaterialStateColor.resolveWith((states) => kBlackColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            )),
          )
        ),
        iconTheme: const IconThemeData(color: kPrimaryColor, size: 30,),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kBlackColor),
          bodyMedium: TextStyle(color: kBlackColor),
          bodySmall: TextStyle(color: kBlackColor),
          labelLarge: TextStyle(color: kBlackColor),
          labelMedium: TextStyle(color: kBlackColor),
          labelSmall: TextStyle(color: kBlackColor),
          displayLarge: TextStyle(color: kBlackColor),
          displayMedium: TextStyle(color: kBlackColor),
          displaySmall: TextStyle(color: kBlackColor),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: kBlackColor),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kWhiteColor,
          foregroundColor: kBlackColor,
          titleTextStyle: TextStyle(color: kBlackColor),
          iconTheme: IconThemeData(color: kBlackColor),
          actionsIconTheme: IconThemeData(color: kBlackColor),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) => kBlackColor),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: kWhiteColor,
          iconColor: kBlackColor,
          textColor: kBlackColor,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStateColor.resolveWith((states) => kPrimaryColor),
          textStyle: MaterialStateTextStyle.resolveWith((states) => const TextStyle(color: kWhiteColor)),
          shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          )),
        ),
        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        scaffoldBackgroundColor: kLightBlackColor,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => kWhiteColor)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            borderSide: const BorderSide(color: kGreyColor, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kWhiteColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kWhiteColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: kRedColor),
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          hintStyle: const TextStyle(color: kGreyColor),
          labelStyle: const TextStyle(color: kWhiteColor),
          fillColor: kGreyColor.withOpacity(0.25),
          filled: true,
          contentPadding: const EdgeInsets.all(kDefaultPadding),
        ),
        dialogBackgroundColor: kLightBlackColor,
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          ),
          backgroundColor: kBlackColor,
          surfaceTintColor: kBlackColor,
          elevation: kDefaultElevation,
          alignment: Alignment.center,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryColor,
          foregroundColor: kWhiteColor,
          focusColor: kGreyColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateColor.resolveWith((states) => kBlackColor),
            foregroundColor: MaterialStateColor.resolveWith((states) => kWhiteColor),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            )),
          )
        ),
        iconTheme: const IconThemeData(color: kPrimaryColor, size: 30,),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: kWhiteColor),
          bodyMedium: TextStyle(color: kWhiteColor),
          bodySmall: TextStyle(color: kWhiteColor),
          labelLarge: TextStyle(color: kWhiteColor),
          labelMedium: TextStyle(color: kWhiteColor),
          labelSmall: TextStyle(color: kWhiteColor),
          displayLarge: TextStyle(color: kWhiteColor),
          displayMedium: TextStyle(color: kWhiteColor),
          displaySmall: TextStyle(color: kWhiteColor),
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: kWhiteColor),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: kLightBlackColor,
          foregroundColor: kWhiteColor,
          titleTextStyle: TextStyle(color: kWhiteColor),
          iconTheme: IconThemeData(color: kWhiteColor),
          actionsIconTheme: IconThemeData(color: kWhiteColor),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateColor.resolveWith((states) => kWhiteColor),
          ),
        ),
        listTileTheme: const ListTileThemeData(
          tileColor: kLightBlackColor,
          iconColor: kWhiteColor,
          textColor: kWhiteColor,
        ),
        searchBarTheme: SearchBarThemeData(
          backgroundColor: MaterialStateColor.resolveWith((states) => kPrimaryColor),
          textStyle: MaterialStateTextStyle.resolveWith((states) => const TextStyle(color: kWhiteColor)),
          shadowColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(kDefaultBorderRadius)),
          )),
        ),
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}
