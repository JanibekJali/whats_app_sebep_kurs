import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_sebep_kurs/constants/colors/app_colors.dart';
import 'package:whats_app_sebep_kurs/firebase/firebase_collections.dart';
import 'package:whats_app_sebep_kurs/models/user_model.dart';
import 'package:whats_app_sebep_kurs/view/chats/chat_view.dart';
import 'package:whats_app_sebep_kurs/view/sign_in/sign_in.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> signUp() async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      log('user Credential--> $userCredential');
      addUser(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        log('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        log('The account already exists for that email.');
      }
    } catch (kata) {
      throw (kata);
    }
  }

  addUser(UserCredential userCredential) async {
    final UserModel userModel = UserModel(
      id: userCredential.user!.uid,
      userName: userNameController.text,
      email: emailController.text,
    );
    FirebaseCollections.userCollection
        .doc(userCredential.user!.uid)
        .set(userModel.toFirebase())
        .then((value) {
      log("User Added");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatView(
            userModel: userModel,
          ),
        ),
      );
    }).catchError((error) => log("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sign Up',
            style: TextStyle(fontSize: 25, color: AppColors.red),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: userNameController,
              // onChanged: (value) {
              //   userName = value;
              //   log('user name : $userName');
              // },
              // controller: userName ,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Enter User Name";
              //   }
              //   return null;
              // },
              style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
              decoration: InputDecoration(
                labelText: "Enter User Name",
                labelStyle: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: emailController,
              // onChanged: (value) {
              //   email = value;
              //   log('email : $email');
              // },
              // controller: _username,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Enter User Name";
              //   }
              //   return null;
              // },
              style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
              decoration: InputDecoration(
                labelText: "Enter your email",
                labelStyle: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: passwordController,
              // onChanged: (value) {
              //   password = value;
              //   log('password : $password');
              // },
              // controller: _username,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return "Enter User Name";
              //   }
              //   return null;
              // },
              style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.black),
              decoration: InputDecoration(
                labelText: "Enter your password",
                labelStyle: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Already have an account?'),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignINView()));
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
          ElevatedButton(
              onPressed: () {
                signUp();
              },
              child: Text(
                'Sign up',
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
