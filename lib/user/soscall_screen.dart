import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siklero/main.dart';
import 'package:siklero/user/home_screen.dart';

class SOSCallScreen extends StatefulWidget {
  final String sosID;
  const SOSCallScreen({super.key, required this.sosID});

  @override
  State<SOSCallScreen> createState() => _SOSCallScreenState();
}

class _SOSCallScreenState extends State<SOSCallScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Press \'Cancel SOS\' to return to Home Screen')));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffed8f5b),
          title: const Text('SOS Call', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              updateSOSCall();
              Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
              builder:(context) => const HomeScreen(),

              ), 
              (route) => false
            );

            navigatorKey.currentState!.popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(24),
              minimumSize: Size(300, 300),
              backgroundColor: Color(0xffE45F1E),
              foregroundColor: Colors.white
            ),
            child: const Text(
              'Cancel SOS',
              style: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w700,
                fontSize: 40
              ),),
          ),
          ),
      ),
    );
  }

  Future updateSOSCall () async {
    await FirebaseFirestore.instance
    .collection('sos_call')
    .doc(widget.sosID)
    .update({
      'is_active' : false
    });
    
  }
}