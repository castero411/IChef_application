import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:i_chef_application/view/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
              // SettingsTile(
              //   iconData: Icons.notifications_none_rounded,
              //   tileText: 'Notifications',
              // ),
              SettingsTile(
                iconData: Icons.logout,
                tileText: 'Log out',
                onTap: () async {
                  setState(() async {
                    print("delete");
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                      // ignore: use_build_context_synchronously
                      context,
                      'login', // Replace with your route
                      (Route<dynamic> route) =>
                          false, // Remove all previous routes
                    );
                  });
                },
              ),
              SettingsTile(
                iconData: Icons.delete_outline_rounded,
                tileText: 'Delete account',
                onTap: () async {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text('Confirm Deletion'),
                          content: Text(
                            'Are you sure you want to delete your account? This cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                  );

                  if (shouldDelete == true) {
                    try {
                      final user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        // Delete user's Firestore document
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .delete();

                        // Try to delete the Firebase account
                        await user.delete();

                        // Navigate to login
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          'login',
                          (route) => false,
                        );
                      }
                    } catch (e) {
                      print('Error deleting account: $e');

                      if (e is FirebaseAuthException &&
                          e.code == 'requires-recent-login') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Please log in again to delete your account.',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to delete account. Please try again.',
                            ),
                          ),
                        );
                      }
                    }
                  }
                },
              ),
              Gap(20),
              Text('Personal', style: black20),
              SettingsTile(
                iconData: Icons.tune_rounded,
                tileText: 'Pereferences',
                onTap: () {
                  Navigator.pushNamed(context, 'setup_account');
                },
              ),
              Gap(20),
              // Text('Feedback', style: black20),
              // SettingsTile(
              //   iconData: Icons.report_gmailerrorred_rounded,
              //   tileText: 'Report a bug',
              // ),
              // SettingsTile(
              //   iconData: Icons.send_outlined,
              //   tileText: 'send feedback',
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  SettingsTile({
    super.key,
    required this.iconData,
    required this.tileText,
    this.onTap = defaultFun,
  });
  final IconData iconData;
  final String tileText;
  final Function() onTap;

  static void defaultFun() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
