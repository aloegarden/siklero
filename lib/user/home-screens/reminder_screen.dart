import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/admin/admin-home_screen.dart';
import 'package:siklero/main.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/home_screen.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  UserData? userData = UserData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(),
      builder:(context, snapshot) {
        if(snapshot.hasError) {
          return Text('An error occured! ${snapshot.error}');
        } else if (snapshot.hasData) {

          userData = snapshot.data;

          return Scaffold(
            backgroundColor: const Color(0xffed8f5b),
            body: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (userData!.role == 'Admin') {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder:(context) => const AdminHomeScreen(),
                      ), 
                      (route) => false
                    );

                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
                } else {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder:(context) => const HomeScreen(),
                      ), 
                      (route) => false
                    );

                  navigatorKey.currentState!.popUntil((route) => route.isFirst);
              } 
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const <Widget>[
                          SizedBox(height: 20,),
                          Image(
                            alignment: Alignment.topCenter,
                            image: AssetImage('asset/img/repair-icon.png'),
                            height: 65,
                            width: 85,
                          ),
                          SizedBox(height: 20,),
                          Text(
                            'This is a reminder to conduct regular check-up before riding',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontFamily: 'OpenSans', fontSize: 36, fontWeight: FontWeight.w700, color: Color(0xff581d00)),
                          ),
                          SizedBox(height: 20,),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    padding: const EdgeInsets.only(bottom: 35),
                    child: const Text(
                      'Tap anywhere to continue',
                      style: TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w400, color: Color(0xff581d00)),
                    ),
                  )
                ],
              )
            )
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }

      },
    );
  }

  Future<UserData?> readUser () async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(user.uid);
    final userSnapShot = await docUser.get();

    if (userSnapShot.exists) {
      return UserData.fromJSON(userSnapShot.data()!);
    }
    
    return null;
  }
}

  