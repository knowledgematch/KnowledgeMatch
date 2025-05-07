import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:knowledgematch/firebase_options.dart';
import 'package:knowledgematch/ui/admin/view_model/admin_view_model.dart';
import 'package:knowledgematch/ui/chat/view_model/chat_view_model.dart';
import 'package:knowledgematch/ui/core/themes/theme_provider.dart';
import 'package:knowledgematch/ui/find_matches/view_model/find_matches_view_model.dart';
import 'package:knowledgematch/ui/home/view_model/home_view_model.dart';
import 'package:knowledgematch/ui/main/view_model/main_view_model.dart';
import 'package:knowledgematch/ui/profile/view_model/profile_view_model.dart';
import 'package:knowledgematch/ui/splash/view_model/splash_view_model.dart';
import 'package:knowledgematch/ui/splash/widgets/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait mode only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase is working');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  final prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) =>
                  ThemeProvider(isDarkMode: prefs.getBool('isDark') ?? false),
        ),
        ChangeNotifierProvider(create: (_) => MainScreenViewModel()),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
        ChangeNotifierProvider(create: (_) => FindMatchesViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => AdminViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        Provider(create: (_) => GlobalKey<NavigatorState>()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()..init()),
      ],
      child: KnowledgeMatchApp(),
    ),
  );
}

class KnowledgeMatchApp extends StatelessWidget {
  const KnowledgeMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorKey = context.read<GlobalKey<NavigatorState>>();
    final themeProvider = context.watch<ThemeProvider>();
    NotificationService().init(navigatorKey);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'KnowledgeMatch',
      theme: themeProvider.getTheme(),
      home: SplashScreen(),
    );
  }
}
