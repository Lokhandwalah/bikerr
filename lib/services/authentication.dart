import 'package:firebase_auth/firebase_auth.dart';
import 'package:bikerr/models/user.dart' as MyUser;

class AuthService {
  static final auth = FirebaseAuth.instance;
  static final exceptionHandler = AuthExceptionHandler();
  static User get currentUser => auth.currentUser;

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      final firebaseUser = (await auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      await MyUser.CurrentUser.user.setData(email);
      return {'success': true, 'user': firebaseUser};
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'msg': AuthExceptionHandler.getExceptionMessage(
            exceptionHandler.getAuthStatus(e))
      };
    }
  }

  Future<Map<String, dynamic>> signUp(MyUser.User user) async {
    try {
      final firebaseUser = (await auth.createUserWithEmailAndPassword(
              email: user.email, password: user.password))
          .user;
      firebaseUser.sendEmailVerification();
      return {'success': true, 'user': firebaseUser};
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'msg': AuthExceptionHandler.getExceptionMessage(
            exceptionHandler.getAuthStatus(e))
      };
    }
  }

  Future<Map<String, dynamic>> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return {'success': true};
    } catch (e) {
      print(e.toString());
      return {
        'success': false,
        'msg': AuthExceptionHandler.getExceptionMessage(
            exceptionHandler.getAuthStatus(e))
      };
    }
  }

  Future<void> signout() async => await auth.signOut();
}

enum AuthResultStatus {
  successful,
  emailAlreadyExists,
  credentialAlreadyExists,
  wrongPassword,
  invalidEmail,
  invalidCredential,
  invalidOTP,
  invalidVerificationID,
  userNotFound,
  userDisabled,
  operationNotAllowed,
  tooManyRequests,
  undefined,
}

class AuthExceptionHandler {
  AuthResultStatus getAuthStatus(e) {
    print(e.toString());
    AuthResultStatus status;
    try {
      print(e.code);
      switch (e.code) {
        case "invalid-email":
          status = AuthResultStatus.invalidEmail;
          break;
        case "invalid-credential":
          status = AuthResultStatus.invalidCredential;
          break;
        case "invalid-verification-code":
          status = AuthResultStatus.invalidOTP;
          break;
        case "invalid-verificaction-id":
          status = AuthResultStatus.invalidVerificationID;
          break;
        case "wrong-password":
          status = AuthResultStatus.wrongPassword;
          break;
        case "user-not-found":
          status = AuthResultStatus.userNotFound;
          break;
        case "user-disabled":
          status = AuthResultStatus.userDisabled;
          break;
        case "too-many-requests":
          status = AuthResultStatus.tooManyRequests;
          break;
        case "operation-not-allowed":
          status = AuthResultStatus.operationNotAllowed;
          break;
        case "email-already-in-use":
          status = AuthResultStatus.emailAlreadyExists;
          break;
        case "account-exists-with-different-credential":
          status = AuthResultStatus.credentialAlreadyExists;
          break;
        default:
          status = AuthResultStatus.undefined;
      }
    } catch (_) {
      status = AuthResultStatus.undefined;
    }
    return status;
  }

  static String getExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage =
            "Your email address appears to be malformed or badly formatted.";
        break;
      case AuthResultStatus.invalidCredential:
        errorMessage = "There appears to be a problem with your credentials.";
        break;
      case AuthResultStatus.invalidOTP:
        errorMessage = "This verification code is invalid.";
        break;
      case AuthResultStatus.invalidVerificationID:
        errorMessage = "This verifiaction code appears to be wrong.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage = "Your password is wrong.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please try again with another email address.";
        break;
      case AuthResultStatus.credentialAlreadyExists:
        errorMessage =
            "The email has already been registered with some other account. Please try again with another email address.";
        break;
      default:
        errorMessage = "Something went Wrong. try again later";
    }
    return errorMessage;
  }
}
