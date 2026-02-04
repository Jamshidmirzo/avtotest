import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/delete_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/test_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/ticket_status_widget.dart';
import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetTicketsStatisticsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.allTickets,
        hasBackButton: true,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  useRootNavigator: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return DeleteBottomSheet(
                      title: Strings.deleteTicketResults,
                      description:
                          Strings.allResultsWillBeDeletedDoYouWantToProceed,
                      onTap: () {
                        context.addBlocEvent<HomeBloc>(
                            DeleteTicketStatisticsEvent());
                        context.addBlocEvent<HomeBloc>(
                            DeleteMistakeHistoryEvent());
                        context.navigator.pop();
                      },
                    );
                  });
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(
                  AppIcons.trash,
                  colorFilter: ColorFilter.mode(
                      context.themeExtension.mainBlackToWhite!,
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: state.ticketsStatistics.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.55,
            ),
            itemBuilder: (context, index) {
              final length = state.ticketsStatistics.length;
              final isLast = index >= length - 2;

              return _buildTicketStatusWidget(
                context,
                state,
                index,
                isLast,
              );
            },
          );
        },
      ),
    );
  }

  TicketStatusWidget _buildTicketStatusWidget(
      BuildContext context, HomeState state, int index, bool isLast) {
    return TicketStatusWidget(
      isLast: isLast,
      onTap: () {
        var ticketStatus = state.ticketsStatistics[index];
        context.addBlocEvent<HomeBloc>(
          GetTicketQuestionEvent(
            onSuccess: (List<QuestionModel> questions) {
              context.rootNavigator
                  .pushPage(TestScreen(
                    questions: questions,
                    title: "${ticketStatus.tickedId} - ${Strings.ticket}",
                    tickedId: state.ticketsStatistics[index].tickedId,
                    examType: ExamType.ticket,
                  ))
                  .then((value) => context.addBlocEvent<HomeBloc>(
                        GetTicketsStatisticsEvent(),
                      ));
            },
            ticketId: state.ticketsStatistics[index].tickedId,
          ),
        );
      },
      entity: state.ticketsStatistics[index],
    );
  }
}
