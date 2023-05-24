// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  bool light = true;
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
            decoration: const BoxDecoration(
          color: Color.fromRGBO(22, 23, 26, 1),
        )),
        //? Wrapper
        Column(
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
                        Text('...',
                            style: GoogleFonts.workSans(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(242, 242, 250, 1),
                                  fontSize: 12.sp,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Device is Online',
                                    style: GoogleFonts.workSans(
                                      textStyle: TextStyle(
                                          color: Color.fromRGBO(22, 23, 26, 1),
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w300),
                                    )),
                                Switch(
                                    value: light,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.
                                      setState(() {
                                        light = value;
                                      });
                                    })
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
            SizedBox(height: 80.0),
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
                        'Set a Schedule',
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
                            'Select Date',
                            style: GoogleFonts.workSans(
                              textStyle: TextStyle(
                                  color: Color.fromRGBO(242, 242, 255, 1),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w300),
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
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
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
                                selectedDateRange = DateTimeRange(
                                  start: dateTimeList[0],
                                  end: dateTimeList[1],
                                );
                              }
                              setState(
                                  () {}); // Update the display after selecting date range
                            },
                            child: Text(
                              "Select Date Range",
                              style: GoogleFonts.sora(
                                textStyle: TextStyle(
                                    color: Color.fromRGBO(242, 242, 255, 1),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (selectedDateRange != null)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Starts',
                                  style: GoogleFonts.workSans(
                                    textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Text(
                                  DateFormat('yy/MM/dd H:m')
                                      .format(selectedDateRange!.start),
                                  style: GoogleFonts.workSans(
                                    textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ends',
                                  style: GoogleFonts.workSans(
                                    textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                Text(
                                  DateFormat('yy/MM/dd H:m')
                                      .format(selectedDateRange!.end),
                                  style: GoogleFonts.workSans(
                                    textStyle: TextStyle(
                                        color: Color.fromRGBO(242, 242, 255, 1),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      else
                        Text(
                          'No date range selected',
                          style: GoogleFonts.workSans(
                            textStyle: TextStyle(
                                color: Color.fromRGBO(242, 242, 255, 1),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w300),
                          ),
                        )
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
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
                          'Submit',
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
                  Divider()
                ],
              ),
            )
          ],
        )
      ]),
    );
  }
}
