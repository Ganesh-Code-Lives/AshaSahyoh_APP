import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  // Singleton pattern to ensure verificationId is persisted across screens if needed
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? get verificationId => _verificationId;

  // Send OTP
  Future<void> sendOtp({
    required String phoneNumber,
    required Function() onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Android auto-resolution
          await _auth.signInWithCredential(credential);
          // If auto-sign in works, we might want to notify the UI
          // For now, we'll let the listener in main.dart or standard flow handle auth state changes if we had one.
          // But effectively, if this happens, the user is signed in.
        },
        verificationFailed: (FirebaseAuthException e) {
          onError("Phone Auth Error: ${e.code} - ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent();
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(seconds: 30),
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw FirebaseAuthException(code: 'dummy', message: 'Verification ID is null. Request OTP again.');
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw 'Invalid OTP. Please check and try again.';
      }
      throw e.message ?? 'Verification failed';
    } catch (e) {
      throw 'An error occurred. Please try again.';
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
    _verificationId = null;
  }
  
  // Get User
  User? get currentUser => _auth.currentUser;
}
