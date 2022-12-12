import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/chat_screen.dart';
import 'package:siklero/user/utils/utils.dart';

class SOSRespondDetailsScreen extends StatefulWidget {
  
  final SOSCall details;
  final UserData? userDetails;
  const SOSRespondDetailsScreen({super.key, required this.details, required this.userDetails});

  @override
  State<SOSRespondDetailsScreen> createState() => _SOSRespondDetailsScreenState();
}

class _SOSRespondDetailsScreenState extends State<SOSRespondDetailsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late Position currentLocation;
  double distance = 0;
  var distanceText;
  bool isAccepted = false;
  //bool isCancelled = false;



  @override
  void initState (){
    super.initState();
    goToLocation();

  }



  Future<Position> getUserCurrentLocation() async {

    var permissionStatus = await Permission.location.status;
    if (permissionStatus.isDenied) {
      await Geolocator.requestPermission().then((value) {

      }).onError((error, stackTrace) {
        print("Error: " + error.toString());
      });

      return await Geolocator.getCurrentPosition();
    } else {

      return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    }
    
  }
  
  @override
  Widget build(BuildContext context) {

    var date = widget.details.createdAt!.toDate();
    var dateTimeFormat = DateFormat("h:mma").format(date);
    var dateFormat = DateFormat('MMM dd h:mm a').format(date);

    TextStyle headerFormat = const TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w700,
      fontSize: 12
    );

    TextStyle cardFormat = const TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 20
    );

    TextStyle distanceFormat = const TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w700,
      fontSize: 20
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Respond Details', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
        backgroundColor: const Color(0xffed8f5b),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: const Color.fromARGB(255, 201, 201, 201),
              width: MediaQuery.of(context).size.width,
      
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.calendar_month_rounded),
                    const SizedBox(width: 10,),
                    Text(
                      dateFormat,
                      style: headerFormat,
                      //overflow: TextOverflow.fade,
                    ),
                    const Spacer(),
                    Text(
                      'ID# ${widget.details.documentID!}',
                      style: headerFormat,
                      //maxLines: 3,
                    )
                  ],
                ),
              ),
            ),            
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  distance > 1000 ? '${(distance / 1000).toStringAsFixed(2)} KM away from you' : '${distance.toStringAsFixed(2)} Meters away from you',
                  style: distanceFormat,
                ),
              ),
            ),
      
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        borderRadius: BorderRadius.circular(30)
                      ),
                      width: MediaQuery.of(context).size.width,
                  
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          child: ListTile(
                            title: Text(
                              widget.details.locationAddress!,
                          
                              style: cardFormat,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                  
                              children: <Widget>[
                                IconButton(
                                  iconSize: 35,
                                  onPressed:() => Utils.openCall(widget.userDetails!.contact!),
                                  icon: const Icon(Icons.local_phone_outlined, color: Colors.green,),
                                ),
                                const SizedBox(width: 10,),
                                IconButton(
                                  iconSize: 35,
                                  onPressed:() => Utils.openMap(currentLocation.latitude, currentLocation.longitude, widget.details.coordinates!.latitude, widget.details.coordinates!.longitude), 
                                  icon: const Icon(Icons.assistant_direction_rounded, color: Colors.deepOrangeAccent,),
                                ),
                              ],
                            ),
                          )
                        ),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) { return ViewImageScreen(imageUrl: widget.details.imageUrl!,); } ));
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 250,
                            child: Image.network(
                              widget.details.imageUrl!,
                                        
                              fit: BoxFit.cover
                            ),
                          ),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.zoom_in, size: 50, color: Colors.orange,)
                          )
                        ]
                      ),
                    ),
                  ),
                ],
              ),
            ),
      
            const Spacer(),
      
            Container(
              color: const Color.fromARGB(255, 235, 235, 235),
              width: MediaQuery.of(context).size.width,
              child: isAccepted == false ? acceptButton(context) : respondButtons(context),
            )
          ],
        ),
      )
    );
  }

  Future<void> goToLocation() async {
    print("went to go to location");

    currentLocation = await getUserCurrentLocation();

    print(currentLocation);
    print('${widget.details.coordinates!.latitude} ${widget.details.coordinates!.longitude}');
    
    distance = await Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, widget.details.coordinates!.latitude, widget.details.coordinates!.longitude);

    /*
    if(distance > 1000) {
      distance = distance / 1000;
    }
    */

    setState(() {
      
    });
  }

  Future addRespondant() async {
    print(widget.details.documentID);
    await FirebaseFirestore.instance
    .collection('sos_call')
    .doc('${widget.details.documentID}')
    .update({
      'respondant_id' : user.uid
    });

  }

  Future removeResponandt() async {

    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(widget.details.documentID);

    await docSOS.update({'respondant_id' : null});
  }

  Widget acceptButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              isAccepted = !isAccepted;
              addRespondant();

              setState(() {
                
              });
            }, 
            child: const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                "Accept",
                
                style: TextStyle(fontSize: 30),
              ),
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green
            ),
          ),
        ),
      ),
    );
  }

  Widget respondButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),

      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),

            child: SizedBox(
              width: double.infinity,

              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => ChatScreen(callerID: widget.details.callerID!, respondantID: user.uid),)), 
                icon: const Icon(Icons.message_rounded, color: Colors.white,), 
                label: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Message",

                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white
                    ),
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),

            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  isAccepted = !isAccepted;
                  removeResponandt();

                  setState(() {
                    
                  });
                },

                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red
                ),

                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Cancel",
                    
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewImageScreen extends StatelessWidget {
  final String imageUrl;
  const ViewImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context), 
          icon: const Icon(Icons.close))
      ),
      body: GestureDetector(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: 'imageHero',
            child: PhotoView(
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 2,
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}