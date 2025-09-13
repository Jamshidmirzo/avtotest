import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/features/education/presentation/bottom_sheet/road_sign_bottom_sheet.dart';
import 'package:avtotest/presentation/features/education/presentation/widgets/road_sign_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/education_bloc.dart';

class RoadSignsScreen extends StatefulWidget {
  const RoadSignsScreen({super.key, required this.id});

  final String id;

  @override
  State<RoadSignsScreen> createState() => _RoadSignsScreenState();
}

class _RoadSignsScreenState extends State<RoadSignsScreen> {
  @override
  void initState() {
    context.read<EducationBloc>().add(GetSignById(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.roadSigns,
        hasBackButton: true,
      ),
      body: BlocBuilder<EducationBloc, EducationState>(
        builder: (context, state) {
          return state.filterSigns.isNotEmpty
              ? GridView.builder(
                  padding: EdgeInsets.only(top: 12, bottom: context.padding.bottom + 8, left: 8, right: 8),
                  itemCount: state.filterSigns.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    return RoadSignWidget(
                      onTap: () {
                        showModalBottomSheet(
                            useRootNavigator: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return RoadSignBottomSheet(
                                signModel: state.filterSigns[index],
                              );
                            });
                      },
                      index: index,
                      model: state.filterSigns[index],
                    );
                  },
                )
              : EmptyWidget();
        },
      ),
    );
  }
}
