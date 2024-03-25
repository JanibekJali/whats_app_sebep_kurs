import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  Future<void> _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phoneNumberController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification if SMS code is detected
          await _auth.signInWithCredential(credential);
          // Navigate to next screen or do any necessary action
        },
        verificationFailed: (FirebaseAuthException e) {
          log('Verification failed message: ${e.message}');
          log('Verification failed phoneNumber: ${e.phoneNumber}');
          log('Verification failed code: ${e.code}');
          log('Verification failed stackTrace: ${e.stackTrace}');
          log('Verification failed tenantId: ${e.tenantId}');
          log('Verification failed hashCode: ${e.hashCode}');
          log('Verification failed credential: ${e.credential}');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      log('Error verifyPhoneNumber: $e');
    }
  }

  Future<void> _verifyOTP() async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text,
      );
      await _auth.signInWithCredential(credential);
      // Navigate to next screen or do any necessary action
    } catch (e) {
      log('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyPhoneNumber,
              child: Text('Verify Phone Number'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
