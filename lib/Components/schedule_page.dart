// ignore_for_file: prefer_const_constructors, prefer_const_declarations, avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

import '../services/api_service.dart';
import '../user_preferences/in_app_user.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  TextEditingController bandwidthController = TextEditingController();
  final InAppUser _inAppUser = Get.put(InAppUser());
  DateTimeRange? selectedDateRange;
  List<Device> userDeviceList = [];
  Device? selectedDevice;
  DateTime? startDateTime;
  DateTime? endDateTime;
  bool _isSwitchOn = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchInternetSwitchStatus();
    fetchSchedule();
    fetchDevices();
  }

  Future<void> fetchInternetSwitchStatus() async {
    try {
      final internetSwitch =
          await ApiService.fetchInternetSwitchStatus(_inAppUser.user.id);
      setState(() {
        // ignore: unnecessary_null_comparison
        if (internetSwitch != null) {
          _isSwitchOn = internetSwitch.switchStatus == 'on' &&
              internetSwitch.switchValue == 1;
        } else {
          _isSwitchOn = false;
        }
        _isLoading = false; // Set loading state to false
      });
    } catch (e) {
      print('Failed to fetch internet switch status: $e');
      setState(() {
        _isLoading = false; // Set loading state to false
      });
    }
  }

  Future<void> createInternetSwitchStatus() async {
    try {
      await ApiService.createInternetSwitchStatus(
        userId: _inAppUser.user.id,
        switchStatus: _isSwitchOn ? 'on' : 'off',
        switchValue: _isSwitchOn ? 1 : 0,
      );
    } catch (e) {
      print('Failed to create internet switch status: $e');
    }
  }

  Future<void> updateInternetSwitchStatus(bool value) async {
    try {
      final switchStatus = value ? 'on' : 'off';
      final switchValue = value ? 1 : 0;
      if (_isSwitchOn) {
        // Update the existing internet switch status
        await ApiService.updateInternetSwitchStatus(
          userId: _inAppUser.user.id,
          switchStatus: switchStatus,
          switchValue: switchValue,
        );
      } else {
        // Create a new internet switch status
        await ApiService.createInternetSwitchStatus(
          userId: _inAppUser.user.id,
          switchStatus: switchStatus,
          switchValue: switchValue,
        );
      }

      setState(() {
        _isSwitchOn = value;
      });
    } catch (e) {
      print('Failed to update internet switch status: $e');
    }
  }

  Future<void> fetchSchedule() async {
    try {
      final DateTimeRange? schedule =
          await ApiService.fetchSchedule(_inAppUser.user.id);
      setState(() {
        startDateTime = schedule?.start;
        endDateTime = schedule?.end;
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Failed to fetch schedule: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void assignSchedule() async {
    if (selectedDateRange != null) {
      try {
        final userId = _inAppUser.user.id;
        final startDate = selectedDateRange!.start;
        final endDate = selectedDateRange!.end;

        // Check if the user already has a schedule
        final existingSchedule = await ApiService.fetchSchedule(userId);

        if (existingSchedule != null) {
          // Update the existing schedule
          await ApiService.assignSchedule(
            userId: userId,
            startDate: startDate,
            endDate: endDate,
          );

          Fluttertoast.showToast(
            msg: 'Schedule has been updated successfully.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
        } else {
          // Create a new schedule
          await ApiService.assignSchedule(
            userId: userId,
            startDate: startDate,
            endDate: endDate,
          );

          Fluttertoast.showToast(
            msg: 'Schedule has been assigned successfully.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
          );
        }
      } catch (e) {
        print('Error: $e');
        Fluttertoast.showToast(
          msg: 'Failed to assign or update schedule: $e',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }

  Future<void> fetchDevices() async {
    try {
      final List<Device> devices =
          await ApiService.fetchDevices(_inAppUser.user.id);
      setState(() {
        userDeviceList = devices;
        selectedDevice = devices.isNotEmpty ? devices[0] : null;
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Failed to fetch devices: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    }
  }

  void assignBandwidth() async {
    // Get the selected device and bandwidth value
    Device? device = selectedDevice;
    int bandwidth = int.parse(bandwidthController.text);

    if (device != null) {
      try {
        // Make the API call to assign the bandwidth
        await ApiService.addBandwidthToDevice(
          deviceId: device.id,
          bandwidth: bandwidth,
        );

        // Update the selectedDevice
        setState(() {
          selectedDevice = device;
        });

        // Show a success message
        Fluttertoast.showToast(
          msg: 'Bandwidth has been assigned to the device.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } catch (e) {
        // Show an error message
        Fluttertoast.showToast(
          msg: 'Failed to assign bandwidth to the device.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        //? Wrapper
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              //? Hero Section
              Column(
                children: [
                  //! Header
                  Stack(children: [
                    //! HContainer
                    Container(
                      height: 18.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: const [
                            Color.fromRGBO(116, 116, 242, 0.1),
                            Color.fromRGBO(116, 116, 242, 0.5),
                          ],
                        ),
                      ),
                    ),
                    //! HPageTitle-Dashboard
                    //! HSubTitle-WelcomeBack
                    Center(
                      child: Column(
                        children: [
                          SizedBox(height: 30.0),
                          Text('Schedule',
                              style: GoogleFonts.sora(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 250, 1),
                                    fontSize: 19.sp,
                                    fontWeight: FontWeight.normal),
                              )),
                          Text('Parental Control',
                              style: GoogleFonts.workSans(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 250, 1),
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w300),
                              )),
                        ],
                      ),
                    ),
                    //! Device Switch
                    Container(
                      margin: EdgeInsets.only(top: 15.5.h),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                        ),
                        child: Container(
                          width: 90.w,
                          height: 8.h,
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(242, 242, 255, 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Pause Internet',
                                      style: GoogleFonts.workSans(
                                        textStyle: TextStyle(
                                            color:
                                                Color.fromRGBO(22, 23, 26, 1),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w300),
                                      )),
                                  _isLoading
                                      ? CircularProgressIndicator() // Show a loading indicator while fetching the switch status
                                      : Switch(
                                          value: _isSwitchOn,
                                          onChanged: (bool value) async {
                                            setState(() {
                                              _isLoading =
                                                  true; // Set loading state to true
                                              _isSwitchOn = value;
                                            });

                                            if (_isSwitchOn) {
                                              await createInternetSwitchStatus();
                                            } else {
                                              await updateInternetSwitchStatus(
                                                  value);
                                            }

                                            setState(() {
                                              _isLoading =
                                                  false; // Set loading state to false
                                            });
                                          },
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 50.0),
              Container(
                width: 85.w,
                padding: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(35, 35, 54, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set a Surfing Schedule',
                          style: GoogleFonts.workSans(
                            textStyle: TextStyle(
                              color: Color.fromRGBO(120, 120, 250, 1),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Date',
                              style: GoogleFonts.workSans(
                                textStyle: TextStyle(
                                  color: Color.fromRGBO(242, 242, 255, 1),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                List<DateTime>? dateTimeList =
                                    await showOmniDateTimeRangePicker(
                                  context: context,
                                  startInitialDate: DateTime.now(),
                                  startFirstDate: DateTime(1600)
                                      .subtract(Duration(days: 3652)),
                                  startLastDate:
                                      DateTime.now().add(Duration(days: 3652)),
                                  endInitialDate: DateTime.now(),
                                  endFirstDate: DateTime(1600)
                                      .subtract(Duration(days: 3652)),
                                  endLastDate:
                                      DateTime.now().add(Duration(days: 3652)),
                                  is24HourMode: false,
                                  isShowSeconds: false,
                                  minutesInterval: 1,
                                  secondsInterval: 1,
                                  isForce2Digits: true,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16)),
                                  constraints: const BoxConstraints(
                                    maxWidth: 350,
                                    maxHeight: 650,
                                  ),
                                  transitionBuilder:
                                      (context, anim1, anim2, child) {
                                    return FadeTransition(
                                      opacity: anim1.drive(
                                        Tween(
                                          begin: 0,
                                          end: 1,
                                        ),
                                      ),
                                      child: child,
                                    );
                                  },
                                  transitionDuration:
                                      const Duration(milliseconds: 200),
                                  barrierDismissible: true,
                                  selectableDayPredicate: (dateTime) {
                                    // Disable 25th Feb 2023
                                    if (dateTime == DateTime(2023, 2, 25)) {
                                      return false;
                                    } else {
                                      return true;
                                    }
                                  },
                                );
                                if (dateTimeList != null) {
                                  setState(() {
                                    selectedDateRange = DateTimeRange(
                                      start: dateTimeList[0],
                                      end: dateTimeList[1],
                                    );
                                  });
                                } // Update the display after selecting date range
                              },
                              child: Text(
                                selectedDateRange != null
                                    ? "A date is selected"
                                    : "Select Date Range",
                                style: GoogleFonts.sora(
                                  textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 255, 1),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        if (startDateTime != null && endDateTime != null)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Starts',
                                    style: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yy/MM/dd HH:mm')
                                        .format(startDateTime!),
                                    style: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Ends',
                                    style: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat('yy/MM/dd HH:mm')
                                        .format(endDateTime!),
                                    style: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Text(
                            'No date range selected',
                            style: GoogleFonts.workSans(
                              textStyle: TextStyle(
                                color: Color.fromRGBO(242, 242, 255, 1),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: GestureDetector(
                        onTap: () {
                          assignSchedule();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: const [
                                Color.fromRGBO(157, 98, 217, 1),
                                Color.fromRGBO(98, 98, 217, 1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Assign Schedule',
                              style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              ),
              SizedBox(height: 20.0),

              Container(
                width: 85.w,
                padding: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(35, 35, 54, 1),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bandwidth Usage',
                          style: GoogleFonts.workSans(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(120, 120, 250, 1),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select User',
                              style: GoogleFonts.workSans(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 255, 1),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<Device>(
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color.fromRGBO(242, 242, 255, 1),
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                dropdownColor: Color.fromRGBO(59, 59, 86, 1),
                                value: selectedDevice,
                                items: userDeviceList.map((Device device) {
                                  return DropdownMenuItem<Device>(
                                    key: Key(device.id.toString()),
                                    value: device,
                                    child: Text(
                                      device.name,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (Device? value) {
                                  setState(() {
                                    selectedDevice = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Bandwidth',
                              style: GoogleFonts.workSans(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 255, 1),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextField(
                                  controller: bandwidthController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        width: 1.0),
                                  ))),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: GestureDetector(
                        onTap: () {
                          assignBandwidth();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: const [
                                  Color.fromRGBO(157, 98, 217, 1),
                                  Color.fromRGBO(98, 98, 217, 1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Text(
                              'Assign Bandwidth',
                              style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
