import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/views/pages/welcome_page.dart';

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
        // Step 1: Generate OTP
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

        setState(() {
          isOtpSent = true; // Show OTP field
        });

        showMessage("OTP sent to your email.");
      } else {
        if (otpCode.isEmpty) {
          showMessage("Please enter the OTP.");
          return;
        }

        // Step 2: Verify OTP
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

        // Step 3: Signup
        final signupResponse = await http.post(
          Uri.parse(
            'https://autonomous-kiet-hub.onrender.com/api/v1/users/signup',
          ),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'name': name,
            'password': password,
            'role': "STUDENT", // Default role
          }),
        );

        if (signupResponse.statusCode == 201) {
          final data = jsonDecode(signupResponse.body);
          print("Signup Success: ${data['token']}");

          // Show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'OTP verified successfully. Redirecting to Home Page...',
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ),
          );

          // Wait for the snackbar to show before navigating
          await Future.delayed(const Duration(seconds: 2));

          // Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WelcomePage()),
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
      appBar: AppBar(title: const Text("Signup")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Create an Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                // OTP TextField appears only if OTP is sent
                if (isOtpSent)
                  TextField(
                    controller: otpController,
                    decoration: const InputDecoration(
                      labelText: 'Enter OTP',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isLoading ? null : handleSignupFlow,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isOtpSent ? 'Verify & Signup' : 'Send OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
