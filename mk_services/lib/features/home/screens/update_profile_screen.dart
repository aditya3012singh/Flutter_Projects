import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/providers/auth_provider.dart';

class UpdateProfileScreen extends ConsumerWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);

    final user = userState.value;

    // Pre-fill fields with current user data
    final nameController = TextEditingController(text: user?.name ?? '');
    final phoneController = TextEditingController(text: user?.phone ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');
    final passwordController = TextEditingController(); // Optional new password

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Update Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Phone Field
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email Field (not editable but visible)
            TextField(
              controller: emailController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Email (cannot change)',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Password Field (optional)
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password (optional)',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final success = await authNotifier.updateUserProfile(
                    name: nameController.text,
                    phone: phoneController.text,
                    location: null, // Location handled separately
                    password: passwordController.text.isEmpty
                        ? null
                        : passwordController.text,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update profile')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
