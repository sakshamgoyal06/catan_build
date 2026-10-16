import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexwild_rules/hexwild_rules.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  runApp(const HexwildApp());
}

class HexwildApp extends StatelessWidget {
  const HexwildApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: HexwildLexicon.gameTitle,
      theme: AppTheme.dark(),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
