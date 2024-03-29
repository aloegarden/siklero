import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/sosrespond-details_screen.dart';

class SOSRespondScreen extends StatefulWidget {
  const SOSRespondScreen({super.key});

  @override
  State<SOSRespondScreen> createState() => _SOSRespondScreenState();
}

class _SOSRespondScreenState extends State<SOSRespondScreen> {

  final user = FirebaseAuth.instance.currentUser;
  UserData? helperData = UserData();
  UserData? userData = UserData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text('SOS Respond', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
      ),
      body: FutureBuilder<UserData?>(
        future: readHelperUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
          } else if (snapshot.hasData) {
            helperData = snapshot.data;
            //print(helperData!.city);
            return StreamBuilder<List<SOSCall>>(
              stream: readSOSCalls(),
              builder:(context, snapshot) {
                
                //final testcall = snapshot.data;
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong! ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final sosCalls = snapshot.data!;
                  //print("streambuilder");

                  return sosCalls.isEmpty 
                  ? const Center(child: Text("There are no SOS Request at the moment."),) 
                  :  ListView(
                    //reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    children: sosCalls.map(buildSOSCall).toList(),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator(),);
                }
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        },

      )
    );
  }

  Widget buildSOSCall(SOSCall SOSCall) {
    //String test = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
    return FutureBuilder<UserData?>(
      future: readUser(SOSCall.callerID),
      builder:(context, snapshot) {
        if (snapshot.hasError) {
            return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
            userData = snapshot.data;
            //print("futurebuilder");
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Container(
                //padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: const BoxDecoration(
                  color: Color(0xffffd4bc),
                  borderRadius: BorderRadius.all(Radius.circular(60))
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Image(
                              width: 100,
                              height: 100,
                              image: AssetImage('asset/img/user-icon.png')
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 40,
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:() {
                                          //print('tapped');
                                          Navigator.of(context).push(MaterialPageRoute(builder:(context) => SOSRespondDetailsScreen(documentID: SOSCall.documentID!)));
                                        }, 
                                        style: ElevatedButton.styleFrom(
                                            shape: const StadiumBorder(),
                                            foregroundColor: Colors.white,
                                            backgroundColor: const Color(0xffe45f1e)
                                        ),
                                        child: const Text(
                                          'Details',
                                          style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontSize: 24,
                                            fontWeight: FontWeight.w700
                                          ),
                                        )
                                      ),
                                    ),
                                    Text(
                                      '${userData?.fName} ${userData?.lName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.fade,
                                      style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff581d00)
                                      ),
                                    ),
                                    Text(
                                      '${userData?.contact}',
                                      style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 24,
                                        color: Color(0xff581d00)
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Bicycle Failure Details:',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 20,
                              color: Color(0xff581d00)
                            ),
                          ),
                          Text(
                            '${SOSCall.details}',
                            //test,
                            style: const TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 18,
                              color: Color(0xff581d00)
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                      //SizedBox(height: 40,)
                    ],
                  ),
                )
              ),
            );
        } else {
            return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  Future<UserData?> readHelperUser () async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(user!.uid);
    final snapShot = await docUser.get();

    if (snapShot.exists) {
      return UserData.fromJSON(snapShot.data()!);
    }
    return null;
  }

  Future<UserData?> readUser (String? userID) async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(userID);
    final snapShot = await docUser.get();

    if (snapShot.exists) {
      return UserData.fromJSON(snapShot.data()!);
    }
    return null;
  }
  /* Stream<List<UserData>> getUSerInfo() =>
    FirebaseFirestore.instance
      .collection('user_profile')
      .doc() */

  Stream<List<SOSCall>> readSOSCalls() {
    var today = DateTime.now();
    today = DateTime(today.year, today.month, today.day);
    
    return FirebaseFirestore.instance
      .collection('sos_call')
      .orderBy('created_at')
      .where('is_active', isEqualTo : true)
      .where('respondant_id', isNull: true)
      .where('created_at', isGreaterThanOrEqualTo: today)
      //.where('city', isEqualTo: helperData.city)
      .snapshots()
      .map((snapshot) => 
        snapshot.docs.map((doc) => SOSCall.fromJSON(doc.data())).toList());
  }
}