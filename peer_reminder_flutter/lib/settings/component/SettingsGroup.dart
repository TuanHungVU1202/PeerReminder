import 'package:flutter/cupertino.dart';

import 'package:peer_reminder_flutter/common/UIConstant.dart';
import 'SettingsItem.dart';

class SettingsGroup extends StatelessWidget {
  const SettingsGroup(
    this.items, {
    super.key,
    this.header,
    this.footer,
  }) : assert(items != null);

  final List<Widget> items;

  late Widget header;
  late Widget footer;

  @override
  Widget build(BuildContext context) {
    List<Widget> dividedItems = items;
    if (items.length > 1) {
      dividedItems = dividedItems.map<Widget>((Widget item) {
        if (dividedItems.last == item) {
          return item;
        } else {
          final leftPadding = item is SettingsItem
              ? item.iconAssetLabel == null
                  ? 15.0
                  : 58.0
              : 0.0;
          // Add inner dividers.
          return Stack(
            children: <Widget>[
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: leftPadding,
                child: Container(
                  color: UIConstant.kBorderColor,
                  height: 0.3,
                ),
              ),
              item,
            ],
          );
        }
      }).toList();
    }

    final List<Widget> columnChildren = [];

    if (header != null) {
      columnChildren.add(DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.inactiveGray,
          fontSize: 13.5,
          letterSpacing: -0.5,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            bottom: 6.0,
          ),
          child: header,
        ),
      ));
    }

    columnChildren.add(
      Container(
        decoration: BoxDecoration(
          color: CupertinoColors.white,
          border: Border(
            top: BorderSide(
              color: UIConstant.kBorderColor,
              width: 0.0,
            ),
            bottom: BorderSide(
              color: UIConstant.kBorderColor,
              width: 0.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: dividedItems,
        ),
      ),
    );

    if (footer != null) {
      columnChildren.add(DefaultTextStyle(
        style: TextStyle(
          color: UIConstant.kGroupSubtitle,
          fontSize: 13.0,
          letterSpacing: -0.08,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
            top: 7.5,
          ),
          child: footer,
        ),
      ));
    }

    return Padding(
      padding: EdgeInsets.only(
        top: header == null ? 35.0 : 22.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnChildren,
      ),
    );
  }
}
