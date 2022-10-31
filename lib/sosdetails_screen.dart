import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/model/user_info.dart';

class SOSDetailsScreen extends StatefulWidget {
  const SOSDetailsScreen({super.key, UserData? userInfo});

  @override
  State<SOSDetailsScreen> createState() => _SOSDetailsScreenState();
}

class _SOSDetailsScreenState extends State<SOSDetailsScreen> {

  final user = FirebaseAuth.instance.currentUser!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SOS Details"),
      ),

      body: Center(child: Text(user.uid),),
    );
  }
}