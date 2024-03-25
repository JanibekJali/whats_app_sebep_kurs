import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_sebep_kurs/constants/colors/app_colors.dart';
import 'package:whats_app_sebep_kurs/models/user_model.dart';
import 'package:whats_app_sebep_kurs/view/chats/chat_view.dart';
import 'package:whats_app_sebep_kurs/view/sign_up/sign_up_view.dart';

class SignINView extends StatelessWidget {
  SignINView({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      final UserCredential credential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final UserModel userModel = UserModel(
        id: credential.user!.uid,
        userName: '',
        email: emailController.text,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatView(userModel: userModel),
        ),
      );
      log('login credentiial--> $credential');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sign In',
            style: TextStyle(fontSize: 25, color: AppColors.red),
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
              const Text('Don\'t  have an account?'),
              InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignUpView()));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          ),
          ElevatedButton(
              onPressed: () {
                login(context);
              },
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }
}
