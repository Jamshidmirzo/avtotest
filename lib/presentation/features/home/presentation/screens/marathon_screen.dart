// // ignore_for_file: deprecated_member_use

// import 'dart:async';
// import 'package:avtotest/core/assets/colors/app_colors.dart';
// import 'package:avtotest/core/assets/constants/app_icons.dart';
// import 'package:avtotest/core/utils/my_functions.dart';
// import 'package:avtotest/data/datasource/preference/device_preferences.dart';
// import 'package:avtotest/data/datasource/preference/settings_preferences.dart';
// import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
// import 'package:avtotest/data/datasource/preference/user_preferences.dart';
// import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
// import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
// import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
// import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
// import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
// import 'package:avtotest/presentation/utils/extensions.dart';
// import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
// import 'package:avtotest/presentation/widgets/w_html.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../screens/photo_view_screen.dart';

// class MarathonScreen extends StatefulWidget {
//   const MarathonScreen({
//     super.key,
//     required this.questions,
//     required this.title,
//   });

//   final List<QuestionModel> questions;
//   final String title;

//   @override
//   State<MarathonScreen> createState() => _MarathonScreenState();
// }

// class _MarathonScreenState extends State<MarathonScreen> {
//   final QuestionsSolveBloc _bloc = QuestionsSolveBloc();
//   final PageController _pageController = PageController();
//   Timer? _autoNextTimer;

//   late final SettingsPreferences _settingsPreferences;

//   int _currentIndex = 0;
//   int _errorCount = 0;
//   int _totalAnswered = 0;

//   @override
//   void initState() {
//     super.initState();
//     _initPreferences();
//     _bloc.add(
//       InitialQuestionsEvent(
//         questions: widget.questions,
//         time: Duration.zero,
//         isMarathon: true,
//       ),
//     );
//   }

//   Future<void> _initPreferences() async {
//     _settingsPreferences = await SettingsPreferences.getInstance();
//   }

//   void _updateStats() {
//     int errors = 0;
//     int answered = 0;

//     final questions = _bloc.state.questions;
//     for (var q in questions) {
//       if (q.isAnswered) {
//         answered++;
//         if (q.errorAnswerIndex != -1) {
//           errors++;
//         }
//       }
//     }

//     if (_errorCount != errors || _totalAnswered != answered) {
//       setState(() {
//         _errorCount = errors;
//         _totalAnswered = answered;
//       });
//     }
//   }

//   void _handleAnswerTap(int answerIndex) {
//     final currentQuestion = _bloc.state.questions[_currentIndex];

//     if (!currentQuestion.isNotAnswered) return;

//     _bloc.add(
//       QuestionAnsweredEvent(
//         answerIndex: answerIndex,
//         isMarathon: true,
//         onSuccess: (bool isError) {
//           if (isError) HapticFeedback.mediumImpact();
//           _updateStats();
//         },
//         onNext: () {
//           _autoNextTimer?.cancel();

//           if (_currentIndex >= widget.questions.length - 1) return;

//           _autoNextTimer = Timer(const Duration(milliseconds: 800), () {
//             if (!mounted) return;

//             _pageController.nextPage(
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.easeOut,
//             );
//           });
//         },
//       ),
//     );
//   }

//   void _showHintBottomSheet(QuestionModel question) {
//     final lang = context.locale.languageCode;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       isScrollControlled: true,
//       builder: (ctx) {
//         return Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height * 0.7,
//           ),
//           decoration: BoxDecoration(
//             color: context.themeExtension.whiteToGondola,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 12),
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: context.themeExtension.grey.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Подсказка',
//                       style: context.textTheme.headlineMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//               ),
//               const Divider(height: 1),
//               Flexible(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (question.hint.isNotEmpty) ...[
//                         WHtml(
//                           data: MyFunctions.getQuestionHint(
//                             questionModel: question,
//                             lang: lang,
//                           ),
//                           pFontSize: 16,
//                           textColor: context.themeExtension.blackToWhite,
//                         ),
//                         const SizedBox(height: 16),
//                       ],
//                       if (question.ticketNumber.isNotEmpty) ...[
//                         Text(
//                           'Билет: ${question.ticketNumber}',
//                           style: context.textTheme.bodyLarge,
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                       if (question.link.isNotEmpty) ...[
//                         InkWell(
//                           onTap: () async {
//                             final uri = Uri.parse(question.link);
//                             if (await canLaunchUrl(uri)) {
//                               await launchUrl(uri,
//                                   mode: LaunchMode.externalApplication);
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 12,
//                             ),
//                             decoration: BoxDecoration(
//                               color: AppColors.blue.withOpacity(0.1),
//                               borderRadius: BorderRadius.circular(8),
//                               border: Border.all(color: AppColors.blue),
//                             ),
//                             child: Row(
//                               children: [
//                                 Icon(Icons.link, color: AppColors.blue),
//                                 const SizedBox(width: 8),
//                                 Expanded(
//                                   child: Text(
//                                     'Открыть ссылку',
//                                     style: TextStyle(
//                                       color: AppColors.blue,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                                 Icon(
//                                   Icons.open_in_new,
//                                   color: AppColors.blue,
//                                   size: 20,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _autoNextTimer?.cancel();
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: _bloc,
//       child: BlocBuilder<QuestionsSolveBloc, QuestionsSolveState>(
//         buildWhen: (prev, curr) =>
//             prev.questions.length != curr.questions.length,
//         builder: (context, state) {
//           if (state.questions.isEmpty) {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             );
//           }

//           final currentQuestion = _currentIndex < state.questions.length
//               ? state.questions[_currentIndex]
//               : null;

//           final canShowHint = currentQuestion != null &&
//               (!_settingsPreferences.isAnswerHintShowingEnabled ||
//                   currentQuestion.isAnswered);

//           return Scaffold(
//             appBar: AppBarWrapper(
//               title: widget.title,
//               hasBackButton: true,
//               actions: [
//                 Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: RichText(
//                       text: TextSpan(
//                         children: [
//                           TextSpan(
//                             text: "$_errorCount",
//                             style: context.textTheme.headlineSmall!
//                                 .copyWith(color: AppColors.red),
//                           ),
//                           TextSpan(
//                             text: " / $_totalAnswered",
//                             style: context.textTheme.headlineSmall!.copyWith(
//                               color:
//                                   context.themeExtension.charcoalBlackToWhite,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       _bloc.add(RefreshMarathonEvent());
//                       setState(() {
//                         _currentIndex = 0;
//                         _errorCount = 0;
//                         _totalAnswered = 0;
//                       });
//                       _pageController.jumpToPage(0);
//                     },
//                     child: Icon(
//                       Icons.refresh,
//                       color: context.themeExtension.blackToWhite,
//                       size: 30,
//                     ),
//                   ),
//                 ),
//                 Center(
//                   child: GestureDetector(
//                     onTap: () {
//                       if (currentQuestion != null) {
//                         context.addBlocEvent<HomeBloc>(ParseQuestionsEvent());
//                         context.addBlocEvent<QuestionsSolveBloc>(
//                           BookmarkEvent(question: currentQuestion),
//                         );
//                         context.addBlocEvent<HomeBloc>(
//                           BookmarkedEvent(
//                             questionId: currentQuestion.id,
//                             isBookmarked: currentQuestion.isBookmarked,
//                           ),
//                         );
//                       }
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: SvgPicture.asset(
//                         AppIcons.bookmark,
//                         colorFilter: ColorFilter.mode(
//                           currentQuestion?.isBookmarked == true
//                               ? AppColors.yellow
//                               : context.themeExtension.blackToWhite!,
//                           BlendMode.srcIn,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//               ],
//               onTap: () => Navigator.of(context).pop(),
//             ),
//             body: PageView.builder(
//               controller: _pageController,
//               physics: const BouncingScrollPhysics(),
//               onPageChanged: (index) {
//                 setState(() => _currentIndex = index);
//                 _bloc.add(MoveQuestionEvent(index: index));
//               },
//               itemCount: state.questions.length,
//               itemBuilder: (context, index) {
//                 return _QuestionPage(
//                   key: ValueKey('q_${state.questions[index].id}'),
//                   question: state.questions[index],
//                   onAnswerTap: _handleAnswerTap,
//                 );
//               },
//             ),
//             floatingActionButton: canShowHint
//                 ? FloatingActionButton(
//                     onPressed: () => _showHintBottomSheet(currentQuestion!),
//                     backgroundColor: context.themeExtension.whiteToGondola,
//                     child: Icon(
//                       Icons.lightbulb_outline,
//                       color: context.themeExtension.blackToWhite,
//                     ),
//                   )
//                 : null,
//           );
//         },
//       ),
//     );
//   }
// }

// class _QuestionPage extends StatelessWidget {
//   final QuestionModel question;
//   final Function(int) onAnswerTap;

//   const _QuestionPage({
//     super.key,
//     required this.question,
//     required this.onAnswerTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final lang = context.locale.languageCode;

//     return BlocBuilder<HomeBloc, HomeState>(
//       buildWhen: (p, s) =>
//           s.questionFontSize != p.questionFontSize ||
//           s.answerFontSize != p.answerFontSize,
//       builder: (context, state) {
//         return SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: Column(
//             children: [
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 child: WHtml(
//                   data: MyFunctions.getQuestionTitle(
//                     questionModel: question,
//                     lang: lang,
//                   ),
//                   pFontSize: state.questionFontSize,
//                   pFontWeight: FontWeight.w700,
//                   textAlign: TextAlign.center,
//                   textColor: context.themeExtension.blackToWhite,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               if (question.media.isNotEmpty) ...[
//                 GestureDetector(
//                   onTap: () {
//                     final img = MyFunctions.getAssetsImage(question.media);
//                     showGeneralDialog(
//                       context: context,
//                       barrierDismissible: true,
//                       barrierLabel: "PhotoView",
//                       barrierColor: Colors.black.withOpacity(0.60),
//                       transitionDuration: const Duration(milliseconds: 200),
//                       pageBuilder: (_, __, ___) => PhotoViewDialog(
//                         image: img,
//                         isPngImage: true,
//                       ),
//                     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.all(Radius.circular(16)),
//                       child: Image.asset(
//                         MyFunctions.getAssetsImage(question.media),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//               ListView.builder(
//                 padding: EdgeInsets.only(
//                   bottom: MediaQuery.of(context).padding.bottom + 80,
//                   left: 16,
//                   right: 16,
//                 ),
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: question.answers.length,
//                 itemBuilder: (_, index) {
//                   return Padding(
//                     padding: const EdgeInsets.only(bottom: 12),
//                     child: AnswerWidget(
//                       title: MyFunctions.getAnswerTitle(
//                         answerModel: question.answers[index],
//                         lang: lang,
//                       ),
//                       status: MyFunctions.getAnswerStatus(
//                         questionModel: question,
//                         index: index,
//                       ),
//                       index: index,
//                       answerFontSize: state.answerFontSize,
//                       onTap: () => onAnswerTap(index),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
