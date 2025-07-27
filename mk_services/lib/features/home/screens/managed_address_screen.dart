import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mk_services/providers/auth_provider.dart';

class ManageAddressScreen extends ConsumerWidget {
  const ManageAddressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final user = authState.value;

    final addressController = TextEditingController(text: user?.location ?? '');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Manage Address',
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

            // Address Field
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final success = await authNotifier.updateUserProfile(
                    name: null,
                    phone: null,
                    location: addressController.text.trim(),
                    password: null,
                  );

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Address updated successfully'),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to update address')),
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
                  'Save Address',
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
