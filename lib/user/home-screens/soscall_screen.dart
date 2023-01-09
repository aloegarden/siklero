import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siklero/main.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/chat_screen.dart';
import 'package:siklero/user/home-screens/reminder_screen.dart';
import 'package:siklero/user/home-screens/track-helper_screen.dart';

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
          //print("first streambuilder");
          sosCall = SOSCall.fromJSON(snapshot.data!.data()!);

          //bool isCompleted = sosCall!.isCompleted!;
          late String respondant = sosCall?.respondantID ?? '';

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      respondant.isEmpty 
                      ? ElevatedButton(
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
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(24),
                            minimumSize: const Size(300, 300),
                            backgroundColor: const Color(0xffE45F1E),
                            foregroundColor: Colors.white
                          ),
                          child: const Text(
                            'Cancel SOS',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w700,
                              fontSize: 40
                            ),),
                        )
                      : RespondingHelper(sosCall: sosCall, sosId: widget.sosID),
                      ElevatedButton(
                        onPressed: sosCall!.isCompleted! ? () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                            builder:(context) => const ReminderScreen(),
                        
                            ), 
                            (route) => false
                          );
                        
                          navigatorKey.currentState!.popUntil((route) => route.isFirst);
                        } : null, 
                        child: const Text('SOS Response Completed')
                      )
                    ],
                  )
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

class RespondingHelper extends StatefulWidget {
  final String sosId;
  const RespondingHelper({
    Key? key,
    required this.sosCall, required this.sosId,
  }) : super(key: key);

  final SOSCall? sosCall;

  @override
  State<RespondingHelper> createState() => _RespondingHelperState();
}

class _RespondingHelperState extends State<RespondingHelper> {
  UserData? helperData = UserData();

  @override
  Widget build(BuildContext context) {
    //print("second streambuilder");
    return FutureBuilder(
      future: readUser(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          helperData = snapshot.data;
        
          return Padding(
            padding: const EdgeInsets.all(10.0),

            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 221, 221),
                borderRadius: BorderRadius.circular(30)
              ),
              width: MediaQuery.of(context).size.width,

              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListTile(
                  title: Text('${helperData!.fName} ${helperData!.lName}'),
                  subtitle: Text(helperData!.userName!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        onPressed:() {
                          //print('pum,asok');
                          Navigator.of(context).push(MaterialPageRoute(builder:(context) => ChatScreen(callerID: widget.sosCall!.callerID!, respondantID: widget.sosCall!.respondantID!)));
                        }, 
                        icon: const Icon(Icons.message_rounded, color: Colors.blue,)
                      ),
                      IconButton(
                        onPressed:() {
                          Navigator.of(context).push(MaterialPageRoute(builder:(context) => TrackHelperScreen(sourceLocation :widget.sosCall!.helperCoordinates! , destinationLocation: widget.sosCall!.coordinates!, documentID: widget.sosId)));
                        }, 
                        icon: const Icon(Icons.assistant_direction_rounded, color: Colors.green,)
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ); 
        } else {
          return const CircularProgressIndicator(); 
        }
      }
    );
  }

  Future<UserData?> readUser () async {
    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(widget.sosCall?.respondantID);
    final userSnapshot = await docUser.get();

    if (userSnapshot.exists) {
      return UserData.fromJSON(userSnapshot.data()!);
    }

    return null;
  }
}