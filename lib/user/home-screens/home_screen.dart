import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:siklero/model/home.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/user/home-screens/soscall_screen.dart';
import 'package:siklero/user/home-screens/sosdetails_screen.dart';
import 'package:siklero/user/home-screens/sosrespond-details_screen.dart';
import 'package:siklero/user/home-screens/sosrespond_screen.dart';
import 'package:siklero/user/utils/utils.dart';
import '../../model/user_info.dart';
import '../change-password_screen.dart';
import '../editprofile_screen.dart';
import '../../login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription subscription;
  bool hasInternet = false;
  final user = FirebaseAuth.instance.currentUser!;
  UserData? userData = UserData();
  
  bool enabled = false;


  @override 
  void initState() {

    subscription = InternetConnectionChecker().onStatusChange.listen(( result) async {
      final hasInternet = result == InternetConnectionStatus.connected;

      setState(() {
        this.hasInternet = hasInternet;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          userData = snapshot.data;
          //print(userData?.address);
          
          return Scaffold(
              backgroundColor: const Color(0xffed8f5b),
              body: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 85, vertical: 30),
                          child: Image(
                            image: AssetImage('asset/img/siklero-logo.png'),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(top: 20),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: SizedBox(
                                height: 10000,
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  physics: const ScrollPhysics(),
                                                    
                                  children: List.generate(userData!.role == "Regular" ? homeitemsUser.length : homeitemsHelper.length , (index) {
                                    return Center(
                                      child: homeCard(homeitems: userData!.role == "Regular" ? homeitemsUser[index] : homeitemsHelper[index]),);
                                  })
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet<dynamic>(
                    context: context, 
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder:(context) => buildSheet(),
                  );
                },
                backgroundColor: const Color(0xffe45f1e),
                foregroundColor: Colors.white,
                child: const Icon(
                  Icons.settings
                ),
              ),
            );
        }
        else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }
  
  Widget makeDismissible({required Widget child}) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () => Navigator.of(context).pop(),
    child: GestureDetector(onTap: () {}, child: child,),
  );

  Widget buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.8,
        minChildSize: 0.5,
        builder: (_,controller) => Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 30),

          child: ListView(
            controller: controller,

            children: <Widget>[
              const SizedBox(height: 20,),
              Row(
                mainAxisSize: MainAxisSize.min,

                children: <Widget>[
                  const Image(
                    image: AssetImage('asset/img/user-icon.png'),
                    width: 80,
                    height: 80,
                  ),
                  const SizedBox(width: 15,),
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
                            color: Color(0xff581D00)
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          userData!.userName!,
                          style: const TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 24,
                            color: Color(0xff581D00)
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  InfoText(title: 'Contact #:', data: userData!.contact!, maxLine: 1),
                  InfoText(title: 'Address:', data: userData!.address!, maxLine: 3)
                ],
              ),
              const SizedBox(height: 20,),
              const SizedBox(
                width: double.infinity,
                height: 50,
                child: EditButton(),
              ),
              const SizedBox(height: 15,),
              const SizedBox(
                width: double.infinity,
                height: 50,
                child: ResetPassword(),
              ),
              const SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: LogoutButton(context: context, user: user),
              ),
              
            ],
          ),
        )
        )
    );
  }


  Widget homeCard({required Home homeitems}) {
    Color primaryColor = const Color(0xffE45F1E);
    const TextStyle textStyle = TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: Colors.white
    );
    
    return AbsorbPointer(
      absorbing: enabled,
      child: InkWell(
        onTap: () async {

          print(hasInternet);
          if (homeitems.text == "Send SOS") {
            if(!hasInternet) {
              Utils.showSnackBar("No Internet connection. Please connect to the internet and try again");
            } else {
              checkSOSCall();
            }
          } else if (homeitems.text == "Locate Bike Shop" || homeitems.text == "SOS Respond") {
            if(!hasInternet) {
              Utils.showSnackBar("No Internet connection. Please connect to the internet and try again");
            } else {
              Navigator.of(context).push(MaterialPageRoute(builder:(context) => homeitems.screen,));
            }
          } else {
            Navigator.of(context).push(MaterialPageRoute(builder:(context) => homeitems.screen,));
          }

          
        },
        child: Card(
          color: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(child: homeitems.icon),
                  const SizedBox(height: 20,),
                  Flexible(child: Text(homeitems.text, overflow: TextOverflow.fade, style: textStyle, textAlign: TextAlign.center,))
                ],
              ),
            ),
          ),
        ),
      ),
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

  Future checkSOSResponse () async {
    await FirebaseFirestore.instance.collection('sos_call')
    .where('is_active', isEqualTo: true)
    .where('respondant_id', isEqualTo: user.uid)
    .limit(1)
    .get()
    .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => const SOSRespondScreen(),));
      } else {
        querySnapshot.docs.forEach((doc) {
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => SOSRespondDetailsScreen(documentID: doc.id)));
        });
      }
    });
  }

  Future checkSOSCall () async {
    
    await FirebaseFirestore.instance.collection('sos_call')
    .where('caller_id', isEqualTo: user.uid)
    .where('is_active', isEqualTo: true)
    .limit(1)
    .get()
    .then((QuerySnapshot querySnapshot) => {
      if (querySnapshot.docs.isEmpty) {
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => SOSDetailsScreen(userInfo: userData),))
      }
      else {
        querySnapshot.docs.forEach((doc) { 
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => SOSCallScreen(sosID: doc.id),));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(
              'You have a SOS Call currently active, please Cancel SOS to create a new one',
              style: TextStyle(color: Colors.redAccent),))
          );
        })
      }
    });
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
      fontFamily: 'OpenSans',
      fontSize: 24,
      color: Color(0xff581D00)
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textStyle
          ),
        const SizedBox(width: 15,),
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


class EditButton extends StatelessWidget {
  const EditButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => const EditProfileScreen(),));
      }, 
      style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xffe45f1e)
    ),
    child: const Text(
      'Edit Profile',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
    )
    );
  }
}

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder:(context) => const ChangePasswordScreen(),));
      }, 
      style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xffe45f1e)
    ),
    child: const Text(
      'Change Password',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
    )
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
    required this.context,
    required this.user,
  }) : super(key: key);

  final BuildContext context;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        FirebaseAuth.instance.signOut();
        
        //print(user.uid);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
              const LoginScreen()),
              (route) => false);
      }, 
      style: ElevatedButton.styleFrom(
      shape: const StadiumBorder(),
      foregroundColor: Colors.white,
      backgroundColor: const Color(0xffe45f1e)
    ),
    child: const Text(
      'Log Out',
      style: 
        TextStyle(fontFamily: 'OpenSans', fontSize: 24, fontWeight: FontWeight.w700),
    )
    );
  }
}