import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class MistakeHistoryWidget extends StatefulWidget {
  const MistakeHistoryWidget({
    super.key,
    required this.model,
    required this.onTap,
  });

  final MistakeQuestionEntity model;
  final VoidCallback onTap;

  @override
  State<MistakeHistoryWidget> createState() => _MistakeHistoryWidgetState();
}

class _MistakeHistoryWidgetState extends State<MistakeHistoryWidget> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetMistakeHistoryEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(widget.model.date),
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.themeExtension.whiteToGondola,
              border: Border.all(
                width: 1,
                color: AppColors.paleGray,
              ),
            ),
            child: Row(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.existingErrors,
                      style: context.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "${widget.model.attempts.length} ${Strings.taXato}",
                      style: context.textTheme.bodyMedium!
                          .copyWith(color: AppColors.red, fontWeight: FontWeight.w400, fontSize: 14),
                    ),
                  ],
                ),
                Spacer(),
                SvgPicture.asset(
                  AppIcons.arrowRight,
                  width: 24,
                  height: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
