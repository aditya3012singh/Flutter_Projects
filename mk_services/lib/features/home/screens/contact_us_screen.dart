import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  void _launchMap() async {
    const String googleMapUrl = 'https://maps.app.goo.gl/PhtrXWqGrPbLJ2os8';
    if (await canLaunchUrl(Uri.parse(googleMapUrl))) {
      await launchUrl(Uri.parse(googleMapUrl));
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IconTextRow(icon: Icons.phone, text: '+91 9129020211'),
            const SizedBox(height: 16),
            const IconTextRow(
              icon: Icons.email,
              text: 'mkenterprises6088@gmail.com',
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _launchMap,
              child: const IconTextRow(
                icon: Icons.location_on,
                text:
                    'SHOP address : 1336, AURANGABAD JAGIR, BIJNORE ROAD, LUCKNOW -226002',
                isLink: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLink;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue.shade900),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isLink ? Colors.blue : Colors.black87,
              decoration: isLink ? TextDecoration.underline : null,
            ),
          ),
        ),
      ],
    );
  }
}
