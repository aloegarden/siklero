import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RepairGuideScreen extends StatelessWidget {
  const RepairGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Repair Guide', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
      ),
      body: Center(),
    );
  }
}