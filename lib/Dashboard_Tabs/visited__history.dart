// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../services/api_service.dart';
import '../user_preferences/in_app_user.dart';

class VisitedHistory extends StatefulWidget {
  const VisitedHistory({Key? key}) : super(key: key);

  @override
  State<VisitedHistory> createState() => _VisitedHistoryState();
}

class _VisitedHistoryState extends State<VisitedHistory> {
  List<Map<String, dynamic>> visitedWebsites = [];
  final InAppUser _inAppUser = Get.put(InAppUser());
  List<String> bannedURLs = [];

  @override
  void initState() {
    super.initState();
    fetchVisitedWebsites();
    fetchBannedURLs();
  }

  Future<void> fetchVisitedWebsites() async {
    try {
      final List<Map<String, dynamic>> websites =
          await ApiService.fetchVisitedWebsites(_inAppUser.user.id);
      setState(() {
        visitedWebsites = websites;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> fetchBannedURLs() async {
    try {
      final List<String> bannedURLs =
          await ApiService.fetchBannedURLs(_inAppUser.user.id);
      setState(() {
        this.bannedURLs = bannedURLs;
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> blockURL(String url) async {
    try {
      await ApiService.blockURL(_inAppUser.user.id, url);
      setState(() {
        bannedURLs.add(url);
      });
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _printVisitedWebsitesAsPdf() async {
    try {
      final pdfContent = _generatePdfContent();
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    'Visited Websites',
                    style: pw.TextStyle(fontSize: 18),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(pdfContent),
                ],
              ),
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  String _generatePdfContent() {
    final StringBuffer content = StringBuffer();

    content.writeln('Visited Websites');
    content.writeln('');

    for (var i = 0; i < visitedWebsites.length; i++) {
      final website = visitedWebsites[i];
      final number = i + 1;
      final link = website['link'];
      final visitTime = DateFormat('yy/MM/dd HH:mm')
          .format(DateTime.parse(website['visit_time']));

      content.writeln('$number. $link - Visited on: $visitTime');
      content.writeln('');
    }

    return content.toString();
  }

  Widget visistedWebsites() {
    // Sort the visited websites based on the visit time in descending order
    visitedWebsites.sort((a, b) => b['visit_time'].compareTo(a['visit_time']));

    // Take only the most recent 15 visited websites
    final List<Map<String, dynamic>> recentWebsites =
        visitedWebsites.take(15).toList();

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently Visited Websites',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.workSans(
                    textStyle: TextStyle(
                      color: Color.fromRGBO(120, 120, 250, 1),
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _printVisitedWebsitesAsPdf,
                  child: Text('Print as PDF'),
                ),
              ],
            ),
          ),
          Expanded(
            child: recentWebsites.isEmpty
                ? Center(
                    child: Text(
                      'Recently visited websites will appear here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: recentWebsites.length,
                    itemBuilder: (context, index) {
                      final website = recentWebsites[index];
                      final number =
                          index + 1; // Incrementing index by 1 for numbering

                      final visitTime = DateTime.parse(website['visit_time']);
                      final formattedTime =
                          DateFormat('yy/MM/dd HH:mm').format(visitTime);
                      final isToday =
                          DateTime.now().difference(visitTime).inDays == 0;
                      final subtitleText =
                          isToday ? 'Today $formattedTime' : formattedTime;

                      final bool isBlocked =
                          bannedURLs.contains(website['link']);
                      final category = website['category_name'] ??
                          'Uncategorized'; // Retrieve category name or display 'Uncategorized' if not available

                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(120, 120, 250, 1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$number', // Display the number
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(239, 239, 255, 1),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              website['link'],
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: isBlocked
                                      ? Colors
                                          .grey // Change color for blocked websites
                                      : Color.fromRGBO(239, 239, 255, 1),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              'Category: $category', // Display the category name
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          subtitleText,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(239, 239, 255, 1),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        trailing: isBlocked
                            ? Text(
                                'Blocked',
                                style: TextStyle(
                                  color: Colors.red, // Display blocked state
                                  fontSize: 10.sp,
                                ),
                              )
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(120, 120, 250, 1),
                                ),
                                onPressed: () {
                                  blockURL(website['link']);
                                },
                                child: Text('Block'),
                              ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  Widget topVisitedWebsites() {
    // Count the occurrences of each website
    final Map<String, int> websiteOccurrences = {};
    final Map<String, String> websiteCategories =
        {}; // Map to store category names for each website
    for (var website in visitedWebsites) {
      final link = website['link'];
      websiteOccurrences[link] = (websiteOccurrences[link] ?? 0) + 1;
      final category = website['category_name'] ?? 'Uncategorized';
      websiteCategories[link] =
          category; // Store category name for each website
    }

    // Get the websites with more than 5 occurrences
    final List<String> topWebsites = websiteOccurrences.keys
        .where((link) => websiteOccurrences[link]! >= 5)
        .toList();

    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Top Visited Websites',
              textAlign: TextAlign.start,
              style: GoogleFonts.workSans(
                textStyle: TextStyle(
                  color: Color.fromRGBO(120, 120, 250, 1),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          Expanded(
            child: topWebsites.isEmpty
                ? Center(
                    child: Text(
                      'Top visited websites will appear here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: topWebsites.length,
                    itemBuilder: (context, index) {
                      final link = topWebsites[index];
                      final occurrences = websiteOccurrences[link];
                      final number = index + 1;
                      final category = websiteCategories[link] ??
                          'Uncategorized'; // Retrieve category name or display 'Uncategorized' if not available

                      return ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(120, 120, 250, 1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$number',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(239, 239, 255, 1),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              link,
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Color.fromRGBO(239, 239, 255, 1),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              'Category: $category', // Display the category name
                              style: GoogleFonts.inter(
                                textStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '$occurrences times',
                          style: GoogleFonts.barlow(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(239, 239, 255, 1),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(indicatorColor: Colors.transparent, tabs: const [
              Tab(
                icon: Icon(
                  Icons.history,
                  color: Color.fromARGB(255, 98, 7, 255),
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.favorite_border,
                  color: Color.fromARGB(255, 98, 7, 255),
                ),
              ),
            ]),
            Expanded(
              child: TabBarView(children: [
                visistedWebsites(),
                topVisitedWebsites(),
              ]),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
