import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  //SignUp
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Error during sign up: $e');
      rethrow;
    }
  }

  //Sign In
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      print('Error during sign in: $e');
      rethrow;
    }
  }

  //logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  //Auth With Phone Number

  //Sent Otp To Phone Number Functions
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
  }) async {
    await _auth.verifyPhoneNumber(
      //with Country Code
      phoneNumber: phoneNumber,

      //Auto Verification Complete only For Android
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      //if error
      verificationFailed: onVerificationFailed,

      //if code Sent
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  //Users Otp Cheak Functions
  Future<User?> verifyOtp({
    required String otp,
    required String verificationId,
  }) async {
    try {
      //Create Credential
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      //SignIn
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      print('Error during OTP verification: $e');
      rethrow;
    }
  }
}
