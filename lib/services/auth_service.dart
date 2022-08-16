import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:photogallery1/services/auth_credentials.dart';

// 1
enum AuthFlowStatus { login, signUp, verification, session }

// 2
class AuthState {
  final AuthFlowStatus authFlowStatus;

  AuthState({required this.authFlowStatus});
}

// 3
class AuthService {
  // 4
  final authStateController = StreamController<AuthState>();
  late AuthCredentials _credentials;

  // 5
  void showSignUp() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.signUp);
    authStateController.add(state);
  }

  // 6
  void showLogin() {
    final state = AuthState(authFlowStatus: AuthFlowStatus.login);
    authStateController.add(state);
  }

  void loginWithCredentials(AuthCredentials credentials) async {
    try {
      // log('username: ${credentials.username}'
      //     'password: ${credentials.password}');
      //
      // log('Comienzo inicio de sesión');

      final result = await Amplify.Auth.signIn(
          username: credentials.username, password: credentials.password);

      // log('Fin de inicio de sesión');

      if (result.isSignedIn) {
        // log('Inicio la sesión');
        final state = AuthState(authFlowStatus: AuthFlowStatus.session);
        authStateController.add(state);
      } else {
        // log('No se pudo iniciar sesión.');
        print('User could not be signed in');
      }
    } on AuthException catch (authException) {
      // log('No se pudo iniciar sesión - ${authException.message}');
      print('Could not login - ${authException.message}');
    }
  }

// 2
  void signUpWithCredentials(SignUpCredentials credentials) async {
    try {
      // Map<CognitoUserAttributeKey, String> userAttributes = const {
      //   "email": credentials.email
      // };

      var userAttributes = <CognitoUserAttributeKey, String>{
        CognitoUserAttributeKey.email: credentials.email,
        // CognitoUserAttributeKey.phoneNumber: '+18885551234',
        // CognitoUserAttributeKey.custom('my_attribute'): 'my_value',
      };

      // log( 'email: ${credentials.email}' );

      final result = await Amplify.Auth.signUp(
        username: credentials.username,
        password: credentials.password,
        options: CognitoSignUpOptions(userAttributes: userAttributes),
      );

      // log( 'username: ${credentials.username}\n'
      //     'password: ${credentials.password}\n'
      //     'Signup complete: ${result.isSignUpComplete}'
      // );

      /*if( result.isSignUpComplete ) {
        loginWithCredentials( credentials );
      } else {*/
      this._credentials = credentials;
      final state = AuthState(authFlowStatus: AuthFlowStatus.verification);
      authStateController.add(state);
      // log( 'Me muevo a la pantalla de verificación.' );
      //}

    } on AuthException catch (authException) {
      // log('Error al registrar el nuevo usuario \n'
      //     '${authException.message}\n'
      //     '${authException.recoverySuggestion}'
      //     '${authException.underlyingException}\n');
      print('Failed to sign up - ${authException.message}');
    }
  }

// 1
  void verifyCode(String verificationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: _credentials.username,
        confirmationCode: verificationCode,
      );
      if (result.isSignUpComplete) {
        loginWithCredentials(_credentials);
      } else {}
    } on AuthException catch (authException) {
      print('Could not verify code - ${authException.message}');
      // log('No se pudo verificar el código \n'
      //     '${authException.message}\n'
      //     '${authException.recoverySuggestion}'
      //     '${authException.underlyingException}\n');
    }
  }

  void logOut() async {
    try {
      // 1
      await Amplify.Auth.signOut();

      // 2
      showLogin();
    } on AuthException catch (authException) {
      print('Could not log out - ${authException.message}');
    }
  }

  void checkAuthStatus() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();

      final state = AuthState(authFlowStatus: AuthFlowStatus.session);
      authStateController.add(state);
    } catch (_) {
      final state = AuthState(authFlowStatus: AuthFlowStatus.login);
      authStateController.add(state);
    }
  }
}
