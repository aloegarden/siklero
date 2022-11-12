import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffed8f5b),

      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text('Reset Password', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
        elevation: 0,
      ),

      body: GestureDetector()
    );
  }
}