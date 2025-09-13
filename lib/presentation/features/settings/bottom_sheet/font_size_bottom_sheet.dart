import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/data/datasource/storage/storage.dart';
import 'package:avtotest/data/datasource/storage/storage_keys.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/settings/widgets/slider_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FontSizeBottomSheet extends StatefulWidget {
  const FontSizeBottomSheet({
    super.key,
  });

  @override
  State<FontSizeBottomSheet> createState() => _FontSizeBottomSheetState();
}

class _FontSizeBottomSheetState extends State<FontSizeBottomSheet> {
  int questionFontSize = 16;
  int answerFontSize = 15;

  @override
  initState() {
    super.initState();
    questionFontSize =
        StorageRepository.getInt(StorageKeys.questionFontSize, defValue: 17);
    answerFontSize =
        StorageRepository.getInt(StorageKeys.answerFontSize, defValue: 16);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: "",
      hasDivider: false,
      hasTitleHeader: true,
      hasClose: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
              .copyWith(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.questionFontSize,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text("${questionFontSize.toInt()}px",
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
        SliderWidget(
          min: 17,
          max: 24,
          onChanged: (double value) {
            setState(() {
              questionFontSize = value.toInt();
            });
          },
          value: questionFontSize,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
              .copyWith(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.answerFontSize,
                style: context.textTheme.headlineSmall!.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text("${answerFontSize.toInt()}px",
                  style: context.textTheme.headlineSmall!.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  )),
            ],
          ),
        ),
        SliderWidget(
          min: 16,
          max: 20,
          onChanged: (double value) {
            setState(() {
              answerFontSize = value.toInt();
            });
          },
          value: answerFontSize,
        ),
        WButton(
          text: Strings.save,
          color: Color(0xff006FFD),
          onTap: () {
            context.read<HomeBloc>().add(
                ChangeAnswerFontSize(answerFontSize: answerFontSize.toInt()));
            context.read<HomeBloc>().add(ChangeQuestionFontSize(
                questionFontSize: questionFontSize.toInt()));
            Navigator.pop(context);
          },
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            top: 16,
          ),
        ),
      ],
    );
  }
}
