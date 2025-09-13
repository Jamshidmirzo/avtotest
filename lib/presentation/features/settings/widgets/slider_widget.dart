import 'package:flutter/material.dart';

class SliderWidget extends StatelessWidget {
  const SliderWidget({
    super.key,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.value,
  });

  final int min;
  final int max;
  final int value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4.0,
        activeTrackColor: Color(0xff006FFD),
        inactiveTrackColor: Color(0xffEEEEEE),
        thumbColor: Colors.white,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 16.0,
          elevation: 6.0,
        ),
        overlayColor: Colors.white.withOpacity(0.0),
      ),
      child: Slider(
        value: value.toDouble(),
        onChanged: onChanged,
        min: min.toDouble(),
        max: max.toDouble(),
      ),
    );
  }
}
