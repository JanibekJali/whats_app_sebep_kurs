// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final Timestamp time;
  final String imageUrl;
  final String senderId;
  final String userName;

  MessageModel({
    required this.userName,
    required this.message,
    required this.time,
    required this.imageUrl,
    required this.senderId,
  });

  Map<String, dynamic> toFirebase() {
    return <String, dynamic>{
      'userName': userName,
      'message': message,
      'time': time.millisecondsSinceEpoch,
      'imageUrl': imageUrl,
      'senderId': senderId,
    };
  }

  factory MessageModel.fromFirebase(Map<String, dynamic> map) {
    return MessageModel(
      userName: map['userName'] as String,
      message: map['message'] as String,
      time: Timestamp.fromMillisecondsSinceEpoch(map['time'] as int),
      imageUrl: map['imageUrl'] as String,
      senderId: map['senderId'] as String,
    );
  }
}
