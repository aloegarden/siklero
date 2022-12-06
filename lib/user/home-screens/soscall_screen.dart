import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/main.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/home_screen.dart';
import 'package:siklero/user/home-screens/reminder_screen.dart';

class SOSCallScreen extends StatefulWidget {
  final String sosID;
  const SOSCallScreen({super.key, required this.sosID});

  @override
  State<SOSCallScreen> createState() => _SOSCallScreenState();
}

class _SOSCallScreenState extends State<SOSCallScreen> {

  late String status;
  SOSCall? sosCall = SOSCall();
  
  //late String respondantID;

  TextStyle underReview = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: Colors.orange,
    color: Colors.orange
  );

  TextStyle approved = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: Colors.green,
    color: Colors.green
  );

  TextStyle declined = const TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: Colors.red,
    color: Colors.red
  );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('sos_call').doc(widget.sosID).snapshots(),

      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          print("first streambuilder");
          sosCall = SOSCall.fromJSON(snapshot.data!.data()!);

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
                  
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        updateSOSCall();
                        Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                        builder:(context) => const ReminderScreen(),
                    
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
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text("Repsondant: "),
                          sosCall!.respondantID != null ? respondingHelper(sosCall: sosCall) : const Text(''),

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
      },
    );
  }

  Future<UserData?> readHelper(String respondantID) async {
    final docHelper = FirebaseFirestore.instance.collection('user_profile').doc(respondantID);
    final helperSnapshot = await docHelper.get();

    if (helperSnapshot.exists) {
      return UserData.fromJSON(helperSnapshot.data()!);
    }
    
    return null;

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

class respondingHelper extends StatelessWidget {
  respondingHelper({
    Key? key,
    required this.sosCall,
  }) : super(key: key);

  final SOSCall? sosCall;
  UserData? helperData = UserData();

  @override
  Widget build(BuildContext context) {
    print("second streambuilder");
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('user_profile').doc(sosCall?.respondantID).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text(''); 
        } else if (snapshot.hasData) {

          helperData = UserData.fromJSON(snapshot.data!.data()!);
          return Text('${helperData!.fName} ${helperData!.lName}');
        } else {
          return Text(''); 
        }
      }
    );
  }
}