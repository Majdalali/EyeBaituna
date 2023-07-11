// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../services/api_service.dart';
import '../user_preferences/in_app_user.dart';

class BlockedWebsites extends StatefulWidget {
  const BlockedWebsites({super.key});

  @override
  State<BlockedWebsites> createState() => _BlockedWebsitesState();
}

class _BlockedWebsitesState extends State<BlockedWebsites> {
  List<String> bannedURLs = [];
  final InAppUser _inAppUser = Get.put(InAppUser());

  @override
  void initState() {
    super.initState();
    fetchBannedURLs(_inAppUser.user.id);
  }

  Future<void> fetchBannedURLs(int userId) async {
    try {
      List<String> urls = await ApiService.fetchBannedURLs(userId);
      setState(() {
        bannedURLs = urls;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blocked Websites',
            textAlign: TextAlign.start,
            style: GoogleFonts.workSans(
              textStyle: TextStyle(
                color: Color.fromRGBO(120, 120, 250, 1),
                fontSize: 13.sp,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          bannedURLs.isEmpty
              ? Center(
                  child: Text(
                    'Blocked websites will appear here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: bannedURLs.length,
                    itemBuilder: (context, index) {
                      final number =
                          index + 1; // Incrementing index by 1 for numbering

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
                        title: Text(
                          bannedURLs[index],
                          style: GoogleFonts.inter(
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
          SizedBox(height: 30.0),
        ],
      ),
    );
  }
}
