import 'package:flutter/cupertino.dart';

import 'package:peer_reminder_flutter/common/UIConstant.dart';

import 'component/SettingsGroup.dart';
import 'component/SettingsHeader.dart';
import 'component/SettingsItem.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Container(
        color: UIConstant.kBackgroundGray,
        child: CustomScrollView(
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Settings'),
            ),
            SliverSafeArea(
              top: false,
              // This is just a big list of all the items in the settings.
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    const SettingsGroup(<Widget>[
                      SettingsHeader(),
                    ]),
                    const SettingsGroup(<Widget>[
                      SettingsItem(
                        label: 'Airplane Mode',
                        iconAssetLabel: 'airplane',
                        type: SettingsItemType.toggle,
                      ),
                      SettingsItem(
                        label: 'Wi-Fi',
                        iconAssetLabel: 'wifi',
                        type: SettingsItemType.modal,
                        value: 'Airport Free',
                        hasDetails: true,
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
