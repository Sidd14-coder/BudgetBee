import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../globals.dart'; // 👈 IMPORTANT

class GoogleAuthService {
  // Force Google to always show account chooser
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    forceCodeForRefreshToken: true,
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<User?> signInWithGoogle() async {
    try {
      // 🔥 Sign out first to always show account chooser
      await _googleSignIn.signOut();

      // 🔥 Open Google email list
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      // User cancelled login
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      // ===== SAVE USER DATA TO GLOBALS =====
      if (user != null) {
        loggedInUserName =
            user.displayName?.trim().isNotEmpty == true
                ? user.displayName!
                : 'User';

        loggedInUserEmail = user.email ?? '';
      }

      return user;
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  // Optional helper: sign out completely
  static Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    // Clear globals on logout
    loggedInUserName = 'User';
    loggedInUserEmail = '';
  }
}
