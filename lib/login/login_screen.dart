import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:haja/display/components/animations/loading.dart';
import 'package:haja/login/responder.dart';
import 'package:haja/login/welcome_page.dart';
import 'package:provider/provider.dart';

import 'package:haja/controllers/keys.dart';
import 'package:haja/language/constants.dart';
import 'package:haja/language/language.dart';
import 'package:haja/login/user_state.dart';
import 'package:haja/login/login_data.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? inputError;
  bool loading = false;
  bool get showBackButton => false;
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      secondPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  void showError(String? error) {
    setState(() => inputError = error);
  }

  bool textFieldValidator() {
    var form = _formKey.currentState;
    if (form == null) {
      return true;
    }
    return form.validate();
  }

  String? passwordValidator(value) {
    if (value == null || value.isEmpty) {
      return 'Password is empty';
    }
    return null;
  }

  void onSubmitAnimationCompleted(UserState userstate) => userstate.notify();

  void validateThenStartLoginFlow(UserState userstate, LoginData data) {
    if (!textFieldValidator()) {
      return;
    }

    startLoginFlow(userstate, data);
  }

  void startLoginFlow(UserState userstate, LoginData data) async {
    setState(() => loading = true);

    showError(await loginUser(
      userstate,
      data,
    ));

    loading = false;
    onSubmitAnimationCompleted(userstate);
  }

  void startSignupFlow(UserState userstate, LoginData data) async {
    if (!textFieldValidator()) {
      return;
    }

    setState(() => loading = true);

    showError(await signupUser(
      userstate,
      data,
    ));

    loading = false;
    
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Material(
        child: ChangeNotifierProvider(
          create: (context) => UserState(),
          builder: (context, child) => const WelcomePage(),
        ),
      ),
      fullscreenDialog: true,
    ));

    onSubmitAnimationCompleted(userstate);
  }

  void startForgotFlow(UserState userstate, LoginData data) async {
    if (!textFieldValidator()) {
      return;
    }

    setState(() => loading = true);

    recoverPassword(userstate, data.email);

    loading = false;
    onSubmitAnimationCompleted(userstate);
  }

  Future<String?> loginUser(UserState userstate, LoginData data) async {
    String? validator = passwordValidator(data.password);

    if (validator != null) {
      return validator;
    }

    return Future.delayed(loginTime).then((_) async {
      return await userstate.supply(
        data.email,
        data.password,
      );
    });
  }

  Future<String?> signupUser(UserState userstate, LoginData data) async {
    String? validator = passwordValidator(data.password);

    if (validator != null) {
      return validator;
    }

    return Future.delayed(loginTime).then((_) async {
      return await userstate.signup(
        email: data.email,
        auth: data.password,
      );
    });
  }

  Future<String?> recoverPassword(UserState userstate, String email) {
    return Future.delayed(loginTime).then((_) async {
      return await userstate.recover(email);
    });
  }

  Widget editableText(
    BuildContext context,
    String label,
    TextEditingController controller, {
    bool passwordProtect = false,
  }) =>
      Padding(
        padding: const EdgeInsets.only(
          bottom: Constants.defaultPadding / 2,
        ),
        child: TextFormField(
          controller: controller,
          enableSuggestions: !passwordProtect,
          obscureText: passwordProtect,
          autocorrect: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label cannot be empty';
            }
            return null;
          },
          buildCounter: (
            context, {
            required currentLength,
            required isFocused,
            maxLength,
          }) {
            return Container(
              transform:
                  Matrix4.translationValues(50, -kToolbarHeight / 1.35, 0),
              child: Opacity(
                opacity: .5,
                child: Text(
                  '$currentLength/$maxLength',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
          decoration: InputDecoration(
            hintText: label,
            fillColor: Theme.of(context).canvasColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                Constants.defaultBorderRadiusXLarge * 2,
              ),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.only(
              top: Constants.defaultPadding / 2,
              bottom: Constants.defaultPadding / 2,
              left: Constants.defaultPadding,
              right: Constants.defaultPadding + 50,
            ),
            filled: true,
          ),
          maxLines: 1,
          maxLength: 60,
        ),
      );

  List<Widget> generateTextInputs() => [
        editableText(
          context,
          Language.loginScreenEmail,
          emailController,
        ),
        editableText(
          context,
          Language.loginScreenPassword,
          passwordController,
          passwordProtect: true,
        ),
      ];

  List<Widget> generateHeader() => [
        const SizedBox(
          height: Constants.defaultPadding * 3,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 2 +
              Constants.defaultPadding * 2,
          child: const Text(
            Language.loginScreenIntro,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
      ];

  Future<void> nextScreen(Widget screen) async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Material(
        child: ChangeNotifierProvider(
          create: (context) => UserState(),
          builder: (context, child) => screen,
        ),
      ),
      fullscreenDialog: true,
    ));
  }

  Widget generateButton() => Consumer<UserState>(
        builder: (context, userstate, child) => Column(
          children: [
            ElevatedButton(
              onPressed: () => validateThenStartLoginFlow(
                userstate,
                LoginData(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shadowColor: Theme.of(context).primaryColor,
                elevation: 10,
                minimumSize: const Size.fromHeight(
                  Constants.defaultPadding * 2.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.defaultBorderRadiusRound,
                  ),
                ),
              ),
              child: const Text(
                Language.loginScreenButton,
              ),
            ),
            const SizedBox(
              height: Constants.defaultPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                        null) return;
                    GlobalKeys.rootScaffoldMessengerKey.currentState!
                        .showSnackBar(const SnackBar(
                      content: Text('Sorry, this button doesn\'t work yet'),
                      duration: Duration(seconds: 4),
                    ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Constants.defaultBorderRadiusRound,
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(.1),
                        ),
                      ),
                      padding: const EdgeInsets.only(right: 1),
                      child: Image.asset(
                        Constants.iconAssetFacebook,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Constants.defaultPadding,
                ),
                GestureDetector(
                  onTap: () {
                    if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                        null) return;
                    GlobalKeys.rootScaffoldMessengerKey.currentState!
                        .showSnackBar(const SnackBar(
                      content: Text('Sorry, this button doesn\'t work yet'),
                      duration: Duration(seconds: 4),
                    ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Constants.defaultBorderRadiusRound,
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(.1),
                        ),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: Image.asset(
                        Constants.iconAssetKakaotalk,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: Constants.defaultPadding,
                ),
                GestureDetector(
                  onTap: () {
                    if (GlobalKeys.rootScaffoldMessengerKey.currentState ==
                        null) return;
                    GlobalKeys.rootScaffoldMessengerKey.currentState!
                        .showSnackBar(const SnackBar(
                      content: Text('Sorry, this button doesn\'t work yet'),
                      duration: Duration(seconds: 4),
                    ));
                  },
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Constants.defaultBorderRadiusRound,
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .iconTheme
                              .color!
                              .withOpacity(.1),
                        ),
                      ),
                      padding: const EdgeInsets.all(7),
                      child: SvgPicture.asset(
                        Constants.iconAssetGoogle,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );

  List<Widget> generateAccountHelpers() => [
        const Center(
          child: Text(
            Language.loginScreenForgetHelp,
          ),
        ),
        const SizedBox(
          height: Constants.defaultPadding / 2,
        ),
        GestureDetector(
          onTap: () => nextScreen(const FindForgottenInfo()),
          child: Center(
            child: Text(
              Language.loginScreenFindYourInfo,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: Constants.defaultPadding * 2,
        ),
        GestureDetector(
          onTap: () => nextScreen(const SignupLoginFlow()),
          child: Row(
            children: [
              Expanded(
                child: Container(),
              ),
              const Text(
                Language.loginScreenCreateNewButton,
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 18,
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.defaultPadding,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Constants.defaultPadding,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        showBackButton
                            ? GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(
                                  Icons.arrow_back,
                                ),
                              )
                            : Container(),
                        Expanded(
                          child: Container(),
                        ),
                        Consumer<UserState>(
                          builder: (context, userstate, child) =>
                              GestureDetector(
                            onDoubleTap: () => !kReleaseMode
                                ? startLoginFlow(
                                    userstate,
                                    LoginData(
                                      email: AppDebugLogin.debugUserEmail,
                                      password: AppDebugLogin.debugUserPass,
                                    ),
                                  )
                                : null,
                            child: Image.asset(
                              Constants.logoAsset,
                              width: Constants.defaultPadding * 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...generateHeader(),
                    const SizedBox(
                      height: Constants.defaultPadding * 2,
                    ),
                    ...generateTextInputs(),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: Constants.defaultPadding,
                      ),
                      child: Text(
                        inputError ?? '',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Constants.defaultPadding,
                    ),
                    loading
                        ? const SizedBox(
                            height: Constants.defaultPadding * 5 + 4,
                            child: Loading(),
                          )
                        : generateButton(),
                    const SizedBox(
                      height: Constants.defaultPadding,
                    ),
                    if (!showBackButton) ...generateAccountHelpers(),
                    const SizedBox(
                      height: Constants.defaultPadding * 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class SignupLoginFlow extends LoginScreen {
  const SignupLoginFlow({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _SignupLoginFlowState();
}

class FindForgottenInfo extends LoginScreen {
  const FindForgottenInfo({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _FindForgottenInfoState();
}

class _SignupLoginFlowState extends _LoginScreenState {
  @override
  bool get showBackButton => true;

  @override
  List<Widget> generateHeader() => [
        const SizedBox(
          height: Constants.defaultPadding,
        ),
        const Text(
          Language.signupScreenHeader,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ];

  @override
  Widget generateButton() => Consumer<UserState>(
        builder: (context, userstate, child) => Column(
          children: [
            ElevatedButton(
              onPressed: () => startSignupFlow(
                userstate,
                LoginData(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shadowColor: Theme.of(context).primaryColor,
                elevation: 10,
                minimumSize: const Size.fromHeight(
                  Constants.defaultPadding * 2.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.defaultBorderRadiusRound,
                  ),
                ),
              ),
              child: const Text(
                Language.signupScreenButton,
              ),
            ),
            const SizedBox(
              height: Constants.defaultPadding * 2,
            ),
          ],
        ),
      );

  @override
  List<Widget> generateTextInputs() => [
        editableText(
          context,
          Language.loginScreenEmail,
          emailController,
        ),
        editableText(
          context,
          Language.loginScreenPassword,
          passwordController,
          passwordProtect: true,
        ),
        editableText(
          context,
          Language.loginScreenSecondPassword,
          secondPasswordController,
          passwordProtect: true,
        ),
      ];
}

class _FindForgottenInfoState extends _LoginScreenState {
  @override
  bool get showBackButton => true;

  @override
  List<Widget> generateHeader() => [
        const SizedBox(
          height: Constants.defaultPadding,
        ),
        const Text(
          Language.forgotScreenHeader,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ];

  @override
  Widget generateButton() => Consumer<UserState>(
        builder: (context, userstate, child) => Column(
          children: [
            ElevatedButton(
              onPressed: () => startForgotFlow(
                userstate,
                LoginData(
                  email: emailController.text,
                  password: passwordController.text,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                shadowColor: Theme.of(context).primaryColor,
                elevation: 10,
                minimumSize: const Size.fromHeight(
                  Constants.defaultPadding * 2.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Constants.defaultBorderRadiusRound,
                  ),
                ),
              ),
              child: const Text(
                Language.forgotScreenButton,
              ),
            ),
            const SizedBox(
              height: Constants.defaultPadding * 2,
            ),
          ],
        ),
      );

  @override
  List<Widget> generateTextInputs() => [
        editableText(
          context,
          Language.loginScreenEmail,
          emailController,
        ),
      ];
}
