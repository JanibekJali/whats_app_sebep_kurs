import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whats_app_sebep_kurs/constants/colors/app_colors.dart';
import 'package:whats_app_sebep_kurs/firebase/firebase_collections.dart';
import 'package:whats_app_sebep_kurs/models/message_model.dart';
import 'package:whats_app_sebep_kurs/models/user_model.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String name = '';
  String? name1;
  final TextEditingController _messageController = TextEditingController();
  ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? title;
  UserModel? userModel;

  // @override
  // void initState() {
  //   getUserData();
  //   super.initState();
  // }

  Future<void> _pickImageCamera() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 95,
      maxHeight: 300,
      maxWidth: 300,
    );
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  Future<void> _addMessage() async {
    final messageText = _messageController.text.trim();
    final imageUrl =
        _imageFile != null ? await _uploadImageToStorage(_imageFile!) : null;

    if (messageText.isNotEmpty || imageUrl != null) {
      final messageModel = MessageModel(
        userName: userModel!.userName,
        message: messageText,
        imageUrl: imageUrl ?? '',
        senderId: widget.userModel.id,
        time: Timestamp.now(),
      );

      try {
        await FirebaseCollections.messagesCollection
            .add(messageModel.toFirebase());
        _messageController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (error) {
        print("Failed to add message: $error");
      }
    }
  }

  // final recorder = AudioRecorder();
  // String? recordedFilePath;
  // bool isRecording = false;

  // Future<void> startRecording() async {
  //   if (isRecording) return;
  //   await recorder.start(RecordConfig(), path: '');
  //   setState(() => isRecording = true); // Update recording state in UI
  // }

  // Future<void> stopRecording() async {
  //   if (!isRecording) return;
  //   await recorder.stop();
  //   recordedFilePath = await recorder.stop(); // Get recorded file path
  //   await uploadAudioToFirebase(recordedFilePath!); // Upload audio to Firebase
  //   setState(() => isRecording = false); // Update recording state in UI
  // }

  Future<String> _uploadImageToStorage(XFile imageFile) async {
    final imageFileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final storageRef =
        FirebaseStorage.instance.ref().child('images').child(imageFileName);
    final uploadTask = await storageRef.putFile(File(imageFile.path));
    return await uploadTask.ref.getDownloadURL();
  }

  // Future<void> uploadAudioToFirebase(String path) async {
  //   // Upload audio file to Firebase Storage
  //   // Replace 'audio' with your desired directory in Firebase Storage
  //   Reference storageReference =
  //       FirebaseStorage.instance.ref().child('audio/${DateTime.now()}.mp3');
  //   UploadTask uploadTask = storageReference.putFile(File(path));
  //   await uploadTask.whenComplete(() => log('Audio uploaded to Firebase'));
  // }

  Widget getUserData() {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseCollections.userCollection.doc(widget.userModel.id).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          userModel = UserModel.fromFirebase(data);

          return Text("User: ${userModel!.userName}");
        }

        return Text("loading");
      },
    );
  }

  Widget getMessageData() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseCollections.messagesCollection
          .orderBy('time') // Order by timestamp
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text("No messages");
        }

        final messages = snapshot.data!.docs;
        return ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index].data() as Map<String, dynamic>;
            final chatModel = MessageModel.fromFirebase(messageData);

            // Add logic to display messages based on sender (isMe)
            bool isMe = chatModel.senderId == widget.userModel.id;

            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isMe ? Colors.tealAccent : Colors.grey[200],
              ),
              padding: EdgeInsets.all(8.0),
              margin: EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      chatModel.message,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16),
                    ),
                    Text(
                      chatModel.userName,
                      style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16),
                    ),
                  ],
                ),
                leading: chatModel.imageUrl.isNotEmpty
                    ? Image.network(chatModel.imageUrl)
                    : const SizedBox(),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: getUserData(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getMessageData(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.black,
                    width: 1,
                  ),
                ),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _messageController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Write a message',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _addMessage,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: _pickImageCamera,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:whats_app_kurs1/models/message_model.dart';
// import 'package:whats_app_kurs1/models/user_model.dart';

// class ChatView extends StatefulWidget {
//   final UserModel userModel;

//   const ChatView({Key? key, required this.userModel}) : super(key: key);

//   @override
//   _ChatViewState createState() => _ChatViewState();
// }

// class _ChatViewState extends State<ChatView> {
//   final TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chat with: ${widget.userModel.email}'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: _firestore
//                   .collection('messages')
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 final messages = snapshot.data!.docs;
//                 return ListView.builder(
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message =
//                         messages[index].data() as Map<String, dynamic>;
//                     final String text = message['text'];
//                     final String? imageUrl = message['imageUrl'];
//                     return ListTile(
//                       title: Text(text),
//                       leading:
//                           imageUrl != null ? Image.network(imageUrl) : null,
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your message',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.attach_file),
//                   onPressed: _pickImage,
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _pickImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = pickedFile;
//     });
//   }

//   Future<String?> _uploadImage() async {
//     if (_imageFile == null) return null;
//     final String fileName =
//         'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final firebase_storage.Reference ref = firebase_storage
//         .FirebaseStorage.instance
//         .ref()
//         .child('images')
//         .child(fileName);
//     final firebase_storage.UploadTask uploadTask =
//         ref.putFile(File(_imageFile!.path));
//     final firebase_storage.TaskSnapshot taskSnapshot =
//         await uploadTask.whenComplete(() => null);
//     return await taskSnapshot.ref.getDownloadURL();
//   }

//   Future<void> _sendMessage() async {
//     final String messageText = _messageController.text.trim();
//     final String? imageUrl = await _uploadImage();

//     if (messageText.isEmpty && imageUrl == null) {
//       return;
//     }

//     // final Map<String, dynamic> messageData = {
//     //   'text': messageText,
//     //   'imageUrl': imageUrl,
//     //   'createdAt': Timestamp.now(),
//     // };
//     final chatModel = MessageModel(
//         message: messageText,
//         time: Timestamp.now(),
//         imageUrl: imageUrl ?? '',
//         senderId: widget.userModel.id);
//     await _firestore.collection('messages').add(chatModel.toMap());

//     _messageController.clear();
//     setState(() {
//       _imageFile = null;
//     });
//   }
// }
