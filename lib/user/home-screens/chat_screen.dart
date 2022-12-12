import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:siklero/model/message.dart';
import 'package:siklero/model/user_info.dart';
import 'package:siklero/user/utils/utils.dart';

class ChatScreen extends StatefulWidget {
  
  final String callerID;
  final String respondantID;
  const ChatScreen({super.key, required this.callerID, required this.respondantID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final user = FirebaseAuth.instance.currentUser;
  TextEditingController messageController = TextEditingController();
  UserData? userInfo = UserData();

  @override
  void dispose(){
    super.dispose();

    messageController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData?>(
      future: readUser(),
      builder:(context, snapshot) {
        if(snapshot.hasError) {
          return Text('Something went wrong! ${snapshot.error}');
        } else if (snapshot.hasData) {
          userInfo = snapshot.data;

          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();

            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xffed8f5b),
                title: Text('${userInfo!.fName} ${userInfo!.lName}', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
                centerTitle: true,
          
                actions: [
                  IconButton(onPressed:() {
                    Utils.openCall(userInfo!.contact!);
                  }, icon: Icon(Icons.call))
                ],
              ),
          
              body: Stack(
                children: <Widget>[
              
                  chatMessages(),
              
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: MediaQuery.of(context).size.width,
              
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
              
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Send a message...',
                                hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                                border: InputBorder.none
                              )
                            )
                          ),
              
                          const SizedBox(width: 12,),
              
                          GestureDetector(
                            onTap: () async {
                              sendMessage(messageController);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                          
                              decoration: BoxDecoration(
                                color: const Color(0xffed8f5b),
                                borderRadius: BorderRadius.circular(30)
                              ),
                          
                              child: const Center(child: Icon(Icons.send, color: Colors.white,)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              
                ],
              )
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  chatMessages() {
    return StreamBuilder<List<Message>>(
      stream: readChat(),
      builder:(context, snapshot) {
        if (snapshot.hasError) {
            return Center(child: Text('Something went wrong! ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final messages = snapshot.data!;
          

          return messages.isEmpty 
          ? const Center(child : Text('Start typing to start the conversation')) 
          : ListView(
            shrinkWrap: true,
            reverse: true,
            physics: const ScrollPhysics(),
            children: messages.map(buildMessage).toList(),
          );
          
        } else {
          return const Center(child: CircularProgressIndicator(),);
        }
      },
    );
  }

  sendMessage(TextEditingController messageController) async {
    if(messageController.text.isNotEmpty) {
      final docMessage = FirebaseFirestore.instance
      .collection('user_messages')
      .doc(widget.respondantID)
      .collection('messages')
      .doc(widget.callerID)
      .collection('chat');

      DateTime date = DateTime.now();

      final message = Message(
        senderID: user!.uid,
        sentAt: Timestamp.fromDate(date),
        message: messageController.text
      );

      final json = message.toJSON();

      print(json);

      await docMessage.add(json);
      messageController.clear();
    }
  }

  Stream<List<Message>> readChat() {
    
  return FirebaseFirestore.instance
  .collection('user_messages')
  .doc(widget.respondantID)
  .collection('messages')
  .doc(widget.callerID)
  .collection('chat')
  .orderBy('sent_at', descending: true)
  .snapshots()
  .map((snapshot) => 
        snapshot.docs.map((doc) => Message.fromJSON(doc.data())).toList());
  }

  Future<UserData?> readUser() async {

    var documentID = user!.uid == widget.respondantID ? widget.callerID: widget.respondantID;

    final docUser = FirebaseFirestore.instance.collection('user_profile').doc(documentID);
    final snapShot = await docUser.get();

    if (snapShot.exists) {
      return UserData.fromJSON(snapShot.data()!);
    }

    return null;
  }

  Widget buildMessage(Message message) {
    bool isMe = message.senderID == user!.uid ? true : false;
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: isMe ? 0 : 24,
        right: isMe ? 24: 0,
      ),
      
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: isMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        decoration: BoxDecoration(
          borderRadius: isMe 
          ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          )
          : const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20)
          ),
    
          color: isMe 
          ? const Color(0xffed8f5b)
          : Colors.grey 
        ),
    
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              isMe ? "You" : '${userInfo!.fName} ${userInfo!.lName}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
    
            const SizedBox(
              height: 8,
            ),
    
            Text(message.message!,
              textAlign: TextAlign.center, style: const TextStyle(fontSize: 16),)
          ],
        ),
      ),
    );

  }
}