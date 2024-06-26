import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'package:peer_reminder_flutter/common/UIConstant.dart';

enum SettingsItemType {
  // Just on and off.
  toggle,
  // Navigates to another page of detailed settings.
  modal,
}

typedef PressOperationCallback = Future<void> Function();

class SettingsItem extends StatefulWidget {
  const SettingsItem({
    super.key,
    required this.type,
    required this.label,
    this.subtitle,
    this.iconAssetLabel,
    this.value,
    this.hasDetails = false,
    this.onPress,
  })  : assert(label != null),
        assert(type != null);

  final String label;
  final String? subtitle;
  final String? iconAssetLabel;
  final SettingsItemType type;
  final String? value;
  final bool hasDetails;
  final PressOperationCallback? onPress;

  @override
  State<StatefulWidget> createState() => SettingsItemState();
}

class SettingsItemState extends State<SettingsItem> {
  bool switchValue = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> rowChildren = [];
    if (widget.iconAssetLabel != null) {
      rowChildren.add(
        Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            bottom: 2.0,
          ),
          child: Image.asset(
            'assets/setting_icons/${widget.iconAssetLabel}.png',
            // package: 'settings_icons',
            height: 29.0,
          ),
        ),
      );
    }

    Widget titleSection;
    if (widget.subtitle == null) {
      titleSection = Padding(
        padding: const EdgeInsets.only(top: 1.5),
        child: Text(widget.label),
      );
    } else {
      titleSection = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(top: 8.5)),
          Text(widget.label),
          const Padding(padding: EdgeInsets.only(top: 4.0)),
          Text(
            widget.subtitle!,
            style: const TextStyle(
              fontSize: 12.0,
              letterSpacing: -0.2,
            ),
          )
        ],
      );
    }

    rowChildren.add(
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
          ),
          child: titleSection,
        ),
      ),
    );

    switch (widget.type) {
      case SettingsItemType.toggle:
        rowChildren.add(
          Padding(
            padding: const EdgeInsets.only(right: 11.0),
            child: CupertinoSwitch(
              value: switchValue,
              onChanged: (bool value) => setState(() => switchValue = value),
            ),
          ),
        );
        break;
      case SettingsItemType.modal:
        final List<Widget> rightRowChildren = [];
        if (widget.value != null) {
          rightRowChildren.add(
            Padding(
              padding: const EdgeInsets.only(
                top: 1.5,
                right: 2.25,
              ),
              child: Text(
                widget.value!,
                style: const TextStyle(color: CupertinoColors.inactiveGray),
              ),
            ),
          );
        }

        if (widget.hasDetails) {
          rightRowChildren.add(
            Padding(
              padding: const EdgeInsets.only(
                top: 0.5,
                left: 2.25,
              ),
              child: Icon(
                CupertinoIcons.forward,
                color: UIConstant.kMediumGrayColor,
                size: 21.0,
              ),
            ),
          );
        }

        rightRowChildren.add(const Padding(
          padding: EdgeInsets.only(right: 8.5),
        ));

        rowChildren.add(
          Row(
            children: rightRowChildren,
          ),
        );
        break;
    }

    // FIXME: On press push to another page
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: pressed ? UIConstant.kItemPressedColor : const Color(0x00FFFFFF),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.onPress != null) {
            setState(() {
              pressed = true;
            });
            widget.onPress!().whenComplete(() {
              Future.delayed(
                const Duration(milliseconds: 150),
                () {
                  setState(() {
                    pressed = false;
                  });
                },
              );
            });
          }
        },
        child: SizedBox(
          height: widget.subtitle == null ? 44.0 : 57.0,
          child: Row(
            children: rowChildren,
          ),
        ),
      ),
    );
  }
}
