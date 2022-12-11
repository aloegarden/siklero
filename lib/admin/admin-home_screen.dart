import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/admin/bikefailures_records_screen.dart';
import 'package:siklero/admin/helper_users_screen.dart';
import 'package:siklero/admin/manage_users_screen.dart';
import 'package:siklero/admin/sos_calls_screen.dart';
import 'package:siklero/login_screen.dart';
import 'package:siklero/model/user_info.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    assigning();
    super.initState();
  }

  String? numberOfRegularUsers;
  String? numberOfHelperUsers;
  String? numberOfSosCalls;
  String? numberOfPendingSosCalls;
  UserData? userData = UserData();
  final user = FirebaseAuth.instance.currentUser!;

  void assigning() async {
    String? regularUsers = await countRegularUsers();
    String? sosCalls = await countSosCalls();
    String? pendingSosCalls = await countPendingSosCalls();
    String? helperUsers = await countHelperUsers();
    setState(() {
      numberOfRegularUsers = regularUsers;
      numberOfSosCalls = sosCalls;
      numberOfPendingSosCalls = pendingSosCalls;
      numberOfHelperUsers = helperUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(),
      builder:(context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          userData = snapshot.data;

          return Scaffold(
            floatingActionButton: SizedBox(
              height: 50,
              width: 60,
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => buildSheet(),
                  );
                },
                backgroundColor: const Color(0xFFE45F1E), //E45F1E
                child: const Icon(
                  Icons.settings,
                  size: 45,
                ),
              ),
            ),
            backgroundColor: const Color(0xFFED8F5B),
            body: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.only(top: 40, left: 30.0, right: 0.0, bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Hero(
                        tag: 'logo',
                        child: Image(
                          image: AssetImage(
                            'asset/img/siklero-logo.png',
                          ),
                          height: 130.0,
                        ),
                      ),
                      Hero(
                        tag: 'red-ribbon',
                        child: Image(
                          image: AssetImage(
                            'asset/img/red-ribbon.png',
                          ),
                          height: 35.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        String? regularUsers = await countRegularUsers();
                        String? sosCalls = await countSosCalls();
                        String? pendingSosCalls = await countPendingSosCalls();
                        String? helperUsers = await countHelperUsers();
                        setState(() {
                          numberOfRegularUsers = regularUsers;
                          numberOfSosCalls = sosCalls;
                          numberOfPendingSosCalls = pendingSosCalls;
                          numberOfHelperUsers = helperUsers;
                        });
                      },
                      child: Scrollbar(
                        child: ListView(
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            //SizedBox(height: 10),
                            ReusableCard(
                              recordedNumber: numberOfSosCalls.toString(),
                              description: 'Bicycle Failures Records',
                              function: 'view',
                              imagePath: 'asset/img/repair-icon.png',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const BikeRecordsScreen(),
                                    ));
                              },
                            ),
                            ReusableCard(
                              recordedNumber: '$numberOfRegularUsers',
                              description: 'Regular Users',
                              function: 'manage',
                              imagePath: 'asset/img/user-icon.png',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManageUsers(),
                                    ));
                              },
                            ),
                            ReusableCard(
                              recordedNumber: numberOfHelperUsers.toString(),
                              description: 'Helper Users',
                              function: 'manage',
                              imagePath: 'asset/img/user-icon.png',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ManageHelpers(),
                                    ));
                              },
                            ),
                            ReusableCard(
                              recordedNumber: numberOfPendingSosCalls.toString(),
                              description: 'Pending SOS call',
                              function: 'manage',
                              imagePath: 'asset/img/user-icon.png',
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ManageSOS(),
                                    ));
                              },
                            ),
                            const SizedBox(
                              height: 70,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

  Future<String> countRegularUsers() async => await FirebaseFirestore.instance
          .collection("user_profile")
          .where("role", isEqualTo: "Regular")
          .get()
          .then((querySnapshot) {
        return numberOfRegularUsers = querySnapshot.size.toString();
      });
  Future<String> countHelperUsers() async => await FirebaseFirestore.instance
          .collection("user_profile")
          .where("role", isEqualTo: "Helper")
          .get()
          .then((querySnapshot) {
        return numberOfHelperUsers = querySnapshot.size.toString();
      });

  Future<String> countSosCalls() async => await FirebaseFirestore.instance
          .collection("sos_call")
          .get()
          .then((querySnapshot) {
        return numberOfSosCalls = querySnapshot.size.toString();
      });
  Future<String> countPendingSosCalls() async =>
      await FirebaseFirestore.instance
          .collection('sos_call')
          .where('is_active', isEqualTo: true)
          .where('is_reviewed', isEqualTo: false)
          .get()
          .then((querySnapshot) {
        print(querySnapshot.size.toString());
        return numberOfSosCalls = querySnapshot.size.toString();
      });

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
          onTap: () {},
          child: child,
        ),
      );

  Widget buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: 0.5,
          maxChildSize: 0.8,
          minChildSize: 0.3,
          builder: (_, controller) => Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ListView(
                  controller: controller,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Image(
                          image: AssetImage('asset/img/user-icon.png'),
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${userData!.fName!} ${userData!.lName!}",
                                style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 24,
                                    color: Color(0xff581D00)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                userData!.userName!,
                                style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontSize: 24,
                                    color: Color(0xff581D00)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InfoText(
                            title: 'Contact#', data: userData!.contact!, maxLine: 1),
                        InfoText(
                            title: 'Address',
                            data: userData!.address!,
                            maxLine: 3)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: EditButton(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: LogoutButton(),
                    )
                  ],
                ),
              )),
    );
  }
}

class ReusableCard extends StatelessWidget {
  final String recordedNumber;
  final String description;
  final String function;
  final String imagePath;
  final VoidCallback onPressed;

  ReusableCard(
      {required this.recordedNumber,
      required this.description,
      required this.function,
      required this.imagePath,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(bottom: 0),
      margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color(0xFFFFD4BC),
      ),
      //padding: EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    recordedNumber,
                    style: const TextStyle(
                      letterSpacing: -5,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      fontSize: 70.0,
                      color: Color(0xFF581D00),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        color: Color(0xFF581D00),
                      ),
                    ),
                  ),
                  Container(
                    //margin: EdgeInsets.only(top: 20, left: 20),
                    margin: const EdgeInsets.only(top: 20),
                    child: Image(
                      image: AssetImage(
                        imagePath,
                      ),
                      height: 40.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 1.0,
            width: 400.0,
            child: Divider(
              color: Color(0xFFED8F5B),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    function,
                    style: const TextStyle(
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w700,
                      fontSize: 14.0,
                      color: Color(0xFF581D00),
                    ),
                  ),
                  GestureDetector(
                    onTap: onPressed,
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({
    Key? key,
    required this.title,
    required this.data,
    required this.maxLine,
  }) : super(key: key);

  final String title;
  final String data;
  final int maxLine;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
        fontFamily: 'OpenSans', fontSize: 24, color: Color(0xff581D00));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: textStyle),
        const SizedBox(
          width: 15,
        ),
        Flexible(
          child: Text(
            data,
            style: textStyle,
            maxLines: maxLine,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

class LogoutButton extends StatelessWidget {
  /*
  const LogoutButton({
    Key? key,
    required this.context,
    required this.user,
  }) : super(key: key);
  final BuildContext context;
  final User user; */

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          //FirebaseAuth.instance.signOut();

          //print(user.uid);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        },
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xffe45f1e)),
        child: const Text(
          'Log Out',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ));
  }
}

class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          // Navigator.of(context).push(MaterialPageRoute(
          //   builder: (context) => const EditProfileScreen(),
          // ));
        },
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xffe45f1e)),
        child: const Text(
          'Edit Profile',
          style: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 24,
              fontWeight: FontWeight.w700),
        ));
  }
}