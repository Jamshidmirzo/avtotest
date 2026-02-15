import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VideoEducationScreen extends StatelessWidget {
  const VideoEducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        actions: [
          SvgPicture.asset(AppIcons.refresh),
          SizedBox(
            width: 16,
          )
        ],
        title: context.tr('all_tickets'),
        hasBackButton: true,
      ),
      body: ListView.separated(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          itemBuilder: (context, index) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 68,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFFCCCCCC),
                  ),
                ),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: 40,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(0xFF0050EF),
                            border: Border.all(
                              color: Color(0xFFE8E9F1),
                            )),
                        child: SvgPicture.asset(AppIcons.play),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}-Bilet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0050EF),
                          ),
                        ),
                        Text(
                          'Video darslik',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8F9098),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Text(
                      '10:00',
                      style: TextStyle(
                        color: Color(0xFF8F9098),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => SizedBox(
                height: 10,
              ),
          itemCount: 20),
    );
  }
}
