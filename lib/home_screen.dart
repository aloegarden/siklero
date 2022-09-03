import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Logged in as:'),
            SizedBox(height: 10,),
            Text(user.email!),
            ElevatedButton(onPressed:() {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) =>
                  LoginScreen()),
                  (route) => false);
            }, child: Text('logout'))
          ],
        ),
      )
    );
  }

  Future _logOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
