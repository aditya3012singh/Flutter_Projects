import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/colors.dart';
import 'package:todo_app/views/services/auth_helper.dart';
import 'package:todo_app/views/services/api.dart';
import 'package:todo_app/views/models/user_model.dart';
import 'package:todo_app/data/notenxuslogo.dart';
import 'package:todo_app/views/pages/signup_page.dart';
import 'package:todo_app/views/widget_tree.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(
    text: "aditya.24428cseai@gmail.com",
  );
  final TextEditingController passwordController = TextEditingController(
    text: "123456",
  );

  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);

    try {
      final response = await ApiService.signin(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      final token = response['jwt'];
      final userMap = response['user'];

      if (token != null && userMap != null) {
        final prefs = await SharedPreferences.getInstance();

        // Save token using AuthHelper
        await AuthHelper.setToken(token);

        // Save user data
        final user = User.fromJson(userMap);
        await prefs.setString('userData', jsonEncode(user.toJson()));

        Fluttertoast.showToast(
          msg: 'Login successful!',
          backgroundColor: Colors.green,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WidgetTree()),
        );
      } else {
        throw Exception("Invalid login response");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Login failed: ${e.toString()}',
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const NoteNexusLogo(),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 250, 250),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome Back to the ",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    "Nexus",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: LunaColors.aquaBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
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
              const SizedBox(height: 24),
              isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LunaColors.aquaBlue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupPage()),
                ),
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: LunaColors.aquaBlue, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
