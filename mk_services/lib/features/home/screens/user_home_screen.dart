import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> carouselImages = [
      'assets/images/image1.png',
      'assets/images/image2.png',
      'assets/images/image3.png',
      'assets/images/image4.png',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Hi Prashant Kumar,',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Welcome to MK Service Station',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Carousel Banner
          CarouselSlider(
            options: CarouselOptions(
              height: 120,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
            ),
            items: carouselImages.map((imgPath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // 2x2 Grid of Main Actions
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _HomeServiceTile(
                icon: Icons.build_circle_outlined,
                label: "Request Installation",
                onTap: () => context.push('/booking/domestic'),
              ),
              _HomeServiceTile(
                icon: Icons.settings,
                label: "Service Request",
                onTap: () => context.push('/booking/industrial'),
              ),
              _HomeServiceTile(
                icon: Icons.inventory_2_outlined,
                label: "My Product",
                onTap: () => context.push('/user/my-product'),
              ),
              _HomeServiceTile(
                icon: Icons.history,
                label: "Service And History",
                onTap: () => context.push('/user/service-history'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Partner Logos
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [Image.asset('assets/images/image1.png')],
          ),
        ],
      ),
    );
  }
}

class _HomeServiceTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HomeServiceTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.blue.shade900),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
