import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/editprofile_screen.dart';
import 'package:siklero/main.dart';
import 'package:siklero/reminder_screen.dart';
import 'package:siklero/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffed8f5b),
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
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Image(
                      image: AssetImage('asset/img/siklero-logo.png'),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(30),
                            alignment: Alignment.topLeft,
                            child: const Text(
                              'Login',
                              style: TextStyle(fontFamily: 'OpenSans', fontSize: 48, fontWeight: FontWeight.w700, color: Color(0xff581d00)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField(
                              'Email', 6, emailController, false
                            )
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField(
                              'Password', 2, passwordController, true
                            )
                          ),
                          const SizedBox(height: 50,),
                          Container(
                            width: double.infinity,
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildLoginButton(emailController, passwordController, context)
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'No account yet?',
                                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, color: Color(0xffe45f1e)),
                                ),
                                _buildTextButton(context)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}

Widget _buildTextButton(BuildContext context){
  return TextButton(
    onPressed:() => Navigator.push(
      context,
      MaterialPageRoute(builder:(context) => EditProfileScreen(),)
    ),
    child: const Text(
      'Sign Up',
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, color: Color(0xff581d00)),
    )
  );
}

Widget _buildLoginButton(TextEditingController emailController, TextEditingController passwordController, BuildContext context){

  Future signIn() async {

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder:(context) => Center(child: CircularProgressIndicator(),),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:(context) => ReminderScreen(),
        ), 
        (route) => false
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  return ElevatedButton(
    onPressed: signIn, 
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: Color(0xffe45f1e)
    ),
    child: const Text(
      'Login',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
    )
  );
}

Widget _buildTextField(String title, int action, TextEditingController controller, bool hideText){
  return Column(
    children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
          ),
        ),
        TextField(
          controller: controller,
          obscureText: hideText,
          textInputAction: TextInputAction.values.elementAt(action),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffe45f1e))
            )
          ),
          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
        ),   
    ],
  );
}