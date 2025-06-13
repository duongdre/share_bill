import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Get current user ID
  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Get current user email
  static String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  // Check if user is logged in
  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  // Get user-specific database reference
  static DatabaseReference getUserDataRef() {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }
    return _database.ref('users/$userId');
  }

  // Get user-specific reference for a collection
  static DatabaseReference getUserCollectionRef(String collection) {
    return getUserDataRef().child(collection);
  }

  // Initialize user data structure when first time login
  static Future<void> initializeUserData() async {
    final userId = getCurrentUserId();
    if (userId == null) return;

    final userRef = _database.ref('users/$userId');
    final snapshot = await userRef.once();

    // If user data doesn't exist, create initial structure
    if (!snapshot.snapshot.exists) {
      await userRef.set({
        'bills': {},
        'groups': {},
        'persons': {},
        'createdAt': ServerValue.timestamp,
        'email': getCurrentUserEmail(),
      });
    }
  }

  // Sign out and clear local data
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out successfully');
    } catch (e) {
      print('❌ Error signing out: $e');
      throw e;
    }
  }
}