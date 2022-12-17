import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';

class SOSHistoryScreen extends StatefulWidget {
  const SOSHistoryScreen({super.key});

  @override
  State<SOSHistoryScreen> createState() => _SOSHistoryScreenState();
}

class _SOSHistoryScreenState extends State<SOSHistoryScreen> {

  final user = FirebaseAuth.instance.currentUser;
  UserData? userData = UserData();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text('SOS History', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
      ),
      body: FutureBuilder<UserData?>(
          future: readUser(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong! ${snapshot.error}');
            } else if (snapshot.hasData) {

              userData = snapshot.data;

              return StreamBuilder<List<SOSCall>>(
                stream: readSosHistory(userData!.role),
                builder:(context, snapshot) {
                  if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong! ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final sosCalls = snapshot.data!;
                  print("streambuilder");

                  return sosCalls.isEmpty 
                  ? const Center(child: Text("There are no SOS Request at the moment."),) 
                  :  ListView(
                    //reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    children: sosCalls.map(buildCard).toList(),
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
      ),
    );
  }

  Widget buildCard(SOSCall sosCall) {
    return FutureBuilder<UserData?>(
      future: readUser(sosCall.callerID!),
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
                              child: Column(
                                children: <Widget>[
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
                            '${sosCall.details}',
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

  Future<UserData?> readUser (String id) async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(id);
    final docSnapshot = await docUser.get();

    if (docSnapshot.exists) {
      return UserData.fromJSON(docSnapshot.data()!);
    }

    return null;
  }

  Stream<List<SOSCall>> readSosHistory(String? role) {

    return role == "Regular" 
      ? FirebaseFirestore.instance
          .collection('sos_call')
          .orderBy('created_at')
          .where('is_active', isEqualTo: false)
          .where('caller_id', isEqualTo: user!.uid)
          .snapshots()
          .map((snapshot) => 
            snapshot.docs.map((doc) => SOSCall.fromJSON(doc.data())).toList())
      : FirebaseFirestore.instance
          .collection('sos_call')
          .orderBy('created_at')
          .where('is_active', isEqualTo: false)
          .where('respondant_id', isEqualTo: user!.uid)
          .snapshots()
          .map((snapshot) => 
            snapshot.docs.map((doc) => SOSCall.fromJSON(doc.data())).toList());
  }
}