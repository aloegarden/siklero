import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:siklero/main.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/soscall_screen.dart';
import 'package:siklero/user/utils.dart';

class SOSDetailsScreen extends StatefulWidget {
  final UserData? userInfo;
  const SOSDetailsScreen({super.key, required this.userInfo,});

  @override
  State<SOSDetailsScreen> createState() => _SOSDetailsScreenState();
}

class _SOSDetailsScreenState extends State<SOSDetailsScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  SOSCall sosCall = SOSCall();
  final formKey = GlobalKey<FormState>();
  TextEditingController detailsController = TextEditingController();

  loadData () {
    getCurrentPosition().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());
            sosCall.coordinates = GeoPoint(value.latitude, value.longitude);
            //print("${sosCall.coordinates?.latitude}  ${sosCall.coordinates?.longitude}");
          });
  }

  Future<Position> getCurrentPosition () async {

    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Geolocator.requestPermission().then((value) {

      }).onError((error, stackTrace) {
        print("Error: " + error.toString());
      });

      return await Geolocator.getCurrentPosition();
    } else {

      return await Geolocator.getCurrentPosition();
    }
  }

  Future writeSOS() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (sosCall.coordinates == null) {
      loadData();
      return;
    }

    DateTime date = DateTime.now();

    sosCall.userID = user.uid;
    sosCall.details = detailsController.text;
    sosCall.isActive = true;
    sosCall.createdAt = Timestamp.fromDate(date);

    try {

      final docSOS = FirebaseFirestore.instance.collection('sos_call').doc();
      final json = sosCall.toJSON();
      await docSOS.set(json);
      
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:(context) => SOSCallScreen(sosID: docSOS.id,),
          ), 
          (route) => false
        );
  } on FirebaseException catch (e) {
      Utils.showSnackBar(e.message);
  }

  navigatorKey.currentState!.popUntil((route) => route.isFirst);

  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
    detailsController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xffed8f5b),
          title: const Text('SOS Details', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
        ),
    
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFFD4BC),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Image(
                        //alignment: Alignment.topCenter,
                        height: 65,
                        width: 85,
                        image: AssetImage('asset/img/repair-icon.png'),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    const Text("Bicycle Failure Details:", style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.w700, 
                      fontFamily: 'OpenSans', 
                      color: Color(0xff581D00))
                    ),
                    const SizedBox(height: 20,),
                    TextFormField(
                      maxLines: 3,
                      maxLength: 50,
                      style: const TextStyle(fontSize: 20, fontFamily: 'OpenSans'),
                      controller: detailsController,
                      decoration: InputDecoration(
                        hintText: "Type the specified bicycle failure/s encountered.)",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        )
                      ),
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator:(value) => value != null && value.isEmpty
                        ? "Don't leave this field empty"
                        : null
                    ),
                    const SizedBox(height: 50,),
                    ElevatedButton(
                      onPressed:() => writeSOS(), 
                      style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xffe45f1e),
                      padding: EdgeInsets.all(30)
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
          ),
        ),
      ),
    );
  }
}