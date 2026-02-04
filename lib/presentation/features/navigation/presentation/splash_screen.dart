import 'package:avtotest/core/assets/constants/app_images.dart';
import 'package:avtotest/presentation/features/navigation/presentation/navigation_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay a bit before starting the animation
    // Future.delayed(const Duration(milliseconds: 500), () {
    //   setState(() {
    //     _scale = 1.0;
    //   });
    // });
    _goToNextScreen();
  }

  void _goToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 400));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const NavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset(
              AppImages.appIcon,
              width: size.width * 0.5,
              height: size.width * 0.5,
            ),
          ),
          // Positioned(
          //   bottom: size.height * 0.1,
          //   child: CupertinoActivityIndicator(
          //     color: theme.colorScheme.secondary,
          //     radius: 16,
          //   ),
          // ),
        ],
      ),
    );
  }
}
