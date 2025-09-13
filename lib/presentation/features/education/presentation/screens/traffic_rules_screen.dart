import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/features/education/presentation/screens/rule_single_screen.dart';
import 'package:avtotest/presentation/features/education/presentation/widgets/traffic_rule_widget.dart';
import 'package:flutter/material.dart';

class TrafficRulesScreen extends StatelessWidget {
  TrafficRulesScreen({super.key});

  final List<Map<String, String>> rules = [
    {"number": "1", "title": "Umumiy qoidalar"},
    {"number": "2", "title": "Haydovchining umumiy majburiyatlari"},
    {"number": "3", "title": "Piyodaning majburiyatlari"},
    {"number": "4", "title": "Yo’lovchining majburiyatlari"},
    {"number": "5", "title": "Maxsus avtomobillarning muximlilik darajalari"},
    {"number": "6", "title": "Svetofor va yo’naltiruvchining ishoralari"},
    {"number": "7", "title": "Umumiy qoidalar"},
    {"number": "8", "title": "Umumiy qoidalar"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.trafficLaws,
        hasBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: rules.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return TrafficRuleWidget(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        RuleSingleScreen(title: rules[index]['title']!), // Replace with the actual screen
                  ),
                );
              },
              index: index + 1,
              title: rules[index]['title']!,
            );
          },
        ),
      ),
    );
  }
}
