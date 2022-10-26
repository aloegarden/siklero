import 'dart:ffi';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/model/home.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:siklero/editprofile_screen.dart';
import 'package:siklero/locatebikeshop_screen.dart';
import 'package:siklero/login_screen.dart';
import 'package:siklero/soscall_screen.dart';
import 'package:siklero/sosrespond_screen.dart';

import 'model/user_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final user = FirebaseAuth.instance.currentUser!;
  UserData? userData = UserData();
  
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
                    hasScrollBody: false,
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
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                            ),
                            child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 8,

                              children: List.generate(homeitems.length, (index) {

                                return Center(
                                  child: HomeCard(homeitems: homeitems[index]),
                                );
                              })
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
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

  Widget buildHomeButton(String title, Widget childWidget) {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xffe45f1e)
        ),
        onPressed:() {
          Navigator.of(context).push(MaterialPageRoute(builder:(context) => childWidget,));
        }, 
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 36,
            fontWeight: FontWeight.w700
          ),
          ),
      ),
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
        initialChildSize: 0.7,
        maxChildSize: 0.8,
        minChildSize: 0.3,
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
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        
                        children: <Widget>[
                          Text(
                            user.uid,
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
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  InfoText(title: 'Contact#', data: userData!.contact!, maxLine: 1),
                  InfoText(title: 'Address', data: userData!.address!, maxLine: 3)
                ],
              ),
              const SizedBox(height: 20,),
              const SizedBox(
                width: double.infinity,
                height: 50,
                child: EditButton(),
              ),
              const SizedBox(height: 15,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: LogoutButton(context: context, user: user),
              )
            ],
          ),
        )
        )
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

  Future checkSOSCall () async {
    
    await FirebaseFirestore.instance.collection('sos_call')
    .where('user_id', isEqualTo: user.uid)
    .where('is_active', isEqualTo: true)
    .limit(1)
    .get()
    .then((QuerySnapshot querySnapshot) => {
      if (querySnapshot.docs.isEmpty) {
        //Navigator.of(context).push(MaterialPageRoute(builder:(context) => SOSDetailsScreen(userInfo: userData),))
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
        
        print(user.uid);

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

class HomeCard extends StatelessWidget {
  const HomeCard({super.key, required Home homeitems});
  

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Color(0xffE45F1E);
    final TextStyle textStyle = const TextStyle(
      fontFamily: 'OpenSans',
      fontWeight: FontWeight.w700,
      fontSize: 12
    );

    return Card(
      color: primaryColor,
      child: Center(
        child: Column(
          children: <Widget>[
            //Expanded(child: homeitems)
          ],
        ),
      ),
    );
  }
}
