import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const hostConn = 'https://eyebaituna.000webhostapp.com';
  static const hostConnUser = '$hostConn/user';
  static const validateEmail = '$hostConn/validate_email.php';
  static const signup = '$hostConn/register.php';
  static const login = '$hostConn/login.php';
  static const banURLS = '$hostConn/ban_urls.php';
  static const updateUser = '$hostConn/edit_user.php';
  static const deviceConnection = '$hostConn/connected_devices.php';
  static const userSchedule = '$hostConn/user_schedule.php';
  static const internetSwitchURL = '$hostConn/internet_switch.php';
  static const visitedWebsitesURL = '$hostConn/visited_websites.php';

  static Future<List<String>> fetchBannedURLs(int userId) async {
    try {
      final response = await http.get(Uri.parse('$banURLS?user_id=$userId'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final List<String> bannedURLs = [];
          for (var url in data['urls']) {
            bannedURLs.add(url);
          }
          return bannedURLs;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch banned URLs');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> updateUserProfile({
    required int id,
    required String username,
    required String email,
    String? pincode,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(updateUser),
        body: {
          'id': id.toString(),
          'username': username,
          'email': email,
          'pincode': pincode ?? '',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'];
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

// Fetch visited websites for logged-in user
  static Future<List<Map<String, dynamic>>> fetchVisitedWebsites(
      int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$visitedWebsitesURL?user_id=$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          final List<Map<String, dynamic>> visitedWebsites = [];
          for (var website in data['visited_websites']) {
            visitedWebsites.add({
              'link': website['link'],
              'visit_time': website['visit_time'],
              'category_name': website['category_name']
            });
          }
          return visitedWebsites;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch visited websites');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> addBandwidthToDevice({
    required int deviceId,
    required int bandwidth,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(deviceConnection),
        body: {
          'device_id': deviceId.toString(),
          'bandwidth': bandwidth.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Bandwidth has been added to the device successfully
          return;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to add bandwidth to the device');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<Device>> fetchDevices(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$deviceConnection?user_id=$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          final List<Device> devices = [];
          for (var device in data['devices']) {
            devices.add(Device.fromJson(device));
          }
          return devices;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception(
            'Failed to fetch devices. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // fetch user schedule dates
  static Future<DateTimeRange?> fetchSchedule(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$userSchedule?user_id=$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success']) {
          final String startDateStr = data['start_date'];
          final String endDateStr = data['end_date'];

          final DateTime startDate = DateTime.parse(startDateStr);
          final DateTime endDate = DateTime.parse(endDateStr);

          return DateTimeRange(start: startDate, end: endDate);
        } else {
          return null; // No schedule found, return null
        }
      } else {
        throw Exception(
            'Failed to fetch schedule dates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch schedule dates: $e');
    }
  }

  // update user schedule dates
  static Future<void> updateUserScheduleDates({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(userSchedule),
        body: {
          'user_id': userId.toString(),
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Schedule has been assigned or updated successfully
          return;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to assign or update schedule');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

// create a new schedule
  static Future<void> assignSchedule({
    required int userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(userSchedule),
        body: {
          'user_id': userId.toString(),
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          // Schedule has been assigned or updated successfully
          return;
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to assign or update schedule');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<InternetSwitch> fetchInternetSwitchStatus(int userId) async {
    try {
      final response =
          await http.get(Uri.parse('$internetSwitchURL?user_id=$userId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          final String switchStatus = data['switch_status'];
          final int switchValue = data['switch_value'];
          return InternetSwitch(
              userId: userId,
              switchStatus: switchStatus,
              switchValue: switchValue);
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch internet switch status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> createInternetSwitchStatus({
    required int userId,
    required String switchStatus,
    required int switchValue,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(internetSwitchURL),
        body: {
          'user_id': userId.toString(),
          'switch_status': switchStatus,
          'switch_value': switchValue.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to create internet switch status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<void> updateInternetSwitchStatus({
    required int userId,
    required String switchStatus,
    required int switchValue,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$internetSwitchURL/$userId'),
        body: {
          'switch_status': switchStatus,
          'switch_value': switchValue.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to update internet switch status');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Add a URL to the banned list
  static Future<void> blockURL(int userId, String url) async {
    try {
      final response = await http.post(
        Uri.parse(banURLS),
        body: {
          'url': url,
          'user_id': userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data['success']) {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to block URL');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class Device {
  final int id;
  final String name;
  final int? bandwidthLimit;

  Device({
    required this.id,
    required this.name,
    this.bandwidthLimit,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      name: json['device_name'],
      bandwidthLimit: json['bandwidth_limit'],
    );
  }
}

class InternetSwitch {
  final int userId;
  final String switchStatus;
  final int switchValue;

  InternetSwitch({
    required this.userId,
    required this.switchStatus,
    required this.switchValue,
  });
}
