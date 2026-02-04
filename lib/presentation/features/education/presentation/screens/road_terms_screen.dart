import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/widgets/w_textfield.dart';
import 'package:avtotest/presentation/features/education/presentation/bloc/education_bloc.dart';
import 'package:avtotest/presentation/features/education/presentation/widgets/road_term_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoadTermsScreen extends StatefulWidget {
  const RoadTermsScreen({super.key});

  @override
  State<RoadTermsScreen> createState() => _RoadTermsScreenState();
}

class _RoadTermsScreenState extends State<RoadTermsScreen> {
  String query = "";
  late TextEditingController controller;

  @override
  void initState() {
    context.read<EducationBloc>().add(InitializeTermsEvent());
    query = "";
    controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EducationBloc, EducationState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBarWrapper(
            title: Strings.terms,
            hasBackButton: true,
          ),
          body: Column(
            children: [
              SizedBox(
                height: 12,
              ),
              WTextField(
                controller: controller,
                margin:
                    EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 16),
                borderRadius: 16,
                hintText: Strings.search,
                hintTextStyle: context.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: context.themeExtension.ashGrayToPaleGray,
                ),
                fillColor: context.themeExtension.offWhiteBlueTintToGondola,
                focusColor: context.themeExtension.offWhiteBlueTintToGondola,
                onChanged: (text) {
                  query = text;
                  setState(() {});
                  context.read<EducationBloc>().add(
                        SearchTermsEvent(searchText: query),
                      );
                },
                suffix: GestureDetector(
                  onTap: () {
                    if (query.isNotEmpty) {
                      query = "";
                      context.read<EducationBloc>().add(
                            SearchTermsEvent(searchText: query),
                          );
                      setState(() {});
                      controller.clear();
                    }
                  },
                  child: query.isEmpty
                      ? SvgPicture.asset(
                          AppIcons.search,
                          colorFilter: ColorFilter.mode(
                              context.themeExtension.ashGrayToPaleGray!,
                              BlendMode.srcIn),
                        )
                      : Icon(
                          Icons.clear,
                          color: context.themeExtension.blackToWhite,
                        ),
                ),
              ),
              Expanded(
                child: state.terms.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) {
                          return RoadTermWidget(
                            termModel: state.searchTerms[index],
                            highlightedText: query,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 16,
                          );
                        },
                        itemCount: state.searchTerms.length)
                    : EmptyWidget(),
              ),
            ],
          ),
        );
      },
    );
  }
}