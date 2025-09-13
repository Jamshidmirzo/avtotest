import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/question_search_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bottom_sheet/delete_sheet.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
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
                                      context.read<HomeBloc>().add(DeleteBookmarksEvent());
                                      Navigator.pop(context);
                                    },
                                    title: Strings.deleteSavedQuestions,
                                    description: Strings.doYouWantToDeleteAllSavedQuestions);
                              });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: SvgPicture.asset(
                              AppIcons.trash,
                              colorFilter: ColorFilter.mode(context.themeExtension.blackToWhite!, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ]
                  : null,
            ),
            body: state.bookmarks.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(top: 12, bottom: context.padding.bottom),
                    itemBuilder: (context, index) {
                      return QuestionSearchWidget(
                        questionModel: state.bookmarks[index],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: state.bookmarks.length)
                : EmptyWidget());
      },
    );
  }
}
