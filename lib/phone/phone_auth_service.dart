// import 'package:firebase_auth/firebase_auth.dart';

// class PhoneAuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String> verifyPhoneNumber(
//       String phoneNumber,
//       Function(String verificationId, String forceResendToken)
//           verificationCompleted) async {
//     try {
//       final phoneAuthCredential = await _auth.verifyPhoneNumber(
//           phoneNumber: phoneNumber,
//           verificationCompleted: verificationCompleted,
//           verificationFailed: (FirebaseAuthException e) {
//             print(e.message); // Handle verification failures gracefully
//           },
//           codeSent: (String verificationId, int forceResendToken) {
//             verificationCompleted(verificationId, forceResendToken.toString());
//           },
//           timeout:
//               const Duration(seconds: 60)); // Set a timeout for verification
//       return phoneAuthCredential.verificationId!;
//     } catch (e) {
//       print(e.toString()); // Handle unexpected errors
//       return "";
//     }
//   }

//   Future<UserCredential?> signInWithPhoneAuthCredential(
//       String verificationId, String otp) async {
//     try {
//       final phoneAuthCredential =
//           PhoneAuthCredential(verificationId: verificationId, smsCode: otp);
//       final userCredential =
//           await _auth.signInWithCredential(phoneAuthCredential);
//       return userCredential;
//     } catch (e) {
//       print(e.toString()); // Handle sign-in errors
//       return null;
//     }
//   }
// }
