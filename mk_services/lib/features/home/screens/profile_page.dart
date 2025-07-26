import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data — replace with actual user state/provider
    const user = {
      "name": "Prashant Kumar",
      "email": "prashant@gmail.com",
      "phone": "9379877219",
      "address": "k-55, Gomti Nagar",
    };

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Profile picture and info
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  user['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email']!,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  user['phone']!,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  user['address']!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action tiles
          _ProfileTile(
            icon: Icons.edit,
            label: 'Update Profile',
            onTap: () => context.push('/user/update-profile'),
          ),
          _ProfileTile(
            icon: Icons.location_on_outlined,
            label: 'Manage Address',
            onTap: () => context.push('/user/manage-address'),
          ),
          _ProfileTile(
            icon: Icons.phone_in_talk_outlined,
            label: 'Contact Us',
            onTap: () => context.push('/user/contact'),
          ),
          _ProfileTile(
            icon: Icons.currency_rupee_outlined,
            label: 'Spare Parts Price List',
            onTap: () => context.push('/user/spare-parts'),
          ),
          const SizedBox(height: 24),

          // Logout button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ElevatedButton(
              onPressed: () {
                // TODO: Clear local storage/token and redirect
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade900),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
