import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/utils/utils.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();
  UserData? userData = UserData();
  String? cityValue;
  final List<String> cities = ["Caloocan", "Las Piñas", "Makati", "Malabon", "Mandaluyong", "Manila", "Marikina", "Muntinlupa", "Navotas", "Parañaque", "Pasay", "Pasig", "Pateros", "Quezon City", "San Juan", "Taguig", "Valenzuela"];
  TextEditingController usernameController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    
    Future<UserData?> userInit = readUser();

    userInit.then((value) {
      usernameController.text = value!.userName!;
      fnameController.text = value.fName!;
      lnameController.text = value.lName!;
      contactController.text = value.contact!;
      addressController.text = value.address!;
      cityValue = value.city!;
    });

    super.initState();
  }


  @override
  void dispose() {
    usernameController.dispose();
    fnameController.dispose();
    lnameController.dispose();
    contactController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          userData = snapshot.data;
          return Scaffold(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: true,
          backgroundColor: const Color(0xffed8f5b),
          appBar: AppBar(
            backgroundColor: const Color(0xffed8f5b),
            title: const Text('Edit Profile', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
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
                                  child: _buildTextField('First Name:', userData!.fName!, 6, fnameController, false),
                                ),
                                const SizedBox(height: 20,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: _buildTextField('Last Name:', userData!.lName!, 6, lnameController, false),
                                ),
                                const SizedBox(height: 20,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: _buildTextField('Contact #:', userData!.contact!, 6, contactController, false),
                                ),
                                const SizedBox(height: 20,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: _buildTextField('Address:', userData!.address!, 6, addressController, false),
                                ),
                                const SizedBox(height: 20,),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "City:",
                                          style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xffe45f1e)),
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
                                            value: cityValue,
                                            isExpanded: true,
                                            items: cities.map(buildMenuItem).toList(), 
                                            onChanged: (cityValue) => setState(() => this.cityValue = cityValue!,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20,),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: _buildTextField('Username:', userData!.userName!, 6, usernameController, false),
                                ),
                                const SizedBox(height: 30,),
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  padding: const EdgeInsets.symmetric(horizontal: 30),
                                  child: _buildUpdateButton(
                                    fnameController,
                                    lnameController,
                                    contactController,
                                    addressController,
                                    usernameController,
                                    cityValue,
                                    user.uid,)
                                ),
                              ],
                            ),
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
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
        
      }
    );
  }

  Widget _buildTextField(String title, String value, int action, TextEditingController controller, bool hideText){
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.isEmpty
              ? "Don't leave this field empty"
              : null
          ),   
      ],
    );
  }

  Widget _buildUpdateButton(
    TextEditingController fnameController,
    TextEditingController lnameController,
    TextEditingController contactController,
    TextEditingController addressController,
    TextEditingController usernameController,
    String? cityValue,
    String userID){

    Future editProfile() async{

      final isValid = formKey.currentState!.validate();
      if (!isValid) return;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
          title: const Text("Confirmation"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Update changes to profile?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                //print(fnameController.text);
                updateUser();
                Utils.showSnackBar("Profile updated!");
              }, 
              child: const Text("Yes")
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text("No"))
          ],
        );
        },
      );
      //print("pumapasok");    
    }
    return ElevatedButton(
      onPressed: editProfile,
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xffe45f1e)
      ),
      child: const Text(
        'Update',
        style: 
          TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
      )
    );
  }

  Future<UserData?> updateUser() async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(user.uid);

    await docUser.update({
      'address': addressController.text.trim(),
      'contact': contactController.text.trim(),
      'first_name': fnameController.text.trim(),
      'last_name': lnameController.text.trim(),
      'username': usernameController.text.trim(),
      'city': cityValue
    });
    
    return null;
  }

  Future<UserData?> readUser() async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(user.uid);
    final userSnapShot = await docUser.get();

    if (userSnapShot.exists) {
      return UserData.fromJSON(userSnapShot.data()!);
    }

    return null;
  }

  DropdownMenuItem<String> buildMenuItem(String city) =>
    DropdownMenuItem(
      value: city,
      child: Text(city, style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),)
    );
}


