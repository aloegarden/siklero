import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/chat-history_screen.dart';
import 'package:siklero/user/utils/utils.dart';

class SOSDetailsHistoryScreen extends StatefulWidget {
  
  final String documentID;
  const SOSDetailsHistoryScreen({super.key, required this.documentID});

  @override
  State<SOSDetailsHistoryScreen> createState() => _SOSDetailsHistoryScreenState();
}

class _SOSDetailsHistoryScreenState extends State<SOSDetailsHistoryScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  SOSCall sosCall = SOSCall();
  UserData userData = UserData();
  //bool isCancelled = false;

  @override
  void initState (){
    super.initState();

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
          return Scaffold(
            appBar: AppBar(
              title: const Text('SOS Details', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
              backgroundColor: const Color(0xffed8f5b),
              centerTitle: true,
              //automaticallyImplyLeading: false,
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
                                title: sosCall.respondantID == null 
                                  ? Text("Respondant ID: None", style: cardFormat) 
                                  : Text("Respondant ID: ${sosCall.respondantID}", style: cardFormat,),
                                subtitle: ElevatedButton.icon(
                                  onPressed: sosCall.respondantID == null ? null : () => Navigator.of(context).push(MaterialPageRoute(builder:(context) => ChatHistoryScreen(callerID: sosCall.callerID!, respondantID: sosCall.respondantID!),)), 
                                  icon: const Icon(Icons.message_rounded, color: Colors.white,), 
                                  label: const Text("Chat Archive")),

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
                ],
              ),
            )
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Future<UserData?> readUser (String id) async {

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(id);
    final docSnapshot = await docUser.get();

    if (docSnapshot.exists) {
      userData = UserData.fromJSON(docSnapshot.data()!);
    }
    return null;
  }

  Future readSOS() async {
    final docSOS = FirebaseFirestore.instance.collection('sos_call').doc(widget.documentID);
    final sosSnapshot = await docSOS.get();

    if (sosSnapshot.exists) {
      return SOSCall.fromJSON(sosSnapshot.data()!);
    }

    return null;
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