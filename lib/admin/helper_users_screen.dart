import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:siklero/admin/admin-edit-profile_screen.dart';
import 'package:siklero/admin/constants.dart';

List<HelpersCard> searchHelperCards = [];
bool isDone = false;
final searchController = TextEditingController();

class ManageHelpers extends StatefulWidget {
  const ManageHelpers({Key? key}) : super(key: key);

  @override
  State<ManageHelpers> createState() => _ManageHelpersState();
}

class _ManageHelpersState extends State<ManageHelpers> {
  @override
  void initState() {
    // TODO: implement initState
    searchController.clear();
    searchHelperCards.clear();
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
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text(
          'Manage Helper Users',
          style: TextStyle(
              color: Color(0xFF581D00),
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFFED8F5B),
      body: Container(
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 40,
                margin: EdgeInsets.fromLTRB(180, 16, 30, 16),
                child: TextField(
                  controller: searchController,
                  textAlignVertical: TextAlignVertical.bottom,
                  style: TextStyle(fontSize: 15, color: Color(0xFFE45F1E)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFFFD4BC),
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
              HelpersStream(),
            ],
          ),
        ),
      ),
    );
  }

  void searchUser(String query) {
    final suggestions = helperCards.where((helper) {
      final userName =
          helper.fName.toLowerCase() + ' ' + helper.lName.toLowerCase();
      print(userName);
      final input = query.toLowerCase();
      return userName.contains(input);
    }).toList();
    setState(() {
      searchHelperCards = suggestions;
    });
  }
}

class HelpersStream extends StatefulWidget {
  const HelpersStream({Key? key}) : super(key: key);

  @override
  State<HelpersStream> createState() => _HelpersStreamState();
}

class _HelpersStreamState extends State<HelpersStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('user_profile')
          .where("role", isEqualTo: "Helper")
          .snapshots(), //collection
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        if (!isDone || snapshot.data?.docs.length != helperCards.length) {
          final users = snapshot.data?.docs.reversed;
          //here
          int counter = 0;
          helperCards.clear();
          for (var user in users!) {
            counter++;
            final userAddress = user.get('address');
            final userEmail = user.get('username');
            final userfName = user.get('first_name');
            final userlName = user.get('last_name');
            final userNumber = user.get('contact');
            final userID = user.id;

            print(userfName + userlName);

            final userCard = HelpersCard(
              fName: userfName,
              lName: userlName,
              email: userEmail,
              number: userNumber,
              address: userAddress,
              counter: counter,
              userID: userID,
            );
            helperCards.add(userCard);
          }

          searchHelperCards = helperCards;
          isDone = true;
        }

        return Expanded(
          child: ListView.builder(
              itemCount: searchHelperCards.length,
              itemBuilder: (context, index) {
                final searchCard = searchHelperCards[index];

                return HelpersCard(
                    fName: searchCard.fName,
                    lName: searchCard.lName,
                    email: searchCard.email,
                    number: searchCard.number,
                    address: searchCard.address,
                    counter: searchCard.counter,
                    userID: searchCard.userID);
              }),
        );
      },
    );
  }
}

class HelpersCard extends StatelessWidget {
  HelpersCard(
      {required this.fName,
      required this.lName,
      required this.email,
      required this.number,
      required this.address,
      required this.counter,
      required this.userID});

  final String address;
  final String email;
  final String fName;
  final String lName;
  final String number;
  int counter;
  final String userID;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Color(0xFFFFD4BC)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Image(
                  image: AssetImage('asset/img/user-icon.png'),
                  height: 60,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 30,
                          width: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFFED8F5B),
                          ),
                          child: Center(
                            child: Text(
                              '0${counter}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          //color: Color(0xFFED8F5B),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdminEditProfileScreen(
                                address: address,
                                email: email,
                                fName: fName,
                                lName: lName,
                                number: number,
                                userID: userID,
                                isRegular: false,
                              ),
                            ));
                            isDone = false;
                            searchController.clear();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            width: 69,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xFFE45F1E)),
                            child: const Center(
                              child: Text(
                                'Edit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${fName}',
                      style: const TextStyle(
                        fontFamily: 'OpenSansCondensed',
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
                    ),
                    Text(
                      '${lName}',
                      style: const TextStyle(
                        fontFamily: 'OpenSansCondensed',
                        fontWeight: FontWeight.w700,
                        fontSize: 19,
                      ),
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
            Text('Email: ${email}', style: kUserLabelTextStyle),
            Text('Contact Number: ${number}', style: kUserLabelTextStyle),
            Text('Address: ${address}', style: kUserLabelTextStyle),
          ],
        ));
  }
}

List<HelpersCard> helperCards = [];