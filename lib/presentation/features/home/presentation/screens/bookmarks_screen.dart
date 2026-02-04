import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/questions_result_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:avtotest/presentation/features/home/presentation/screens/test_screen.dart';
import '../bottom_sheet/delete_sheet.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return BlocProvider(
          create: (_) =>
              QuestionsSolveBloc()..add(InitQuestionsEvent(state.bookmarks)),
          child: Scaffold(
            appBar: AppBarWrapper(
              title: Strings.savedQuestions,
              hasBackButton: true,
              actions: state.bookmarks.isNotEmpty
                  ? [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            useRootNavigator: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return DeleteBottomSheet(
                                onTap: () {
                                  context
                                      .read<HomeBloc>()
                                      .add(DeleteBookmarksEvent());
                                  Navigator.pop(context);
                                },
                                title: Strings.deleteSavedQuestions,
                                description:
                                    Strings.doYouWantToDeleteAllSavedQuestions,
                              );
                            },
                          );
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              AppIcons.trash,
                              colorFilter: ColorFilter.mode(
                                context.themeExtension.blackToWhite!,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  : null,
            ),
            body: state.bookmarks.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: context.padding.bottom,
                    ),
                    itemBuilder: (context, index) {
                      return index == 0
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TestScreen(
                                      questions: state.bookmarks,
                                      title: Strings.savedQuestions,
                                      examType: ExamType.hardQuestions,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  height: 50,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.black
                                        : Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            AppColors.black.withOpacity(0.10),
                                        blurRadius: 8,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      width: 1,
                                      color: context.themeExtension
                                          .whiteSmokeToWhiteSmoke!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Savolarni test rejimida ishlash',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ],
                                  )),
                            )
                          : QuestionsResultWidget(
                              index: index,
                              type: 1,
                              questionModel: state.bookmarks[index],
                            );
                    },
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: state.bookmarks.length,
                  )
                : const EmptyWidget(),
          ),
        );
      },
    );
  }
}
