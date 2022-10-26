import 'package:flutter/material.dart';

class SOSCallScreen extends StatefulWidget {
  const SOSCallScreen({super.key});

  @override
  State<SOSCallScreen> createState() => _SOSCallScreenState();
}

class _SOSCallScreenState extends State<SOSCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Call'),
      ),
    );
  }
}