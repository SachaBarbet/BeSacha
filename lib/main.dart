import 'dart:async';

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
import 'pages/home_page.dart';
import 'pages/loading_page.dart';
import 'pages/user_page.dart';
import 'properties/app_properties.dart';
import 'services/app_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppFirebase.initFirebaseAuth();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.lightGrey,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.lightGrey,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const BeSacha());
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoadingPage(),
      redirect: (_, __) => AppFirebase.isUserConnected ? '/home' : '/authentication',
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'user',
          name: 'user',
          redirect: (_, __) => AppFirebase.isUserConnected ? null : '/authentication',
          builder: (context, state) => const UserPage(),
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

class BeSacha extends StatelessWidget {
  const BeSacha({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppProperties.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.lightGrey,
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(iconColor: MaterialStateColor.resolveWith((states) => AppColors.black)),
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
          focusColor: AppColors.lightBlack,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
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
        ),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
