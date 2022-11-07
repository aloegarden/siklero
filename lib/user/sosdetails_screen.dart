import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:siklero/model/user_info.dart';

class SOSDetailsScreen extends StatefulWidget {
  final UserData? userInfo;
  const SOSDetailsScreen({super.key, required this.userInfo,});

  @override
  State<SOSDetailsScreen> createState() => _SOSDetailsScreenState();
}

class _SOSDetailsScreenState extends State<SOSDetailsScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController detailsController = TextEditingController();

  loadData () {
    getCurrentPosition().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());
            setState(() {
              
            });
          });
  }

  Future<Position> getCurrentPosition () async {

    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
        title: const Text('SOS Details', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffFFD4BC),
            borderRadius: BorderRadius.circular(30)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Image(
                  //alignment: Alignment.topCenter,
                  height: 65,
                  width: 85,
                  image: AssetImage('asset/img/repair-icon.png'),
                ),
              ),
              Text("Bicycle Failure Details:", style: TextStyle(
                fontSize: 24, 
                fontWeight: FontWeight.w700, 
                fontFamily: 'OpenSans', 
                color: Color(0xff581D00))
              ),
              TextFormField(
                controller: detailsController,
                decoration: const InputDecoration(
                  hintText: "Type the specified bicycle failure/s encountered.)"
                ),
                textInputAction: TextInputAction.done,
              ),
              ElevatedButton(
                onPressed: () {
                  print("hello");
                }, 
                style: ElevatedButton.styleFrom(
                shape: const StadiumBorder(),
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xffe45f1e)
                ),
                child: const Text(
                  'Confirm SOS Call',
                  style: 
                    TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
              ))
            ],
          ),
        ),
      ),
    );
  }
}