import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:siklero/admin/admin-edit-profile_screen.dart';

final _firestore = FirebaseFirestore.instance;

const kUserLabelTextStyle = TextStyle(
    fontFamily: 'OpenSansCondensed', fontWeight: FontWeight.w300, fontSize: 16);

List<UsersCard> searchCards = [];
bool isDone = false;
final searchController = TextEditingController();

class ManageUsers extends StatefulWidget {
  ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  @override
  void initState() {
    // TODO: implement initState
    searchController.clear();
    searchCards.clear();
    isDone = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
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
            'Manage Users',
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
                UsersStream(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void searchUser(String query) {
    final suggestions = userCards.where((user) {
      final userName =
          user.fName.toLowerCase() + ' ' + user.lName.toLowerCase();
      print(userName);
      final input = query.toLowerCase();
      return userName.contains(input);
    }).toList();
    setState(() {
      searchCards = suggestions;
    });
  }
}

class UsersStream extends StatefulWidget {
  const UsersStream({Key? key}) : super(key: key);

  @override
  State<UsersStream> createState() => _UsersStreamState();
}
//     .where("role", isEqualTo: "regular")
// .snapshots()

class _UsersStreamState extends State<UsersStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('user_profile')
          .where("role", isEqualTo: "Regular")
          .snapshots(), //collection
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }

        if (!isDone || snapshot.data?.docs.length != userCards.length) {
          final users = snapshot.data?.docs.reversed;
          //here
          int counter = 0;
          userCards.clear();
          for (var user in users!) {
            counter++;
            final userAddress = user.get('address');
            final userEmail = user.get('username');
            final userfName = user.get('first_name');
            final userlName = user.get('last_name');
            final userNumber = user.get('contact');
            final userID = user.id;

            print(userfName + userlName);

            final userCard = UsersCard(
              fName: userfName,
              lName: userlName,
              email: userEmail,
              number: userNumber,
              address: userAddress,
              counter: counter,
              userID: userID,
            );
            userCards.add(userCard);
          }

          searchCards = userCards;
          isDone = true;
        }

        return Expanded(
          child: ListView.builder(
              itemCount: searchCards.length,
              itemBuilder: (context, index) {
                final searchCard = searchCards[index];

                return UsersCard(
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

class UsersCard extends StatelessWidget {
  UsersCard(
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
                                isRegular: true,
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

List<UsersCard> userCards = [];