import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:jiwa_bakti/router/router_setup.dart';
import 'package:jiwa_bakti/themes/color_theme.dart';
import 'package:jiwa_bakti/themes/default_theme.dart';
import 'package:jiwa_bakti/utils/initialize_get_it.dart';
import 'package:jiwa_bakti/models/user.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:jiwa_bakti/services/flowlink_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 CRITICAL: Firebase MUST be initialized before anything uses FirebaseAuth
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Your GetIt setup
  initializeGetIt();

  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flowLinks = FlowLinkService();
  late final User _user;

  @override
  void initState() {
    super.initState();
    _user = GetIt.I<User>();

    // Ensure FlowLinks init runs after UI is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeFlowLinks());
  }

  Future<void> _initializeFlowLinks() async {
    try {
      await _flowLinks.init(router);
      debugPrint("✅ FlowLinks initialized successfully");
    } catch (e) {
      debugPrint("❌ FlowLinks init error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => Sizer(
        builder: (context, orientation, deviceType) => AnimatedBuilder(
          animation: _user,
          builder: (context, child) => ThemeProvider(
            themes: [
              DefaultTheme(),
              AppTheme.light(),
            ],
            defaultThemeId: "default_theme",
            saveThemesOnChange: true,
            loadThemeOnInit: true,
            child: ThemeConsumer(
              child: Builder(
                builder: (context) {
                  return MaterialApp.router(
                    routerConfig: router,
                    title: 'Jiwa Bakti',
                    theme: theme,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
