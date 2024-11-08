import 'package:eshop/core/domain/abstractions/notification.abstraction.dart';
import 'package:eshop/firebase_options.dart';
import 'package:eshop/locator.dart';

import 'package:eshop/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  setupLocator();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _EagerInitialization(
      child: MaterialApp.router(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        title: 'eShop',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFCDD4A3),
            surface: const Color(0xFF121212),
            primary: const Color(0xFFCFDA97),
            secondary: const Color(0xFF1E1E1E),
            tertiary: const Color(0xFFFAFCEF),
            brightness: Brightness.dark,
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.openSans(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              height: 0.8,
              color: const Color(0xFFFAFCEF),
            ),
            bodyLarge: GoogleFonts.openSans(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.05,
              height: 1.3,
              color: const Color(0xFFFAFCEF),
            ),
            bodyMedium: GoogleFonts.openSans(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.05,
              height: 1.3,
              color: const Color(0xFFFAFCEF),
            ),
            bodySmall: GoogleFonts.openSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.05,
              height: 1.3,
              color: const Color(0xFFFAFCEF),
            ),
          ),
        ),
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}

class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return child;
  }
}
