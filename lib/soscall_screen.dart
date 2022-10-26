import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SOSCallScreen extends StatefulWidget {
  final String sosID;
  const SOSCallScreen({super.key, required this.sosID});

  @override
  State<SOSCallScreen> createState() => _SOSCallScreenState();
}

class _SOSCallScreenState extends State<SOSCallScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: Text('SOS Call', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
        
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            updateSOSCall();
            Navigator.pop(context);
          },
          child: Text(
            'Cancel SOS',
            style: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700,
              fontSize: 40
            ),),
          style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(24),
            minimumSize: Size(300, 300),
            backgroundColor: Color(0xffE45F1E),
            foregroundColor: Colors.white
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