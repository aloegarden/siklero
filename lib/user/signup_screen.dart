import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:siklero/main.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/reminder_screen.dart';
import 'package:siklero/user/utils/utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  String? value;
  final List<String> cities = ["Caloocan", "Las Piñas", "Makati", "Malabon", "Mandaluyong", "Manila", "Marikina", "Muntinlupa", "Navotas", "Parañaque", "Pasay", "Pasig", "Pateros", "Quezon City", "San Juan", "Taguig", "Valenzuela"];
  TextEditingController usernameController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emergencyNameController = TextEditingController();
  TextEditingController emergencyContactController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    contactController.dispose();
    addressController.dispose();

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
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(fontFamily: 'OpenSans', fontSize: 48, fontWeight: FontWeight.w700, color: Color(0xff581d00)),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: const Text(
                                        'Email:',
                                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: emailController,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffe45f1e))
                                        )
                                      ),
                                      style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                                      validator: (email) =>
                                          email != null && !EmailValidator.validate(email)
                                            ? 'Enter a valid email'
                                            : null,
                                    ),   
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildPasswordField('Password:', passwordController),
                            ),
                            /*
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: const Text(
                                        'Password:',
                                        style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      textInputAction: TextInputAction.done,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        border: OutlineInputBorder(),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffe45f1e))
                                        )
                                      ),
                                      style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: (value) => value != null && (!regExp.hasMatch(value))
                                          ? 'Enter min. 8 character (Contain a digit, symbol, upper case, and lower case letter)'
                                          : null
                                    ),   
                                ],
                              ),
                            ),
                            */
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('First Name:', 6, TextInputType.name, fnameController, ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Last Name:', 6, TextInputType.name, lnameController),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildContactField('Contact #:', 6, TextInputType.phone, contactController,),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Address:', 6, TextInputType.streetAddress, addressController),
                            ),
                            const SizedBox(height: 20,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: const Text(
                                      "City:",
                                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.grey, width: 1)
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: value,
                                        isExpanded: true,
                                        items: cities.map(buildMenuItem).toList(), 
                                        onChanged: (value) => setState(() => this.value = value!,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Username:', 6, TextInputType.text, usernameController),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Emergency Contact Name:', 6, TextInputType.text, emergencyNameController),
                            ),
                            const SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildContactField('Emergency Contact #:', 2, TextInputType.number, emergencyContactController),
                            ),
                            const SizedBox(height: 50,),
                            Container(
                              width: double.infinity,
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildSignUpButton(
                                emailController, 
                                passwordController, 
                                fnameController,
                                lnameController,
                                contactController,
                                emergencyNameController,
                                emergencyContactController,
                                addressController,
                                usernameController,
                                value,
                                context, 
                                formKey)
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    'Already have an account?',
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
      )
    );
  }

  Future signUp() async {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder:(context) => const Center(child: CircularProgressIndicator(),),
    );

    try{
      final newUser = 
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );

      UserData newUserInfo = UserData(
        fName: fnameController.text,
        lName: lnameController.text,
        address: addressController.text,
        contact: contactController.text
      );

      writeUser(newUserInfo, newUser.user?.uid);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:(context) => const ReminderScreen(),
        ), 
        (route) => false
      );
    } on FirebaseAuthException catch (e){
      //print(e);
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    }
  }

  Future writeUser(UserData newUserInfo, String? uid) async {

    final docUser = FirebaseFirestore.instance.collection("used_profile").doc(uid);
    final json = newUserInfo.toJson();
    await docUser.set(json);
    
  }

  DropdownMenuItem<String> buildMenuItem(String city) =>
    DropdownMenuItem(
      value: city,
      child: Text(city, style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),)
    );
}

Widget _buildPasswordField(String title, TextEditingController controller) {
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
        obscureText: true,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffe45f1e))
          )
        ),
        style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
      ),
      FlutterPwValidator(
        width: 400, 
        height: 150, 
        minLength: 8, 
        uppercaseCharCount: 1,
        numericCharCount: 1,
        specialCharCount: 1,

        onSuccess: () => null, 
        controller: controller)
    ],
  );
}

Widget _buildContactField(String title, int action, TextInputType textinputType, TextEditingController controller){
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
            keyboardType: textinputType,
            controller: controller,
            maxLength: 10,
            textInputAction: TextInputAction.values.elementAt(action),
            decoration: InputDecoration(
              prefixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text('+63 ', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffe45f1e))
              )
            ),
            style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.isEmpty
              ? "Don't leave this field empty"
              : null
          ),   
      ],
    );
  }

Widget _buildTextField(String title, int action, TextInputType textinputType, TextEditingController controller){
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
            keyboardType: textinputType,
            controller: controller,
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
            validator: (value) => value != null && value.isEmpty
              ? "Don't leave this field empty"
              : null
          ),   
      ],
    );
  }

Widget _buildTextButton(BuildContext context) {
  return TextButton(
    onPressed:() => Navigator.pop(context),
    child: const Text(
      'Sign In',
      style: TextStyle(fontFamily: 'OpenSans', fontSize: 17, color: Color(0xff581d00)),
    )
  );
}

Widget _buildSignUpButton(
  TextEditingController emailController, 
  TextEditingController passwordController, 
  TextEditingController fnameController,
  TextEditingController lnameController,
  TextEditingController  contactController,
  TextEditingController emergencyNameController,
  TextEditingController emergencyContactController,
  TextEditingController  addressController,
  TextEditingController  usernameController,
  String? cityValue,
  BuildContext context, 
  GlobalKey<FormState> formkey){

  Future signUp() async {
    final isValid = formkey.currentState!.validate();
    if (!isValid) return;

    if(cityValue == null){
      Utils.showSnackBar("Please select a city.");
      return;
    }

    showDialog(
      context: context, 
      barrierDismissible: false,
      builder:(context) => const Center(child: CircularProgressIndicator(),),
    );

    try { 
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim(),
      ).then((firebaseUser) async {
        //print(firebaseUser.user?.uid);
        UserData userData = UserData(
          userName: usernameController.text.trim(),
          address: addressController.text.trim(),
          city: cityValue,
          fName: fnameController.text.trim(),
          lName: lnameController.text.trim(),
          contact: contactController.text.trim(),
          emergencycontactName: emergencyNameController.text.trim(),
          emergencycontactNumber: emergencyContactController.text.trim(),
          role: "Regular"
        );
        final docUser = FirebaseFirestore.instance.collection('user_profile').doc(firebaseUser.user?.uid);
        final json = userData.toJson();
        await docUser.set(json);
      });

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder:(context) => const ReminderScreen(),
        ), 
        (route) => false
      );
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.pop(context);
    }
    
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  return ElevatedButton(
    onPressed: signUp, 
    style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xffe45f1e)
    ),
    child: const Text(
      'Sign Up',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
    )
  );
}
