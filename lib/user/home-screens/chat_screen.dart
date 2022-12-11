import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChatScreen extends StatefulWidget {

  final String callerID;
  final String respondantID;
  const ChatScreen({super.key, required this.callerID, required this.respondantID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future addChat() async {
  await FirebaseFirestore.instance
  .collection('user_messages')
  .doc(widget.respondantID)
  .collection('messages')
  .doc(widget.callerID)
  .get().then((docSnapshot) {
    if (docSnapshot.exists) {

    } else {

    }
  });
  }
}