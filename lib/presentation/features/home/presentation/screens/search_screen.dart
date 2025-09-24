import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/questions_result_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/widgets/w_textfield.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearch = false;
  late TextEditingController controller;
  late FocusNode focusNode;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(
            GetOrderedQuestionsEvent(
              questionCount: 1,
              onSuccess: (questions) {
                if (questions.isNotEmpty) {
                  context.read<QuestionsSolveBloc>().add(
                        LoadQuestionsEvent(questions),
                      );
                }
              },
            ),
          );
    });

    isSearch = false;
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (isSearch) {
                  setState(() {
                    isSearch = false;
                    controller.clear();
                    context
                        .read<HomeBloc>()
                        .add(SearchQuestionEvent(query: ''));
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: SvgPicture.asset(
                AppIcons.chevronLeft,
                colorFilter: ColorFilter.mode(
                  context.themeExtension.blackToWhite!,
                  BlendMode.srcIn,
                ),
              ),
            ),
            leadingWidth: 30,
            centerTitle: true,
            title: isSearch
                ? WTextField(
                    focusNode: focusNode,
                    controller: controller,
                    margin: EdgeInsets.zero,
                    borderRadius: 16,
                    hintText: Strings.search,
                    hintTextStyle: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: context.themeExtension.ashGrayToPaleGray,
                    ),
                    hasBorderColor: false,
                    fillColor: context.themeExtension.whiteToGondola,
                    focusColor: context.themeExtension.whiteToGondola,
                    onChanged: (text) {
                      context
                          .read<HomeBloc>()
                          .add(SearchQuestionEvent(query: text));
                      setState(() {});
                    },
                    suffix: controller.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              setState(() {
                                controller.clear();
                                // isSearch = false;
                              });
                              context
                                  .read<HomeBloc>()
                                  .add(SearchQuestionEvent(query: ''));
                            },
                            child: Icon(
                              Icons.clear,
                              color: context.themeExtension.blackToWhite,
                            ),
                          )
                        : null,
                  )
                : Text(
                    Strings.tests,
                    style: context.textTheme.bodySmall!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            automaticallyImplyLeading: false,
            actions: isSearch
                ? null
                : [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSearch = !isSearch;
                        });
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          focusNode.requestFocus();
                        });
                      },
                      child: SvgPicture.asset(
                        width: 24,
                        height: 24,
                        AppIcons.search,
                        colorFilter: ColorFilter.mode(
                            context.themeExtension.blackToWhite!,
                            BlendMode.srcIn),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ],
          ),
          body: state.searchQuestions.isNotEmpty
              ? ListView.separated(
                  padding: EdgeInsets.only(top: 12),
                  itemBuilder: (context, index) {
                    return QuestionsResultWidget(
                      questionModel: state.searchQuestions[index],
                      index: index,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 12,
                    );
                  },
                  itemCount: state.searchQuestions.length)
              : EmptyWidget(),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
