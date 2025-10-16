import 'package:ai_universe_chat/services/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:ai_universe_chat/pages/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('ar'),
      ],
      path: 'assets/languages',
      fallbackLocale: const Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeService(),
        child: const AIUniverseChat(),
      ),
    ),
  );
}

class AIUniverseChat extends StatelessWidget {
  const AIUniverseChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeService>(
      builder: (context, themeService, child) {
        return MaterialApp(
          title: 'AI Universe Chat',
          theme: themeService.themeData,
          darkTheme: ThemeService.darkTheme, // Keep a dark theme reference for the system
          themeMode: themeService.themeMode,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
