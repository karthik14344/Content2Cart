import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '857032774109-qug1al6et8hldefnij6jm7fncmnl6ti5.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  // Initialize persistence
  Future<void> initializeAuth() async {
    await _auth.setPersistence(Persistence.LOCAL);
  }

  // Add getter for current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // First check if we have a current user in persistence
      if (_auth.currentUser != null) {
        try {
          // Try to refresh the token
          await _auth.currentUser!.reload();
          final token = await _auth.currentUser!.getIdToken(true);
          if (token != null) {
            // If we successfully got a token, the user is still valid
            // Just return null since we're already signed in
            return null;
          }
        } catch (e) {
          // Token refresh failed, continue with new sign in
          print('Token refresh failed: $e');
        }
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      // Create/update user document only after successful authentication
      if (userCredential.user != null) {
        await _createUserDocument(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      print('Error in signInWithGoogle: $e');
      rethrow;
    }
  }

  Future<void> _createUserDocument(User user) async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Use set with merge to update existing documents without overwriting
      await userDoc.set({
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error creating user document: $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Helper method to get auth token
  Future<String?> getIdToken() async {
    try {
      return await currentUser?.getIdToken(true); // Force refresh token
    } catch (e) {
      print('Error getting ID token: $e');
      return null;
    }
  }
}
