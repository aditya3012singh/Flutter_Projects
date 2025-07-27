import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_DashboardTile> tiles = [
      _DashboardTile(
        title: 'New RO Service Entry',
        icon: Icons.add_circle_outline,
        color: Colors.blueAccent,
        route: '/provider/new-entry',
      ),
      _DashboardTile(
        title: 'Due Service List',
        icon: Icons.notifications_active,
        color: Colors.orange,
        route: '/provider/due-services',
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/images/mk.png', height: 32),
            const SizedBox(width: 8),
            const Text('Provider Dashboard'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: tiles.map((tile) => _buildTile(context, tile)).toList(),
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, _DashboardTile tile) {
    return InkWell(
      onTap: () => context.push(tile.route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 5,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tile.icon, size: 42, color: tile.color),
              const SizedBox(height: 12),
              Text(
                tile.title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: tile.color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardTile {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _DashboardTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.route,
  });
}
