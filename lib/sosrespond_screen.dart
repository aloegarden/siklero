import 'package:flutter/material.dart';

class SOSRespondScreen extends StatefulWidget {
  const SOSRespondScreen({super.key});

  @override
  State<SOSRespondScreen> createState() => _SOSRespondScreenState();
}

class _SOSRespondScreenState extends State<SOSRespondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Respond'),
      ),
    );
  }
}