import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mk_services/core/services/api_service.dart';
import 'package:mk_services/core/models/user_model.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final ApiService _apiService = ApiService();
  String? userName;
  bool isLoading = true;

  final List<String> carouselImages = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
  ];

  final List<Map<String, dynamic>> services = [
    {
      'icon': Icons.build_circle_outlined,
      'label': "Request Services",
      'route': '/booking/domestic',
    },
    {
      'icon': Icons.history,
      'label': "Service And History",
      'route': '/user/service-history',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final UserModel? profile = await _apiService.getProfile();
      if (profile == null) {
        // Token expired or not found → redirect to login
        if (mounted) context.go('/login');
        return;
      }
      setState(() {
        userName = profile.name ?? 'User';
        isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        // On error, force logout
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hi ${userName ?? "User"},',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Welcome to MK Service Station',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Carousel
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 140,
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

                    // Responsive Grid
                    LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.1,
                              ),
                          itemCount: services.length,
                          itemBuilder: (context, index) {
                            final item = services[index];
                            return _HomeServiceTile(
                              icon: item['icon'] as IconData,
                              label: item['label'] as String,
                              onTap: () =>
                                  context.push(item['route'] as String),
                            );
                          },
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Full-width bottom image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/image1.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ],
                ),
              ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue.shade900),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
