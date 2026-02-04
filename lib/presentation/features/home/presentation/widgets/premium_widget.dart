import 'dart:async';
import 'dart:math';

import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

// ... твои импорты

class PremiumDiceAnimation extends StatefulWidget {
  const PremiumDiceAnimation({super.key});

  @override
  _PremiumDiceAnimationState createState() => _PremiumDiceAnimationState();
}

class _PremiumDiceAnimationState extends State<PremiumDiceAnimation> {
  bool _showIcon = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Увеличим интервал до 1.5 - 2 секунд, чтобы текст успевали прочитать
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        setState(() {
          _showIcon = !_showIcon;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(
          milliseconds: 500), // Оптимальная скорость для "броска"
      switchInCurve:
          Curves.easeOutBack, // Легкий отскок в конце для эффекта камня
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (Widget child, Animation<double> animation) {
        // Проверяем, является ли текущий child тем, который ВХОДИТ
        final isInWidget = child.key == ValueKey(_showIcon);

        // Настройка движения:
        // Входящий: начинает снизу (1.5) и идет в центр (0)
        // Уходящий: начинает в центре (0) и уходит вверх (-1.5)
        var offsetAnimation = Tween<Offset>(
          begin: isInWidget ? const Offset(0, 1.5) : const Offset(0, -1.5),
          end: Offset.zero,
        ).animate(animation);

        return ClipRect(
          child: SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
      layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      child: _showIcon
          ? Container(
              width: 100.w,
              alignment: Alignment.center,
              key: const ValueKey(false),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF4EA71),
                    Color(0xFFCCB853),
                    Color(0xFFF1E1B8),
                    Color(0xFFB89F45),
                    Color(0xFFF4EA71),
                    Color(0xFFB2881F),
                  ],
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                "PREMIUM",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            )
          : Container(
              alignment: Alignment.center,
              width: 100.w,
              key: const ValueKey(false),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFF4EA71),
                    Color(0xFFCCB853),
                    Color(0xFFF1E1B8),
                    Color(0xFFB89F45),
                    Color(0xFFF4EA71),
                    Color(0xFFB2881F),
                  ],
                ),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                'SOTIB OLING',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: Colors.black,
                ),
              ),
            ),
    );
  }
}
