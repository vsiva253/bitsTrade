import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'profile_modal.dart';
import '../../utils/constants.dart';
import '../../utils/shared_prefs.dart';
import '../../widgets/custom_toast.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, UserProfile>((ref) {
  return ProfileNotifier();
});

class ProfileNotifier extends StateNotifier<UserProfile> {
  ProfileNotifier() : super(UserProfile());

  final Dio _dio = Dio();

  Future<void> getCurrentUser() async {
    var token = await SharedPrefs.getToken();
    if (kDebugMode) {
      print('token is $token');
    }

    try {
      final response = await _dio.get(
        '${Constants.apiBaseUrl}/api/v1/user/current',
        options: Options(headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token'

          // Add authorization headers if needed
        }),
      );
      if (kDebugMode) {
        print(response.data);
      }

      if (response.statusCode == 200) {
        final data = response.data;
        if (kDebugMode) {
          print('pf data ${response.data}');
        }
        state = UserProfile.fromJson(data['data']);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      showToast('something went wrong');
      // throw Exception('Failed to load user profile: $e');
    }
  }

  Future<void> updateUserProfile(UserProfile updatedProfile) async {
    var token = await SharedPrefs.getToken();
    try {
      final response = await _dio.put(
        '${Constants.apiBaseUrl}/api/v1/user/update',
        data: updatedProfile.toJson(),
        options: Options(headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
          // Add authorization headers if needed
        }),
      );

      if (response.statusCode == 200) {
        showToast(
          'Profile updated successfully',
        );
        // Handle response if needed
      } else if (response.statusCode == 422) {
        showToast('Validation Error: ${response.data['detail']}');
        throw Exception('Validation Error: ${response.data['detail']}');
      } else {
        showToast('Failed to update user profile');
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      showToast('something went wrong');
      throw Exception('Failed to update user profile: $e');
    }
  }
}
