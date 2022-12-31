import 'package:flutter/material.dart';

// Local imports
import 'package:peer_reminder_flutter/common/UIUtil.dart';
import '../SwitchPageAnimation.dart';
import 'package:peer_reminder_flutter/common/UIConstant.dart';
import 'SignInContent.dart';

class BottomText extends StatefulWidget {
  const BottomText({Key? key}) : super(key: key);

  @override
  State<BottomText> createState() => _BottomTextState();
}

class _BottomTextState extends State<BottomText> {
  @override
  void initState() {
    SwitchPageAnimation.bottomTextAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIUtil.wrapWithAnimatedBuilder(
      animation: SwitchPageAnimation.bottomTextAnimation,
      child: GestureDetector(
        onTap: () {
          if (!SwitchPageAnimation.isPlaying) {
            SwitchPageAnimation.currentScreen == Screens.createAccount
                ? SwitchPageAnimation.forward()
                : SwitchPageAnimation.reverse();

            SwitchPageAnimation.currentScreen =
                Screens.values[1 - SwitchPageAnimation.currentScreen.index];
          }
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Montserrat',
              ),
              children: [
                TextSpan(
                  text:
                      SwitchPageAnimation.currentScreen == Screens.createAccount
                          ? 'Already have an account? '
                          : 'Don\'t have an account? ',
                  style: TextStyle(
                    color: UIConstant.kPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text:
                      SwitchPageAnimation.currentScreen == Screens.createAccount
                          ? 'Log In'
                          : 'Sign Up',
                  style: TextStyle(
                    color: UIConstant.kSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
