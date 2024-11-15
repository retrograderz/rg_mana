import 'package:flutter/material.dart';

class GDGoPage extends StatefulWidget {
  const GDGoPage({super.key});

  @override
  State<GDGoPage> createState() => _GDGoPageState();
}

class _GDGoPageState extends State<GDGoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('GDGo'),
      ),
    );
  }
}
