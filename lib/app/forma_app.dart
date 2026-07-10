import 'package:flutter/material.dart';
import 'app_router.dart';
import '../core/app_theme.dart';

class FormaApp extends StatelessWidget {
  const FormaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FORMA',
      theme: FormaTheme.light(),
      routerConfig: formaRouter,
    );
  }
}
