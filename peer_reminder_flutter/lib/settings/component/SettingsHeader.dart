import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:peer_reminder_flutter/common/UIConstant.dart';

/// The first big header item in settings that aggregates the user's profile
/// type data.
class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 81.0,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
              right: 13.0,
            ),
            child: CircleAvatar(
              backgroundColor: UIConstant.kItemPressedColor,
              radius: 30.0,
              child: const Padding(
                padding: EdgeInsets.only(
                  bottom: 4.0,
                ),
                child: Text(
                  'FR',
                  style: TextStyle(
                    fontSize: 23.0,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Padding(padding: EdgeInsets.only(top: 16.0)),
                  Text(
                    'Flutter Rocks',
                    style: TextStyle(
                      fontSize: 21.0,
                      letterSpacing: -0.52,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 6.0)),
                  Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 13.0,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              CupertinoIcons.forward,
              color: UIConstant.kMediumGrayColor,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
