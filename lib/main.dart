import 'dart:async';

import 'package:bits_trade/screens/bottombar.dart';
import 'package:bits_trade/screens/login/login_page.dart';
import 'package:bits_trade/screens/login/start_screen.dart';
import 'package:bits_trade/screens/profile/profile_screen.dart';
import 'package:bits_trade/screens/sign_up/sign_up_screen.dart';
import 'package:bits_trade/theme.dart';
import 'package:bits_trade/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await checkAndScheduleTokenClear();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late GoRouter _router;
  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/startScreen',
          builder: (context, state) => const StartScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const BottomBar(),
        ),
        GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
       


      ],
      redirect: (context, state) {
        if (_isLoggedIn == null) {
          return '/';
        }
        if (_isLoggedIn! && state.uri.toString() == '/startScreen') {
          return '/home';
        }
        if (!_isLoggedIn! && state.uri.toString() == '/home') {
          return '/startScreen';
        }
        return null;
      },
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');
    setState(() {
      _isLoggedIn = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      routerConfig: _router,
    );
  }
}

Future<void> checkAndScheduleTokenClear() async {
  final tokenTimestamp = await SharedPrefs.getTokenTimestamp();
  if (tokenTimestamp == null) {
    return;
  }

  final tokenSaveTime = DateTime.fromMillisecondsSinceEpoch(tokenTimestamp);
  const expirationDuration = Duration(hours: 23, minutes: 50);
  final currentTime = DateTime.now();
  final timeElapsed = currentTime.difference(tokenSaveTime);

  if (timeElapsed >= expirationDuration) {
    await SharedPrefs.clearToken();
    print('Token cleared immediately as it has already expired.');
  } else {
    final timeRemaining = expirationDuration - timeElapsed;
    Timer(timeRemaining, () async {
      await SharedPrefs.clearToken();
      print('Token cleared after 23 hours and 50 minutes from when it was saved.');
    });
    print('Token will be cleared in ${timeRemaining.inMinutes} minutes.');
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      context.go('/startScreen'); // Navigate to the login screen after 3 seconds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SvgPicture.asset('assets/splash.svg'),
      ),
    );
  }
}