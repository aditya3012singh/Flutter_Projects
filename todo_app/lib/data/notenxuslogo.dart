import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NoteNexusLogo extends StatefulWidget {
  final double iconSize;
  final double textSize;

  const NoteNexusLogo({super.key, this.iconSize = 40, this.textSize = 24});

  @override
  State<NoteNexusLogo> createState() => _NoteNexusLogoState();
}

class _NoteNexusLogoState extends State<NoteNexusLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Gradient Icon Container
            Container(
              height: widget.iconSize,
              width: widget.iconSize,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.purple, Colors.orange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),

            // Pulse dot (amber)
            Positioned(
              top: -4,
              right: -4,
              child: ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.2).animate(
                  CurvedAnimation(
                    parent: _pulseController,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 10),

        // Gradient Text
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              Color(0xFF1E293B),
              Color(0xFF3B82F6),
            ], // slate-800 to blue-600
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds),
          child: Text(
            'NoteNexus',
            style: TextStyle(
              fontSize: widget.textSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
