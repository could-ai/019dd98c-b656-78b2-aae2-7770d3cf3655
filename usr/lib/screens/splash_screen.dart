import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background for fire effect to pop
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 3D visual approximation (spinning cubes or icons)
            Icon(
              Icons.layers,
              size: 100,
              color: Colors.blueAccent.withOpacity(0.8),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms, color: Colors.cyan)
                .shake(hz: 2, curve: Curves.easeInOutCubic)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2000.ms, curve: Curves.easeInOut)
                .then()
                .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8), duration: 2000.ms, curve: Curves.easeInOut),
            const SizedBox(height: 40),
            // Fire effect approximation for text
            Text(
              'DATA FLOW',
              style: GoogleFonts.bungee(
                fontSize: 50,
                color: Colors.orangeAccent,
                shadows: [
                  Shadow(color: Colors.redAccent.withOpacity(0.8), blurRadius: 10, offset: const Offset(0, 0)),
                  Shadow(color: Colors.deepOrange.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 0)),
                  Shadow(color: Colors.yellowAccent.withOpacity(0.8), blurRadius: 30, offset: const Offset(0, 0)),
                ],
              ),
            )
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .moveY(begin: -5, end: 5, duration: 1000.ms)
                .tint(color: Colors.red, duration: 500.ms)
                .then()
                .tint(color: Colors.yellow, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
