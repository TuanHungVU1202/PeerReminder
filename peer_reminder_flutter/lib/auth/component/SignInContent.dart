import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:peer_reminder_flutter/auth/service/AuthServiceImpl.dart';
import 'package:peer_reminder_flutter/auth/service/IAuthService.dart';

// Local imports
import 'package:peer_reminder_flutter/common/UIConstant.dart';
import '../../common/UIUtil.dart';
import '../../home/CupertinoHomePage.dart';
import '../SwitchPageAnimation.dart';
import 'BottomText.dart';
import 'TopText.dart';

enum Screens {
  createAccount,
  welcomeBack,
}

class SignInContent extends StatefulWidget {
  const SignInContent({Key? key}) : super(key: key);

  @override
  State<SignInContent> createState() => _SignInContentState();
}

class _SignInContentState extends State<SignInContent>
    with TickerProviderStateMixin {
  late final List<Widget> createAccountContent;
  late final List<Widget> loginContent;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late final IAuthService auth;

  final String _kSignUp = "Sign Up";
  final String _kSignIn = "Sign In";

  // -------------------------------------------------------------------------
  // UI Components
  Widget _createInputField(
      String hint, IconData iconData, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hint,
              prefixIcon: Icon(iconData),
            ),
          ),
        ),
      ),
    );
  }

  // FIXME: add onPressed here
  Widget _createSignInSignUpButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 135, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          if (title == _kSignIn) {
            _signIn();
          } else {
            _signUp();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: UIConstant.kSecondaryColor,
          shape: const StadiumBorder(),
          elevation: 8,
          shadowColor: Colors.black87,
        ),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _createOrDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 8),
      child: Row(
        children: [
          Flexible(
            child: Container(
              height: 1,
              color: UIConstant.kPrimaryColor,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'or',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 1,
              color: UIConstant.kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // Loading assets for Single Sign On
  // TODO: Add actual single sign on (SSO) APIs
  Widget _createSingleSignOnOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/facebook.png'),
          const SizedBox(width: 24),
          Image.asset('assets/images/google.png'),
        ],
      ),
    );
  }

  Widget createForgotPasswordButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 110),
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: UIConstant.kSecondaryColor,
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------------------
  // Callbacks
  void _signIn() {
    // FIXME: Query credentials from DB. Handle this carefully
    //   if (auth.fetchCredentials(_emailController.text, _passwordController.text)) {
    //     Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(builder: (context) => const CupertinoHomePage()),
    //           (Route<dynamic> route) => false,
    //     );
    // }

    // For now always push to new page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CupertinoHomePage()),
      (Route<dynamic> route) => false,
    );
  }

  void _signUp() {
    // FIXME: Create new account to DB
    // For now always push to new page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CupertinoHomePage()),
      (Route<dynamic> route) => false,
    );
  }

  // -------------------------------------------------------------------------
  @override
  void initState() {
    createAccountContent = [
      _createInputField('Name', Ionicons.person_outline, _nameController),
      _createInputField('Email', Ionicons.mail_outline, _emailController),
      _createInputField(
          'Password', Ionicons.lock_closed_outline, _passwordController),
      _createSignInSignUpButton(_kSignUp),
      _createOrDivider(),
      _createSingleSignOnOptions(),
    ];

    loginContent = [
      _createInputField('Email', Ionicons.mail_outline, _emailController),
      _createInputField(
          'Password', Ionicons.lock_closed_outline, _passwordController),
      _createSignInSignUpButton(_kSignIn),
      createForgotPasswordButton(),
    ];

    SwitchPageAnimation.initialize(
      vsync: this,
      createAccountItems: createAccountContent.length,
      loginItems: loginContent.length,
    );

    for (var i = 0; i < createAccountContent.length; i++) {
      createAccountContent[i] = UIUtil.wrapWithAnimatedBuilder(
        animation: SwitchPageAnimation.createAccountAnimations[i],
        child: createAccountContent[i],
      );
    }

    for (var i = 0; i < loginContent.length; i++) {
      loginContent[i] = UIUtil.wrapWithAnimatedBuilder(
        animation: SwitchPageAnimation.loginAnimations[i],
        child: loginContent[i],
      );
    }

    auth = AuthServiceImpl();

    super.initState();
  }

  @override
  void dispose() {
    SwitchPageAnimation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 136,
          left: 24,
          child: TopText(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: createAccountContent,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: loginContent,
              ),
            ],
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: BottomText(),
          ),
        ),
      ],
    );
  }
}
