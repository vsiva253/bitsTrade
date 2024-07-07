import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'register_state_modal.dart';
import '../../utils/constants.dart';
import 'dart:convert';

import '../../widgets/custom_toast.dart';


final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier()
      : super(RegisterState(
          firstName: '',
          lastName: '',
          email: '',
          phoneNumber: '',
          password: '',
          confirmPassword: '',
        ));

  void setFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void setLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setConfirmPassword(String confirmPassword) {
    state = state.copyWith(confirmPassword: confirmPassword);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void registerSuccess(bool isRegistered) {
    state = state.copyWith(isRegistered: isRegistered);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  Future<void> register() async {
    setLoading(true);
    setError(null);

    // Basic validation
    if (state.firstName.isEmpty ||
        state.lastName.isEmpty ||
        state.email.isEmpty ||
        state.phoneNumber.isEmpty ||
        state.password.isEmpty ||
        state.confirmPassword.isEmpty) {
      setLoading(false);
      showToast('Please fill in all fields.');
      return;
    }

    // Validate email format
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(state.email)) {
      setLoading(false);
      showToast('Please enter a valid email address.');
      return;
    }

    // Check if passwords match
    if (state.password != state.confirmPassword) {
      setLoading(false);
      showToast('Passwords do not match.');
      return;
    }

    try {
      const apiUrl = '${Constants.apiBaseUrl}/api/v1/auth/register';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'accept': 'application/json','Content-Type': 'application/json'},
        body: jsonEncode({
          'name': '${state.firstName} ${state.lastName}',
          'email': state.email,
          'phone': state.phoneNumber,
          'password': state.password,
        }),
      );
      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['status']['type'] == 'success') {
          setLoading(false);
          registerSuccess(true);
          showToast('Registration Successful');
        } else {
          setLoading(false);
          setError('Registration failed: ${data['status']['message']}');
          registerSuccess(false);
          showToast('Registration failed: ${data['status']['message']}');
        }
      } else {
        setLoading(false);
        final body = jsonDecode(response.body);
        setError(body['status']['message'] ?? 'Registration failed');
        registerSuccess(false);
        showToast('Registration failed');
      }
    } catch (e) {
      setLoading(false);
      setError('Something Went Wrong');
      registerSuccess(false);
      showToast('Registration failed');
    }
  }


}
