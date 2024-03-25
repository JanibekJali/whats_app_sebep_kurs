import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseCollections {
  static final userCollection = FirebaseFirestore.instance.collection('users');
  static final messagesCollection =
      FirebaseFirestore.instance.collection('message');
}
