import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_bill/screens/home/UI/home_screen.dart';
import 'package:share_bill/screens/login/UI/login_screen.dart';
import 'package:share_bill/services/firebase_services/user_service.dart';
import '../../utilities/utils/string_utils.dart';

class AuthService {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Initialize user data structure in database
      await UserService.initializeUserData();

      return StringUtils.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Initialize user data structure if it doesn't exist
      await UserService.initializeUserData();

      return StringUtils.success;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  static void logoutApp(BuildContext context) async {
    await UserService.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const LoginScreen(),
      ),
    );
  }

  static void submitOtp(BuildContext context, String otp) {
    signInWithPhoneNumber(context, verId, otp);
  }

  static Future<void> signInWithPhoneNumber(BuildContext context, String verificationId, String smsCode) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      print(userCredential.user!.phoneNumber);
      print("Login successful");

      // Initialize user data structure
      await UserService.initializeUserData();

      // TODO: Navigate to home page
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomeScreen();
      }));
    } catch (e) {
      print('Error signing in with phone number: $e');
    }
  }
}