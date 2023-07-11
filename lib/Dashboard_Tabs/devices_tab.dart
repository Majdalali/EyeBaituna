// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../services/api_service.dart';
import '../user_preferences/in_app_user.dart';

class DevicesTab extends StatefulWidget {
  const DevicesTab({Key? key}) : super(key: key);

  @override
  _DevicesTabState createState() => _DevicesTabState();
}

class _DevicesTabState extends State<DevicesTab> {
  List<Device> devices = []; // Updated to store list of Device objects
  final InAppUser _inAppUser = Get.put(InAppUser());

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      int userId = _inAppUser.user.id;
      List<Device> fetchedDevices = await ApiService.fetchDevices(userId);
      setState(() {
        devices = fetchedDevices;
      });
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget deviceListCard(Device device) {
      // Updated to receive a Device object
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color.fromRGBO(35, 35, 54, 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person_4,
                  color: Colors.white,
                  size: 24,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    device.name, // Use the name property of the Device object
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        color: Color.fromRGBO(242, 242, 250, 1),
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              device.bandwidthLimit
                  .toString(), // Use the name property of the Device object
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: Color.fromRGBO(115, 249, 187, 1),
                  fontSize: 10.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.topLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registered Devices',
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
            devices.isEmpty
                ? Center(
                    child: Text(
                      'Registered devices will appear here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          deviceListCard(
                              devices[index]), // Pass the Device object
                          SizedBox(height: 10.0),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
