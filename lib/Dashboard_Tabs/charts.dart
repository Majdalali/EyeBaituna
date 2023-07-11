// ignore_for_file: prefer_const_constructors, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../services/api_service.dart';
import '../user_preferences/in_app_user.dart';

class Charts extends StatefulWidget {
  const Charts({Key? key});

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  late List<InternetDetails> _chartData = [];
  late TooltipBehavior _toolTipBehavior;
  bool _customIcon = false;
  final InAppUser _inAppUser = Get.put(InAppUser());

  // Dummy descriptions for each category
  // ignore: prefer_final_fields
  Map<String, String> _descriptions = {
    'Pornography': 'Content that depicts explicit sexual acts or nudity.',
    'News':
        'Websites for current events or information about recent happenings.',
    'Social':
        'Websites or platforms for connecting and interacting with others.',
    'Search Engine': 'Tools for finding information on the internet.',
    'Malicious': 'Websites containing harmful or deceptive content.',
  };

  @override
  void initState() {
    _toolTipBehavior = TooltipBehavior(enable: true);
    fetchChartData(); // Fetch chart data from API
    super.initState();
  }

  Future<void> fetchChartData() async {
    try {
      final List<Map<String, dynamic>> visitedWebsites =
          await ApiService.fetchVisitedWebsites(_inAppUser.user.id);

      // Count the occurrences of each category
      final Map<String, int> categoryOccurrences = {};
      for (var website in visitedWebsites) {
        final category = website['category_name'] ?? 'Uncategorized';
        categoryOccurrences[category] =
            (categoryOccurrences[category] ?? 0) + 1;
      }

      final List<InternetDetails> chartData = [];
      for (var category in categoryOccurrences.keys) {
        final value = categoryOccurrences[category]!;
        final description =
            _descriptions[category] ?? 'No description available';
        chartData.add(InternetDetails(category, value, description));
      }

      setState(() {
        _chartData = chartData;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Widget categoryDetails(
      String categoryName, int categoryValue, String description) {
    return Column(
      children: [
        ExpansionTile(
          backgroundColor: Color.fromRGBO(35, 35, 54, 1),
          collapsedBackgroundColor: Color.fromRGBO(35, 35, 54, 1),
          textColor: Color.fromRGBO(120, 120, 250, 1),
          collapsedTextColor: Color.fromRGBO(224, 224, 254, 1),
          collapsedIconColor: Colors.white,
          iconColor: Color.fromRGBO(120, 120, 250, 1),
          title: Text(categoryName),
          trailing: Icon(
              _customIcon ? Icons.arrow_drop_down : Icons.arrow_right_rounded),
          children: [
            ListTile(
              title: Text(
                '$categoryName has been visited $categoryValue times',
                style: TextStyle(color: Color.fromRGBO(224, 224, 254, 1)),
              ),
            ),
            ListTile(
              title: Text(
                description,
                style: TextStyle(color: Color.fromRGBO(224, 224, 254, 1)),
              ),
            ),
            SizedBox(height: 4.0)
          ],
          onExpansionChanged: (bool expanding) =>
              setState(() => _customIcon = expanding),
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              textAlign: TextAlign.start,
              style: GoogleFonts.workSans(
                textStyle: TextStyle(
                  color: Color.fromRGBO(120, 120, 250, 1),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            SfCircularChart(
              legend: Legend(
                isVisible: true,
                overflowMode: LegendItemOverflowMode.wrap,
                textStyle: TextStyle(color: Colors.white),
              ),
              tooltipBehavior: _toolTipBehavior,
              series: <CircularSeries>[
                DoughnutSeries<InternetDetails, String>(
                  dataSource: _chartData,
                  xValueMapper: (InternetDetails data, _) => data.category,
                  yValueMapper: (InternetDetails data, _) => data.value,
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                  enableTooltip: true,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Details on Category',
              style: GoogleFonts.workSans(
                textStyle: TextStyle(
                  color: Color.fromRGBO(224, 224, 254, 1),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _chartData.length,
              itemBuilder: (context, index) {
                final category = _chartData[index];
                return categoryDetails(
                    category.category, category.value, category.description);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class InternetDetails {
  InternetDetails(this.category, this.value, this.description);
  final String category;
  final int value;
  final String description;
}
