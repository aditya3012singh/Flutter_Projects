import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class CreateAccountProviderScreen extends ConsumerStatefulWidget {
  const CreateAccountProviderScreen({super.key});

  @override
  ConsumerState<CreateAccountProviderScreen> createState() =>
      _CreateAccountProviderScreenState();
}

class _CreateAccountProviderScreenState
    extends ConsumerState<CreateAccountProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isLoading = false;

  void _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await ref
        .read(authControllerProvider)
        .requestOtp(_emailController.text.trim());

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pushNamed(
        context,
        '/verify-otp',
        arguments: {
          'email': _emailController.text.trim(),
          'name': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'password': _passwordController.text.trim(),
          'isProvider': true, // Always true here
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset('assets/images/mk.png', height: 80),
              const SizedBox(height: 20),

              const Text(
                "CREATE PROVIDER ACCOUNT",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: "Full Name",
                      validator: Validators.nameValidator,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email",
                      validator: Validators.emailValidator,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      keyboardType: TextInputType.phone,
                      validator: Validators.phoneValidator,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      obscureText: true,
                      validator: Validators.passwordValidator,
                    ),
                    const SizedBox(height: 24),

                    if (isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _requestOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Continue as Provider',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: const Text("Back to regular signup"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
