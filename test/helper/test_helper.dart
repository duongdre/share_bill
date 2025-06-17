// Create test/test_setup.dart

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class TestSetup {
  static void setupFirebaseMocks() {
    // Mock Firebase Auth
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'Auth#registerIdTokenListener':
            return null;
          case 'Auth#registerAuthStateListener':
            return null;
          case 'Auth#signInWithEmailAndPassword':
          // Simulate login based on credentials
            final Map<dynamic, dynamic> arguments = methodCall.arguments;
            final String email = arguments['email'];
            final String password = arguments['password'];

            // Simulate different scenarios
            if (email == 'test@example.com' && password == 'validpassword123') {
              throw PlatformException(
                code: 'user-not-found',
                message: 'No user found for that email.',
              );
            } else if (email == 'admin@test.com' && password == 'adminpass123') {
              return {
                'user': {
                  'uid': 'test-uid-123',
                  'email': email,
                }
              };
            } else {
              throw PlatformException(
                code: 'wrong-password',
                message: 'Wrong password provided.',
              );
            }
          case 'Auth#createUserWithEmailAndPassword':
            final Map<dynamic, dynamic> arguments = methodCall.arguments;
            final String email = arguments['email'];

            if (email == 'existing@test.com') {
              throw PlatformException(
                code: 'email-already-in-use',
                message: 'The account already exists for that email.',
              );
            }

            return {
              'user': {
                'uid': 'new-user-uid-123',
                'email': email,
              }
            };
          case 'Auth#signOut':
            return null;
          default:
            return null;
        }
      },
    );

    // Mock Firebase Database
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_database'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'DatabaseReference#set':
            return null;
          case 'DatabaseReference#update':
            return null;
          case 'DatabaseReference#get':
            return {
              'value': null,
              'exists': false,
            };
          default:
            return null;
        }
      },
    );

    // Mock Firebase Storage
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_storage'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'Task#startPutFile':
            return 'mock-download-url';
          case 'Reference#getDownloadURL':
            return 'https://mock-firebase-storage.com/image.jpg';
          default:
            return null;
        }
      },
    );

    // Mock Shared Preferences
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getAll':
            return <String, dynamic>{
              'onboarding_completed': true,
              'selected_language': 'en',
            };
          case 'setBool':
          case 'setString':
          case 'setInt':
          case 'setDouble':
            return true;
          case 'remove':
            return true;
          case 'clear':
            return true;
          default:
            return null;
        }
      },
    );

    // Mock Image Picker
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/image_picker'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'pickImage':
            return 'mock-image-path.jpg';
          default:
            return null;
        }
      },
    );
  }

  static void tearDownMocks() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_auth'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_database'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_storage'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
      null,
    );

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/image_picker'),
      null,
    );
  }
}