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
  
  final String documentID;
  const SOSRespondDetailsScreen({super.key, required this.documentID});

  @override
  State<SOSRespondDetailsScreen> createState() => _SOSRespondDetailsScreenState();
}

class _SOSRespondDetailsScreenState extends State<SOSRespondDetailsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  SOSCall sosCall = SOSCall();
  late Position currentLocation;
  double distance = 0;
  var distanceText;
  bool isAccepted = false;
  //bool isCancelled = false;

  @override
  void initState (){
    super.initState();
    //goToLocation();

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

    return FutureBuilder(
      future: readSOS(),
      builder:(context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          sosCall = snapshot.data;
          var date = sosCall.createdAt!.toDate();
          var dateTimeFormat = DateFormat("h:mma").format(date);
          var dateFormat = DateFormat('MMM dd h:mm a').format(date);
          return FutureBuilder(
            future: goToLocation(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if (snapshot.hasData) {
                return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: const Text('SOS Respond Details', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
                      backgroundColor: const Color(0xffed8f5b),
                      centerTitle: true,
                      automaticallyImplyLeading: false,
                    ),
                    body: SingleChildScrollView(
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
                                    'ID# ${sosCall.documentID!}',
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
                                snapshot.data! > 1000 ? '${(snapshot.data! / 1000).toStringAsFixed(2)} KM away from you' : '${snapshot.data!.toStringAsFixed(2)} Meters away from you',
                                style: distanceFormat,
                              ),
                            ),
                          ),
                      
                          Column(
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
                                          sosCall.locationAddress!,
                                      
                                          style: cardFormat,
                                        ),
                                        trailing: IconButton(
                                          iconSize: 35,
                                          onPressed:() => Utils.openMap(sosCall.coordinates!.latitude, sosCall.coordinates!.longitude), 
                                          icon: const Icon(Icons.assistant_direction_rounded, color: Colors.deepOrangeAccent,),
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
                                    Navigator.push(context, MaterialPageRoute(builder: (context) { return ViewImageScreen(imageUrl: sosCall.imageUrl!,); } ));
                                  },
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: 250,
                                        child: Image.network(
                                          sosCall.imageUrl!,
                                                    
                                          fit: BoxFit.cover,
                    
                                          loadingBuilder: (BuildContext context, Widget child,
                                              ImageChunkEvent? loadingProgress) {
                                            if (loadingProgress == null) return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress.expectedTotalBytes != null
                                                    ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
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
                      
                          //const Spacer(),
                      
                          Container(
                            color: const Color.fromARGB(255, 235, 235, 235),
                            width: MediaQuery.of(context).size.width,
                            child: sosCall.respondantID == null ? acceptButton(context) : respondButtons(context),
                          )
                        ],
                      ),
                    )
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }
            }
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<double> goToLocation() async {
    print("went to go to location");

    currentLocation = await getUserCurrentLocation();

    distance = Geolocator.distanceBetween(currentLocation.latitude, currentLocation.longitude, sosCall.coordinates!.latitude, sosCall.coordinates!.longitude);
    print(distance);

    return distance;
  }

  Future readSOS() async {
    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(widget.documentID);
    final sosSnapshot = await docSOS.get();

    if (sosSnapshot.exists) {
      return SOSCall.fromJSON(sosSnapshot.data()!);
    }

    return null;
  }

  Future addRespondant() async {
    //print(widget.details.documentID);
    await FirebaseFirestore.instance
    .collection('sos_call')
    .doc('${sosCall.documentID}')
    .update({
      'respondant_id' : user.uid
    });

  }

  Future sosCompleted() async {
    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(sosCall.documentID);

    await docSOS.update({'is_completed' : true, 'is_active' : false});
  }


  Future removeResponandt() async {

    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(sosCall.documentID);

    await docSOS.update({'respondant_id' : null});
  }

  Widget acceptButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: Column(
        children: <Widget>[
          Padding(
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

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green
                ), 
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Accept",
                    
                    style: TextStyle(fontSize: 30),
                  ),
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
                  Navigator.pop(context);
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red
                ), 
                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Decline",
                    
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
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => ChatScreen(callerID: sosCall.callerID!, respondantID: user.uid),)), 
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
                  sosCompleted();

                  Navigator.of(context).pop();
                },

                style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue
                ),

                child: const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "SOS Response Complete",
                    
                    style: TextStyle(fontSize: 30),
                  ),
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