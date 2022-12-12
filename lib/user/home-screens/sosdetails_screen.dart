import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:siklero/main.dart';
import 'package:siklero/model/sos.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/home-screens/soscall_screen.dart';
import 'package:siklero/user/utils/utils.dart';

class SOSDetailsScreen extends StatefulWidget {
  final UserData? userInfo;
  const SOSDetailsScreen({super.key, required this.userInfo,});

  @override
  State<SOSDetailsScreen> createState() => _SOSDetailsScreenState();
}

class _SOSDetailsScreenState extends State<SOSDetailsScreen> {

  File? chosenImage;
  final user = FirebaseAuth.instance.currentUser!;
  SOSCall sosCall = SOSCall();
  final formKey = GlobalKey<FormState>();
  String? value;
  String address = "";
  bool isDisabled = true;
  final List<String> cities = ["Caloocan", "Las Piñas", "Makati", "Malabon", "Mandaluyong", "Manila", "Marikina", "Muntinlupa", "Navotas", "Parañaque", "Pasay", "Pasig", "Pateros", "Quezon City", "San Juan", "Taguig", "Valenzuela"];
  TextEditingController detailsController = TextEditingController();

  loadData () {
    getCurrentPosition().then((value) async {
            print(value.latitude.toString() + " " + value.longitude.toString());
            sosCall.coordinates = GeoPoint(value.latitude, value.longitude);

            getAddressFromPosition(sosCall.coordinates!.latitude, sosCall.coordinates!.longitude);
            //print("${sosCall.coordinates?.latitude}  ${sosCall.coordinates?.longitude}");
          });
  }

  Future<void> getAddressFromPosition(double latitude, double longitude) async {
    await placemarkFromCoordinates(latitude, longitude).then((List<Placemark> placemarks) {
      Placemark place = placemarks.first;


      setState(() {
        sosCall.locationAddress = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}';
        sosCall.city = place.locality;
        print(sosCall.locationAddress);
        print(sosCall.city);
        /*if(cities.contains(sosCall.city)) {
          isDisabled = false;
        } else {
          Utils.showSnackBar("Your current location is not supported. Sorry for the inconvenience");
        }*/
      });
    });
  }

  Future<Position> getCurrentPosition() async {

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

  Future<String?> uploadFile() async {

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('img/');

    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(chosenImage!);
      await referenceImageToUpload.getDownloadURL().then((value) {
        print("this is the image url : $value");
        //sosCall.imageUrl = value;
        return value;
      });
    } catch (e) {
      print('An error occured $e');
    }

    //return null;
  }

  Future writeSOS() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (chosenImage == null) {
      return Utils.showSnackBar("Please upload an image");
    }

  
    if (sosCall.coordinates == null) {
      loadData();
      return;
    }


    DateTime date = DateTime.now();

    sosCall.callerID = user.uid;
    sosCall.details = detailsController.text;
    sosCall.isActive = true;
    sosCall.isCompleted = false;
    //sosCall.city = "";
    sosCall.createdAt = Timestamp.fromDate(date);

    try {
      String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('img/');

      Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

      await referenceImageToUpload.putFile(chosenImage!);
      await referenceImageToUpload.getDownloadURL().then((value) {
        print("this is the image url : $value");
        sosCall.imageUrl = value;
        print(sosCall.imageUrl);
      });

      final docSOS = FirebaseFirestore.instance.collection('sos_call').doc();
      final json = sosCall.toJSON();
      await docSOS.set(json);
      await docSOS.update({'document_id' : docSOS.id});
      
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:(context) => SOSCallScreen(sosID: docSOS.id,),
          ), 
          (route) => false
        );
  } on FirebaseException catch (e) {
    Utils.showSnackBar(e.message);
  } on Exception catch (e) {
    print('An error occuerd $e');
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
    
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffFFD4BC),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
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
                      const SizedBox(height: 20,),
                      inputImage(),
                      const SizedBox(height: 50,),
                      ElevatedButton(
                        onPressed: /*isDisabled ? null : */() => writeSOS(), 
                        style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xffe45f1e),
                        padding: const EdgeInsets.all(30)
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
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String city) =>
    DropdownMenuItem(
      value: city,
      child: Text(city, style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24),)
    );
    
  Future pickImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);

      if (image == null) return;

      final imageTemporary = File(image.path);
      print(imageTemporary);
      
      setState(() {
        chosenImage = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget inputImage() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          child: ListTile(
            title: chosenImage == null ? const Text("Insert an image"): Text(chosenImage!.path.split("/").last, maxLines: 1, overflow: TextOverflow.ellipsis,),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                IconButton(
                  onPressed: () => pickImage(ImageSource.camera), 
                  icon: const Icon(Icons.camera_alt_rounded)
                ),
                IconButton(
                  onPressed: () => pickImage(ImageSource.gallery), 
                  icon: const Icon(Icons.insert_photo_rounded)
                ),
              ],
            ),
          ),
        ),

        chosenImage == null ? Container() : 
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) { return ViewImageScreen(imagePath: chosenImage!,); } ));
          },
          child: Stack(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 300,
                child: Image.file(chosenImage!, fit: BoxFit.cover,)
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.zoom_in, size: 50, color: Colors.orange)
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ViewImageScreen extends StatelessWidget {
  final File imagePath;
  const ViewImageScreen({super.key, required this.imagePath,});

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
              imageProvider: FileImage(imagePath),
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