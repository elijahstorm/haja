import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'user_state.dart';

import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/login/responder.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(UserState userstate, LoginData data) {
    return Future.delayed(loginTime).then((_) async {
      return await userstate.supply(data.name, data.password);
    });
  }

  Future<String?> _signupUser(UserState userstate, SignupData data) {
    return Future.delayed(loginTime).then((_) async {
      return await userstate.signup(
        email: data.name,
        auth: data.password,
      );
    });
  }

  Future<String?> _recoverPassword(UserState userstate, String name) {
    return Future.delayed(loginTime).then((_) async {
      return await userstate.recover(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserState>(
      builder: (context, userstate, child) {
        return FlutterLogin(
          title: Language.appName,
          userType: LoginUserType.email,
          logo: Constants.logoAsset,
          logoTag: '${Language.appName}Logo',
          titleTag: '${Language.appName}Title',
          termsOfService: [
            TermOfService(
              id: 'general_tos',
              mandatory: false,
              text: 'Terms of Service',
              linkUrl: 'tos',
              initialValue: false,
              validationErrorMessage:
                  'You must agree to use our Terms of Service',
            ),
          ],
          savedEmail:
              UserState.loadMockData ? AppDebugLogin.debugUserEmail : '',
          savedPassword:
              UserState.loadMockData ? AppDebugLogin.debugUserPass : '',
          loginAfterSignUp: true,
          loginProviders: <LoginProvider>[
            LoginProvider(
              button: Buttons.Google,
              icon: FontAwesomeIcons.google,
              label: 'Google',
              callback: () async {
                return await userstate.provider(
                  'google',
                );
              },
            ),
            LoginProvider(
              button: Buttons.Facebook,
              icon: FontAwesomeIcons.facebookF,
              label: 'Facebook',
              callback: () async {
                return await userstate.provider(
                  'facebook',
                );
              },
            ),
            if (!kReleaseMode)
              LoginProvider(
                icon: FontAwesomeIcons.linkedinIn,
                label: 'Demo Login',
                callback: () async {
                  return await userstate.supply(
                    AppDebugLogin.debugUserEmail,
                    AppDebugLogin.debugUserPass,
                  );
                },
              ),
          ],
          messages: LoginMessages(
            passwordHint: 'Password',
            confirmPasswordHint: 'Confirm Password',
            loginButton: 'LOGIN',
            signupButton: 'REGISTER',
            forgotPasswordButton: 'Forgot Password?',
            recoverPasswordButton: 'SEND EMAIL',
            goBackButton: 'BACK',
            confirmPasswordError: 'Your password do not match',
            recoverPasswordIntro: 'Tell us your email',
            recoverPasswordDescription:
                'Then we can help you set a new, secure password',
            recoverPasswordSuccess: 'Email Sent',
          ),
          theme: LoginTheme(
            primaryColor: Theme.of(context).canvasColor,
            accentColor: Theme.of(context).colorScheme.secondary,
            errorColor: Theme.of(context).errorColor,
            primaryColorAsInputLabel: false,
            footerBottomPadding: Constants.defaultPadding * 3,
            titleStyle: TextStyle(
              color: Theme.of(context).iconTheme.color,
            ),
            bodyStyle: const TextStyle(
              fontStyle: FontStyle.italic,
            ),
            textFieldStyle: TextStyle(
              color: Theme.of(context).canvasColor,
            ),
            cardTheme: CardTheme(
              color: Theme.of(context).primaryColor,
              elevation: 5,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
            ),
            inputTheme: InputDecorationTheme(
              filled: true,
              contentPadding: EdgeInsets.zero,
              labelStyle: TextStyle(
                fontSize: 12,
                color: Theme.of(context).canvasColor,
              ),
              prefixStyle: TextStyle(
                color: Theme.of(context).canvasColor,
              ),
            ),
            buttonStyle: TextStyle(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).canvasColor,
            ),
            buttonTheme: LoginButtonTheme(
              splashColor: Theme.of(context).colorScheme.secondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              highlightColor: Theme.of(context).colorScheme.secondary,
              elevation: 9.0,
              highlightElevation: 6.0,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          passwordValidator: (value) {
            if (value == null) {
              return 'Password is empty';
            }
            if (value.isEmpty) {
              return 'Password is empty';
            }
            return null;
          },
          onLogin: (loginData) {
            return _loginUser(userstate, loginData);
          },
          onSignup: (loginData) {
            return _signupUser(userstate, loginData);
          },
          onSubmitAnimationCompleted: () {
            userstate.notify();
          },
          onRecoverPassword: (name) {
            return _recoverPassword(userstate, name);
          },
          showDebugButtons: false,
        );
      },
    );
  }
}
