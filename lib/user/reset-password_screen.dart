import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/user/utils/utils.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final formKey = GlobalKey<FormState>();
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

      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },

        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
            
                children: <Widget>[
                  const SizedBox(height: 100,),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                      ),
                      
                      child: Form(
                        key: formKey,
            
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 50,),
                            const Text(
                              'Receive an email to\nreset your password',
                              style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xff581D00)),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField(emailController),
                            ),
                            const SizedBox(height: 50,),
                            Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildSendEmailButton(emailController),
                            )
                          ],
                        ),
                      ),
                    )
                  )
                ],
              ),
            )
          ]
        )
      )
    );
  }

  Widget _buildTextField (TextEditingController emailController) {
    return Column(
      children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: const Text(
              'Email',
              style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe45f1e))
              )
            ),
            style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
            validator: (email) => email != null && !EmailValidator.validate(email)
              ? "Enter a valid email"
              : null
          ),   
      ],
    );
  }

  Widget _buildSendEmailButton (TextEditingController emailController) {

    Future sendEmail() async {
      final isValid = formKey.currentState!.validate();

      if(!isValid) return;

      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),)
      );

      try {
        await FirebaseAuth.instance
              .sendPasswordResetEmail(email: emailController.text.trim());

        Utils.showSnackBar("Password reset email sent.");
        
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Utils.showSnackBar('Email is not linked to any account.');
        }
        
      }

      Navigator.pop(context);
    }


    return ElevatedButton(
      onPressed: sendEmail, 
      style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xffe45f1e)
      ),
      child: const Text(
      'Reset Password',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
      )
    );
  }
}