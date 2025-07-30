import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../core/utils/validators.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _otpSent = false;
  bool _verifying = false;
  String _selectedRole = 'USER';
  String _otp = '';
  int _cooldown = 0;
  Timer? _timer;

  void _startCooldown() {
    _cooldown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldown == 0) {
        timer.cancel();
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final success = await ref
        .read(authControllerProvider)
        .requestOtp(_emailController.text.trim());
    setState(() {
      _isLoading = false;
      _otpSent = success;
    });

    if (success) {
      Fluttertoast.showToast(
        msg: "OTP sent to ${_emailController.text}",
        backgroundColor: Colors.green,
      );
      _startCooldown();
    } else {
      Fluttertoast.showToast(
        msg: "Failed to send OTP",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> _verifyAndSignup() async {
    if (_otp.length != 6) {
      Fluttertoast.showToast(
        msg: "Enter the full 6-digit OTP",
        backgroundColor: Colors.red,
      );
      return;
    }

    setState(() => _verifying = true);
    final success = await ref
        .read(authControllerProvider)
        .verifyOtpAndSignup(
          email: _emailController.text.trim(),
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text.trim(),
          otp: _otp,
          role: _selectedRole,
          context: context,
        );
    setState(() => _verifying = false);

    if (success) {
      Fluttertoast.showToast(
        msg: "Signup successful! Redirecting...",
        backgroundColor: Colors.green,
      );
      Future.delayed(const Duration(seconds: 1), () {
        context.go('/user/main'); // Redirect after 1s
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _timer?.cancel();
    super.dispose();
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
              Image.asset('assets/images/mk.png', height: 80),
              const SizedBox(height: 20),
              const Text(
                "CREATE ACCOUNT",
                style: TextStyle(
                  fontSize: 28,
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
                      label: "Name",
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
                      label: "Phone",
                      validator: Validators.phoneValidator,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      validator: Validators.passwordValidator,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // Role Selector
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: "Select Role",
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'USER', child: Text("User")),
                        DropdownMenuItem(
                          value: 'TECHNICIAN',
                          child: Text("Technician"),
                        ),
                        DropdownMenuItem(value: 'ADMIN', child: Text("Admin")),
                      ],
                      onChanged: (val) => setState(() => _selectedRole = val!),
                    ),
                    const SizedBox(height: 24),

                    if (!_otpSent)
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _sendOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade800,
                                minimumSize: const Size.fromHeight(48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Send OTP',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                    else
                      Column(
                        children: [
                          const Text(
                            "Enter OTP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),

                          // Pinput OTP
                          Pinput(
                            length: 6,
                            onChanged: (val) => _otp = val,
                            defaultPinTheme: PinTheme(
                              height: 56,
                              width: 48,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Resend OTP with cooldown
                          TextButton(
                            onPressed: _cooldown == 0 ? _sendOtp : null,
                            child: Text(
                              _cooldown > 0
                                  ? "Resend OTP in $_cooldown s"
                                  : "Resend OTP",
                              style: TextStyle(
                                color: _cooldown == 0
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),
                          _verifying
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  onPressed: _verifyAndSignup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Verify & Sign Up',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                        ],
                      ),

                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            "Login",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
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
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
