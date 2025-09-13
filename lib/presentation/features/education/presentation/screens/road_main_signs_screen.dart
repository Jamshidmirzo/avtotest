import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/features/education/presentation/bloc/education_bloc.dart';
import 'package:avtotest/presentation/features/education/presentation/screens/road_signs_screen.dart';
import 'package:avtotest/presentation/features/education/presentation/widgets/road_sign_main_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocBuilder, ReadContext;

class RoadMainSignsScreen extends StatefulWidget {
  const RoadMainSignsScreen({super.key});

  @override
  State<RoadMainSignsScreen> createState() => _RoadMainSignsScreenState();
}

class _RoadMainSignsScreenState extends State<RoadMainSignsScreen> {
  @override
  void initState() {
    context.read<EducationBloc>()
      ..add(ParseSignMainsEvent())
      ..add(ParseSignsEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.roadSigns,
        hasBackButton: true,
      ),
      body: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
          return state.signMains.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(top: 12, bottom: context.padding.bottom + 8, left: 12, right: 12),
                  itemCount: state.signMains.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    return RoadSignMainWidget(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return RoadSignsScreen(
                            id: state.signMains[index].id,
                          );
                        }));
                      },
                      index: index,
                      model: state.signMains[index],
                    );
                  },
                )
              : EmptyWidget();
        },
      ),
    );
  }
}
