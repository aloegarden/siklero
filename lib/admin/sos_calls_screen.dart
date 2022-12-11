import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:siklero/admin/constants.dart';

List<SosCallCard> searchCards = [];
bool isDone = false;

final searchController = TextEditingController();

class ManageSOS extends StatefulWidget {
  const ManageSOS({Key? key}) : super(key: key);

  @override
  State<ManageSOS> createState() => _ManageSOSState();
}

class _ManageSOSState extends State<ManageSOS> {
  @override
  void initState() {
    searchController.clear();
    searchCards.clear();
    isDone = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Pending SOS Calls',
          style: TextStyle(
              color: Color(0xFF581D00),
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFED8F5B),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40,
                margin: const EdgeInsets.fromLTRB(180, 16, 30, 16),
                child: TextField(
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: const TextStyle(fontSize: 15, color: Color(0xFFE45F1E)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFFFD4BC),
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 17,
                      color: Color(0xFFE45F1E),
                    ),
                    hintText: 'Search',
                    hintStyle: (const TextStyle(
                      fontSize: 15,
                      color: Color(0xFFE45F1E),
                    )),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFFE45F1E),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Color(0xFFE45F1E),
                      ),
                    ),
                  ),
                  onChanged: searchUser,
                ),
              ),
              const SosCallStream(),
            ],
          ),
        ),
      ),
    );
  }

  void searchUser(String query) {
    final suggestions = sosCards.where((sosCall) {
      final callerName = sosCall.caller.toLowerCase();
      final input = query.toLowerCase();
      return callerName.contains(input);
    }).toList();
    setState(() {
      searchCards = suggestions;
      print(searchCards);
    });
  }
}

class SosCallStream extends StatefulWidget {
  const SosCallStream({Key? key}) : super(key: key);

  @override
  State<SosCallStream> createState() => _SosCallStreamState();
}

class _SosCallStreamState extends State<SosCallStream> {
  Future<SosCallCard> generateSosCalls(DocumentSnapshot snapshot) async {
    final callerName = await readUser(snapshot.get('caller_id'));
    String time =
        DateFormat('hh:mm a').format(snapshot.get('created_at').toDate());
    String date =
        DateFormat('MMMM dd, yyyy').format(snapshot.get('created_at').toDate());

    return SosCallCard(
      details: snapshot.get('sos_details'),
      caller: callerName.toString(),
      date: date,
      location: snapshot.get('city'),
      respondent: snapshot.get('respondant_id').toString(),
      address: snapshot.get('location_address'),
      docID: snapshot.id,
      time: time,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('SosCallStream build');
    return StreamBuilder<List<SosCallCard>>(
        stream: FirebaseFirestore.instance
            .collection('sos_call')
            .where('is_active', isEqualTo: true)
            .where('is_reviewed', isEqualTo: false)
            .snapshots()
            .asyncMap((sosCalls) => Future.wait([
                  for (var sosCall in sosCalls.docs) generateSosCalls(sosCall)
                ])),
        builder: (context, snapshot) {
          print('streambuilder is called');
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          // List<SosCallCard>? sosCallCards = [];
          final sosCalls = snapshot.data;
          if (!isDone || snapshot.data?.length != sosCards.length) {
            sosCards.clear();
            sosCards = sosCalls!;
            searchCards = sosCards;
            isDone = true;
          }

          // sosCallCards = sosCalls;
          // for (var sosCall in sosCalls!) {
          //   final recordedDetails = sosCall.get('sos_details');
          //   final recordedCaller = sosCall.get('caller_id');
          //   final recordedResponder = sosCall.get('respondant_id');
          //   final recordedDate = sosCall.get('created_at').toDate();
          //   final recordedLocation = sosCall.get('city');
          //   final recordedReview = sosCall.get('is_reviewed');
          //   final recordedApproved = sosCall.get('is_approved');
          //   final recordID = sosCall.id;
          //
          //   final sosCallCard = SosCallCard(
          //     details: recordedDetails,
          //     caller: recordedCaller,
          //     date: recordedDate.toString(),
          //     location: recordedLocation,
          //     respondent: recordedResponder.toString(),
          //     review: recordedReview,
          //     approve: recordedApproved,
          //     docID: recordID,
          //     time: '',
          //   );
          //   sosCallCards.add(sosCallCard);
          // }
          return Expanded(
            child: Scrollbar(
              child: ListView.builder(
                //reverse: true,
                itemCount: searchCards.length,
                itemBuilder: (context, index) {
                  final searchCard = searchCards[index];

                  return SosCallCard(
                      details: searchCard.details,
                      caller: searchCard.caller,
                      date: searchCard.date,
                      location: searchCard.location,
                      respondent: searchCard.respondent,
                      address: searchCard.address,
                      docID: searchCard.docID,
                      time: searchCard.time);
                },
              ),
            ),
          );
        });
  }

  Future<String?> readUser(String userID) async {
    ///Get Single Document by ID
    final docUser =
        FirebaseFirestore.instance.collection('user_profile').doc(userID);
    final snapshot = await docUser.get(); // get 1 document snapshot
    if (snapshot.exists) {
      //return User.fromJson(snapshot.data()!);
      return snapshot.get('first_name') + ' ' + snapshot.get('last_name');
    } else {
      return 'No User';
    }
    //
  }
}

class SosCallCard extends StatefulWidget {
  const SosCallCard({
    Key? key,
    required this.details,
    required this.caller,
    required this.date,
    required this.location,
    required this.respondent,
    required this.address,
    required this.docID,
    required this.time,
  }) : super(key: key);

  final String details;
  final String caller;
  final String date;
  final String location;
  final String respondent;
  final String docID;
  final String time;
  final String address;

  @override
  State<SosCallCard> createState() => _SosCallCardState();
}

class _SosCallCardState extends State<SosCallCard> {
  //final String time;
  @override
  Widget build(BuildContext context) {
    print('SosCallCard build');
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: const Color(0xFFFFD4BC)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 70,
                  width: 75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: const Color(0xFFED8F5B)),
                  child: const Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    const Text(
                      'Bicycle Failure Details:',
                      style: TextStyle(
                          fontFamily: 'OpenSansCondensed',
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                          color: Color(0xFF581D00)),
                    ),
                    Text(
                      widget.details,
                      style: (const TextStyle(
                          fontFamily: 'OpenSansCondensed',
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Color(0xFF581D00))),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 25.0,
              width: 400.0,
              child: Divider(
                color: Color(0xFF581D00),
                thickness: 1,
              ),
            ),
            const Align(
                alignment: Alignment.center,
                child: Text(
                  'SOS details:',
                  style: TextStyle(
                      fontFamily: 'OpenSansCondensed',
                      fontWeight: FontWeight.w300,
                      fontSize: 18),
                )),
            Row(
              children: [
                const Text(
                  'Caller: ',
                  style: kUserLabelTextStyle,
                ),
                Text(
                  widget.caller,
                  style: kUserDetailsTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Responder: ',
                  style: kUserLabelTextStyle,
                ),
                Text(
                  widget.respondent,
                  style: kUserDetailsTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Date: ',
                  style: kUserLabelTextStyle,
                ),
                Text(
                  widget.date,
                  style: kUserDetailsTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Time: ',
                  style: kUserLabelTextStyle,
                ),
                Text(
                  widget.time,
                  style: kUserDetailsTextStyle,
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Location: ',
                  style: kUserLabelTextStyle,
                ),
                Text(
                  widget.location,
                  style: kUserDetailsTextStyle,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text(
                  'Address: ',
                  style: kUserLabelTextStyle,
                ),
                Flexible(
                  child: Text(
                    widget.address.toString(),
                    style: kUserDetailsTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    final docUser = FirebaseFirestore.instance
                        .collection('sos_call')
                        .doc(widget.docID);
                    docUser.update({'is_reviewed': true, 'is_approved': true});
                    //setState(() {});
                    searchController.clear();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFE45F1E)),
                    child: const Center(
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    final docUser = FirebaseFirestore.instance
                        .collection('sos_call')
                        .doc(widget.docID);

                    docUser.update({'is_reviewed': true});
                    //setState(() {});
                    searchController.clear();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 5),
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFFE45F1E)),
                    child: const Center(
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

List<SosCallCard> sosCards = [];