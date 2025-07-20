import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/views/pages/welcome_page.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/widget_tree.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool isLoading = false;
  bool isOtpSent = false;

  Future<void> handleSignupFlow() async {
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final password = passwordController.text.trim();
    final otpCode = otpController.text.trim();

    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      showMessage("All fields are required.");
      return;
    }

    setState(() => isLoading = true);

    try {
      if (!isOtpSent) {
        final otpResponse = await http.post(
          Uri.parse(
            'https://autonomous-kiet-hub.onrender.com/api/v1/users/generate-otp',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        );

        if (otpResponse.statusCode != 200) {
          throw Exception('Failed to send OTP: ${otpResponse.body}');
        }

        setState(() => isOtpSent = true);
        showMessage("OTP sent to your email.");
      } else {
        if (otpCode.isEmpty) {
          showMessage("Please enter the OTP.");
          return;
        }

        final verifyResponse = await http.post(
          Uri.parse(
            'https://autonomous-kiet-hub.onrender.com/api/v1/users/verify-otp',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'code': otpCode}),
        );

        if (verifyResponse.statusCode != 200) {
          throw Exception('Invalid or expired OTP');
        }

        final signupResponse = await http.post(
          Uri.parse(
            'https://autonomous-kiet-hub.onrender.com/api/v1/users/signup',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'name': name,
            'password': password,
            'role': "STUDENT",
          }),
        );

        if (signupResponse.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'OTP verified successfully. Redirecting to Home Page...',
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          await Future.delayed(const Duration(seconds: 2));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WidgetTree()),
          );
        } else {
          final err = jsonDecode(signupResponse.body);
          throw Exception(err['message'] ?? 'Signup failed');
        }
      }
    } catch (e) {
      showMessage(e.toString());
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      appBar: AppBar(
        title: const NoteNexusLogo(),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "Let’s Build Your ",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Nexus",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: LunaColors.aquaBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isOtpSent)
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter OTP',
                    prefixIcon: Icon(Icons.verified_user_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleSignupFlow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: LunaColors.aquaBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isOtpSent ? 'Verify & Sign Up' : 'Send OTP',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
