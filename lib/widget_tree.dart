import '../auth.dart';
import 'package:flutter/material.dart';
import 'package:rg_mana/pages/main_home.dart';
import 'package:rg_mana/pages/login_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MainHome();
        } else {
          return LoginPage();
        }
      });
  }
}






