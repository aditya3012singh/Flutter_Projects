import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/notifiers.dart';

import 'package:flutter_application_1/views/pages/welcome_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: AssetImage('assets/images/image.png'),
            ),
            ListTile(
              title: Text("Logout"),
              onTap: () {
                selectedPageNotifier.value = 0; // Reset to HomePage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomePage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
