// Create this file: integration_test/test_driver.dart

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver();

class AppTestConfig {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    // Setup all necessary mocks
    await _setupFirebaseMocks();
    await _setupOtherMocks();

    _isInitialized = true;
  }

  static Future<void> _setupFirebaseMocks() async {
    // Firebase Core
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_core'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'Firebase#initializeCore':
            return {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'fake-api-key',
                'appId': 'fake-app-id',
                'messagingSenderId': 'fake-sender-id',
                'projectId': 'fake-project-id',
              },
              'pluginConstants': {},
            };
          case 'Firebase#initializeApp':
            return {
              'name': '[DEFAULT]',
              'options': {
                'apiKey': 'fake-api-key',
                'appId': 'fake-app-id',
                'messagingSenderId': 'fake-sender-id',
                'projectId': 'fake-project-id',
              },
            };
          default:
            return null;
        }
      },
    );

    // Firebase Auth
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_auth'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'Auth#registerIdTokenListener':
          case 'Auth#registerAuthStateListener':
            return null;
          case 'Auth#signInWithEmailAndPassword':
            await Future.delayed(const Duration(milliseconds: 500));
            throw PlatformException(
              code: 'user-not-found',
              message: 'No user found for that email.',
            );
          case 'Auth#createUserWithEmailAndPassword':
            await Future.delayed(const Duration(milliseconds: 500));
            throw PlatformException(
              code: 'email-already-in-use',
              message: 'The account already exists for that email.',
            );
          case 'Auth#signOut':
            return null;
          case 'Auth#currentUser':
            return null;
          default:
            return null;
        }
      },
    );

    // Firebase Database
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_database'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'DatabaseReference#set':
          case 'DatabaseReference#update':
          case 'DatabaseReference#remove':
            await Future.delayed(const Duration(milliseconds: 100));
            return null;
          case 'Query#get':
            return {
              'snapshot': {
                'key': null,
                'value': null,
              },
            };
          default:
            return null;
        }
      },
    );

    // Firebase Storage
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/firebase_storage'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'Task#startPutFile':
            await Future.delayed(const Duration(milliseconds: 300));
            return 'https://fake-storage-url.com/image.jpg';
          case 'Reference#getDownloadURL':
            return 'https://fake-storage-url.com/image.jpg';
          default:
            return null;
        }
      },
    );
  }

  static Future<void> _setupOtherMocks() async {
    // Shared Preferences
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/shared_preferences'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getAll':
            return <String, dynamic>{
              'onboarding_completed': false,
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

    // Image Picker
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/image_picker'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'pickImage':
            await Future.delayed(const Duration(milliseconds: 500));
            return '/fake/path/to/image.jpg';
          case 'pickVideo':
            return '/fake/path/to/video.mp4';
          default:
            return null;
        }
      },
    );

    // Package Info
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/package_info'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getAll':
            return {
              'appName': 'Share Bill',
              'packageName': 'com.example.share_bill',
              'version': '1.0.0',
              'buildNumber': '1',
            };
          default:
            return null;
        }
      },
    );

    // Path Provider
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getTemporaryDirectory':
            return '/tmp';
          case 'getApplicationDocumentsDirectory':
            return '/documents';
          case 'getExternalStorageDirectory':
            return '/storage';
          default:
            return null;
        }
      },
    );
  }

  static Future<void> cleanup() async {
    // Clean up all mock handlers
    final channels = [
      'plugins.flutter.io/firebase_core',
      'plugins.flutter.io/firebase_auth',
      'plugins.flutter.io/firebase_database',
      'plugins.flutter.io/firebase_storage',
      'plugins.flutter.io/shared_preferences',
      'plugins.flutter.io/image_picker',
      'plugins.flutter.io/package_info',
      'plugins.flutter.io/path_provider',
    ];

    for (final channel in channels) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(MethodChannel(channel), null);
    }

    _isInitialized = false;
  }

  // Helper methods for tests
  static Future<void> waitForAnimation([Duration duration = const Duration(milliseconds: 500)]) async {
    await Future.delayed(duration);
  }

  static bool widgetExists(Finder finder) {
    try {
      return finder.evaluate().isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<void> enterTextSafely(WidgetTester tester, Finder finder, String text) async {
    try {
      await tester.enterText(finder, text);
      await tester.pump();
    } catch (e) {
      print('Failed to enter text: $e');
    }
  }

  static Future<void> tapSafely(WidgetTester tester, Finder finder) async {
    try {
      if (finder.evaluate().isNotEmpty) {
        await tester.tap(finder);
        await tester.pump();
      }
    } catch (e) {
      print('Failed to tap: $e');
    }
  }
}