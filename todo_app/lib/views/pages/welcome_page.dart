import 'package:flutter/material.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/pages/login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fix overflow by wrapping logo in a FittedBox
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: NoteNexusLogo(iconSize: 60, textSize: 40),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),

              const FittedBox(
                child: Text(
                  "Your Campus Companion for Smarter Notes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14.0),
                    backgroundColor: const Color.fromARGB(255, 139, 58, 233),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    "Explore Nexus",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
