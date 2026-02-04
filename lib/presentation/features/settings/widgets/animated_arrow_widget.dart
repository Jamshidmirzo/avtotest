import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BlinkingArrowInCircle extends StatefulWidget {
  const BlinkingArrowInCircle({super.key});

  @override
  State<BlinkingArrowInCircle> createState() => _BlinkingArrowInCircleState();
}

class _BlinkingArrowInCircleState extends State<BlinkingArrowInCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              final scale = 1 + (_controller.value * 0.4);
              final opacity = 1 - _controller.value;

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              );
            },
          ),

          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),

          SvgPicture.asset(
            AppIcons.arrowRight,
            width: 24,
            height: 24,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
