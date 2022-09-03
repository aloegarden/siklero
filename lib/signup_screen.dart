import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void dispose() {

    super.dispose();
  }

  String _selectedDate = 'Tap to select date';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffed8f5b),
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: Text('Sign Up', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
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
                  SizedBox(height: 100,),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                      ),
                      child: Column(
                        children: <Widget>[
                          const SizedBox(height: 25,),
                          Container(
                            width: 120,
                            height: 115,
                            alignment: Alignment.center,
                            child: const Image(
                              image: AssetImage('asset/img/user-icon.png'),
                            ),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('First Name:', 6, fnameController, false),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('Last Name:', 6, lnameController, false),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Birthday:',
                                    style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
                                    )
                                  ),
                                InkWell(
                                  onTap: () {
                                    print('inkwelltapped');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey
                                      ),
                                      borderRadius: BorderRadius.circular(4)
                                    ),
                                    width: double.infinity,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(width: 5,),
                                        Text(
                                          _selectedDate,
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 24
                                          ),
                                        ),
                                        Spacer(),
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.orange[700],
                                        ),
                                        SizedBox(width: 5,)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('Contact #:', 6, contactController, false),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('Address:', 6, addressController, false),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('Email:', 6, emailController, false),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('Username:', 6, usernameController, false),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildTextField('Password:', 2, passwordController, true),
                          ),
                          const SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            height: 50,
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: _buildSignupButton(emailController, passwordController, context)
                          ),                         
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Already have an account?',
                                  style: TextStyle(fontFamily: 'OpenSans', fontSize: 16, color: Color(0xffe45f1e)),
                                ),
                                _buildTextButton(context),
                              ],
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildTextButton(BuildContext context){
  return TextButton(
    onPressed:() {
      Navigator.pop(context);
    },
    child: const Text(
      'Sign In',
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 16, color: Color(0xff581d00)),
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

Widget _buildSignupButton(TextEditingController emailController, TextEditingController passwordController, BuildContext context){

  Future signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  return ElevatedButton(
    onPressed: signIn, 
    style: ElevatedButton.styleFrom(
      shape: StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: Color(0xffe45f1e)
    ),
    child: const Text(
      'Sign Up',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
    )
  );
}