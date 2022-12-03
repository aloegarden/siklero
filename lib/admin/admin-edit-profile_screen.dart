import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siklero/user/utils/utils.dart';
import 'package:siklero/model/users.dart';
import 'package:siklero/admin/manage_users_screen.dart';

class AdminEditProfileScreen extends StatefulWidget {
  final String address;
  final String email;
  final String fName;
  final String lName;
  final String number;
  final String userID;
  final bool isRegular;

  AdminEditProfileScreen(
      {required this.address,
      required this.email,
      required this.fName,
      required this.lName,
      required this.number,
      required this.userID,
      required this.isRegular});

  @override
  State<AdminEditProfileScreen> createState() => _AdminEditProfileScreenState();
}

class _AdminEditProfileScreenState extends State<AdminEditProfileScreen> {
  // final user = FirebaseAuth.instance.currentUser!;
  final formKey = GlobalKey<FormState>();
  // UserData? userData = UserData();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    //Future<UserData?> userInit = readUser();

    // userInit.then((value) {
    //   usernameController.text = value!.userName!;
    //   fnameController.text = value.fName!;
    //   lnameController.text = value.lName!;
    //   contactController.text = value.contact!;
    //   addressController.text = value.address!;
    // });
    fnameController.text = widget.fName;
    lnameController.text = widget.lName;
    usernameController.text = widget.email;
    addressController.text = widget.address;
    contactController.text = widget.number;

    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xffed8f5b),
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),
        ),
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
                  const SizedBox(
                    height: 100,
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 25,
                            ),
                            Container(
                              width: 120,
                              height: 115,
                              alignment: Alignment.center,
                              child: const Image(
                                image: AssetImage('asset/img/user-icon.png'),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('First Name:',
                                  widget.fName, 6, fnameController, false),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Last Name:', widget.lName,
                                  6, lnameController, false),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Contact #:',
                                  widget.number, 6, contactController, false),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Address:', widget.address,
                                  6, addressController, false),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: _buildTextField('Username:', widget.email,
                                  6, usernameController, false),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                                width: double.infinity,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: _buildUpdateButton(
                                  fnameController,
                                  lnameController,
                                  contactController,
                                  addressController,
                                  usernameController,
                                  widget.userID,
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                                width: double.infinity,
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: widget.isRegular
                                    ? _buildSwitchTypeButtonToHelper(
                                        fnameController,
                                        lnameController,
                                        contactController,
                                        addressController,
                                        usernameController,
                                        widget.userID)
                                    : _buildSwitchTypeButtonToRegular(
                                        fnameController,
                                        lnameController,
                                        contactController,
                                        addressController,
                                        usernameController,
                                        widget.userID)),
                            SizedBox(
                              height: 20,
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
  }

  Widget _buildTextField(String title, String value, int action,
      TextEditingController controller, bool hideText) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xffe45f1e)),
          ),
        ),
        TextFormField(
            controller: controller,
            obscureText: hideText,
            textInputAction: TextInputAction.values.elementAt(action),
            decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffe45f1e)))),
            style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) => value != null && value.isEmpty
                ? "Don't leave this field empty"
                : null),
      ],
    );
  }

  Widget _buildUpdateButton(
      TextEditingController fnameController,
      TextEditingController lnameController,
      TextEditingController contactController,
      TextEditingController addressController,
      TextEditingController usernameController,
      String userID) {
    Future editProfile() async {
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
                    int count = 0;
                    //Navigator.of(context).pop();
                    isDone = false;
                    updateUser();

                    Navigator.popUntil(context, (route) => count++ == 2);
                    //print(fnameController.text);
                    Utils.showSnackBar('Profile updated!');
                    //print('profile updated');
                  },
                  child: const Text("Yes")),
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
            backgroundColor: const Color(0xffe45f1e)),
        child: const Text(
          'Update',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ));
  }

  Widget _buildSwitchTypeButtonToHelper(
      TextEditingController fnameController,
      TextEditingController lnameController,
      TextEditingController contactController,
      TextEditingController addressController,
      TextEditingController usernameController,
      String userID) {
    Future changeRole() async {
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
                  Text("Switch this user to helper?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    int count = 0;
                    //Navigator.of(context).pop();
                    isDone = false;
                    changeUserType();

                    Navigator.popUntil(context, (route) => count++ == 2);
                    //print(fnameController.text);
                    Utils.showSnackBar('Profile updated!');
                    //print('profile updated');

                    //Navigator.of(context).popUntil((route) => '/ManageUsers');
                  },
                  child: const Text("Yes")),
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

    return SizedBox(
      height: 30,
      child: ElevatedButton(
          onPressed: changeRole,
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffe45f1e)),
          child: const Text(
            'Change User to Helper',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                fontWeight: FontWeight.w700),
          )),
    );
  }

  Widget _buildSwitchTypeButtonToRegular(
      TextEditingController fnameController,
      TextEditingController lnameController,
      TextEditingController contactController,
      TextEditingController addressController,
      TextEditingController usernameController,
      String userID) {
    Future changeRole() async {
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
                  Text("Switch this user to Regular?"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    int count = 0;
                    //Navigator.of(context).pop();
                    isDone = false;
                    changeUserType();

                    Navigator.popUntil(context, (route) => count++ == 2);
                    //print(fnameController.text);
                    Utils.showSnackBar('Profile updated!');
                    //print('profile updated');

                    //Navigator.of(context).popUntil((route) => '/ManageUsers');
                  },
                  child: const Text("Yes")),
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

    return SizedBox(
      height: 30,
      child: ElevatedButton(
          onPressed: changeRole,
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xffe45f1e)),
          child: const Text(
            'Change User to Regular',
            style: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 24,
                fontWeight: FontWeight.w700),
          )),
    );
  }

  void updateUser() {
    final docUser = FirebaseFirestore.instance
        .collection('user_profile')
        .doc(widget.userID);

    docUser.update({
      'address': addressController.text,
      'contact': contactController.text,
      'first_name': fnameController.text,
      'last_name': lnameController.text,
      'username': usernameController.text
    });
  }

  void changeUserType() {
    final docUser = FirebaseFirestore.instance
        .collection('user_profile')
        .doc(widget.userID);

    if (widget.isRegular) {
      docUser.update({
        'role': 'Helper',
      });
    } else {
      docUser.update({
        'role': 'Regular',
      });
    }
  }
}