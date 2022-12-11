import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late String? senderID;
  late Timestamp? sentAt;
  late String? message;

  Message({
    this.senderID,
    this.sentAt,
    this.message
  });

  Map<String, dynamic> toJSON () => {
      'sender_id' : senderID,
      'sent_at' : sentAt,
      'message' : message
  };

  static Message fromJSON(Map<String, dynamic> json) => Message(
      senderID: json['sender_id'],
      sentAt: json['sent_at'],
      message: json['message']
    );
}