import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/view/text_styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings', style: secondarytitle25)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(10),
              Text('General', style: black20),
              SettingsTile(
                iconData: Icons.person_outline_rounded,
                tileText: 'Account',
              ),
              SettingsTile(
                iconData: Icons.notifications_none_rounded,
                tileText: 'Notifications',
              ),
              SettingsTile(iconData: Icons.logout, tileText: 'Log out'),
              SettingsTile(
                iconData: Icons.delete_outline_rounded,
                tileText: 'Delete account',
              ),
              Gap(20),
              Text('Personal', style: black20),
              SettingsTile(
                iconData: Icons.tune_rounded,
                tileText: 'Pereferences',
              ),
              Gap(20),
              Text('Feedback', style: black20),
              SettingsTile(
                iconData: Icons.report_gmailerrorred_rounded,
                tileText: 'Report a bug',
              ),
              SettingsTile(
                iconData: Icons.send_outlined,
                tileText: 'send feedback',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.iconData,
    required this.tileText,
  });
  final IconData iconData;
  final String tileText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [Icon(iconData), Gap(20), Text(tileText)]),

            Icon(Icons.navigate_next),
          ],
        ),
      ),
    );
  }
}
