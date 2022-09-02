import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
                              'Username', 6, usernameController, false
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
                            child: _buildElevatedButton(),
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
                                _buildTextButton()
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

Widget _buildTextButton(){
  return TextButton(
    onPressed:() => print('tapped signup'), 
    child: const Text(
      'Sign Up',
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, color: Color(0xff581d00)),
    )
  );
}

Widget _buildElevatedButton(){
  return ElevatedButton(
    onPressed:() => print('tapped login'), 
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