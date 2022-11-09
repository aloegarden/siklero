import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class HotlineScreen extends StatelessWidget {
  const HotlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Hotlines', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
      ),
      body: Center(),
    );
  }
}