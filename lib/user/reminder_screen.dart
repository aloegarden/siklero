import 'package:flutter/material.dart';
import 'package:siklero/user/home_screen.dart';

class ReminderScreen extends StatelessWidget {
  const ReminderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffed8f5b),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder:(context) => const HomeScreen(),)
          );
        },
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Container(
                height: 400,
                width: 315,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
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
                    )
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
  }
}