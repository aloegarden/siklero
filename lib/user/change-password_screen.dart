import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/login_screen.dart';
import 'package:siklero/user/home-screens/home_screen.dart';
import 'package:siklero/user/reset-password_screen.dart';
import 'package:siklero/user/utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    repeatPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffed8f5b),

      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text("Change Password", style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: GestureDetector(
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
                          color:  Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                        ),

                        child: Form(
                          key: formKey,

                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 50,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: _buildPasswordField("Current Password", 6, currentPasswordController),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: _buildPasswordField("New Password", 6, newPasswordController),
                              ),
                              const SizedBox(height: 20,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: _buildPasswordField("Repeat Password", 6, repeatPasswordController),
                              ),
                              const SizedBox(height: 30,),
                              Container(
                                width: double.infinity,
                                height: 50,
                                padding: const EdgeInsets.symmetric(horizontal: 30),

                                child: _buildChangePasswordButton(
                                  currentPasswordController, 
                                  newPasswordController, 
                                  repeatPasswordController),
                              ),
                              const SizedBox(height: 10,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Forgot Password?',
                                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 17, color: Color(0xffe45f1e)),
                                    ),
                                    _buildTextButton(context)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String title, int action, TextEditingController controller){
    return Column(
      children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
            ),
          ),
          TextFormField(
            controller: controller,
            obscureText: true,
            textInputAction: TextInputAction.values.elementAt(action),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe45f1e))
              )
            ),
            style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.length < 6
              ? "Enter min. 6 character"
              : null
          ),   
      ],
    );
  }

  Widget _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed:() => Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen())
      ), 
      child: const Text(
        'Reset Password',
        style: TextStyle(fontFamily: 'OpenSans', fontSize: 17, color: Color(0xff581d00)),
        )
      );
  }

  Widget _buildChangePasswordButton(
    TextEditingController currentPasswordController,
    TextEditingController newPasswordController,
    TextEditingController repeatPasswordController
  ) {

    Future changePassword() async{

      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator(),)
      );

      final isValid = formKey.currentState!.validate();
      String userEmail = user.email!;
      if (!isValid) {
        return;
      }

      if (newPasswordController.text.trim() != repeatPasswordController.text.trim()) {
        Utils.showSnackBar("New password does not match. Please try again");
        Navigator.of(context).pop();
        return;
      }

      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: userEmail, 
          password: currentPasswordController.text.trim()
        );

        user.updatePassword(newPasswordController.text.trim()).then((_) {
          Navigator.of(context).pop();
          Utils.showSnackBar('Successfully changed password. Please log in your account again');
          FirebaseAuth.instance.signOut();

          Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
              const LoginScreen()),
              (route) => false);
        }).catchError((error) {
          Navigator.of(context).pop();
          Utils.showSnackBar('Cant change password. $error');
        });

      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        if (e.code == 'user-not-found') {
          Utils.showSnackBar('No user found with that email.');
        } else if (e.code == 'wrong-password') {
          Utils.showSnackBar('Current password does not match. Please try again');
        }
      }
    }

    return ElevatedButton(
      onPressed: changePassword, 
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffe45f1e)
      ),
      
      child: const Text(
        'Change Password',
        style: TextStyle(
          fontFamily: 'OpenSans',
          fontSize: 24,
          fontWeight: FontWeight.w700
        ),
      )
    );
  }
}