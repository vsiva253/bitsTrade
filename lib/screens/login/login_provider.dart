


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../utils/constants.dart';
import '../../utils/shared_prefs.dart';
import 'dart:convert';
import '../../widgets/custom_toast.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});

class LoginState {
  final String email;
  final String password;
  final bool isLoading;
  final String? error;
  final bool isLogin;
  final String? token;

  LoginState({
    required this.email,
    required this.password,
    this.isLoading = false,
    this.error,
    this.isLogin = false,
    this.token,
  });

  LoginState copyWith({
    String? email,
    String? password,
    bool? isLoading,
    String? error,
    bool? isLogin,
    String? token,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isLogin: isLogin ?? this.isLogin,
      token: token ?? this.token,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState(email: '', password: ''));

  void setEmail(String email) {
    state = state.copyWith(email: email);
  }

  void setPassword(String password) {
    state = state.copyWith(password: password);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void setToken(String? token) {
    state = state.copyWith(token: token);
  }

  Future<void> login(BuildContext context) async {
    setLoading(true);
    setError(null);

    // Check if email and password are empty
    if (state.email.isEmpty || state.password.isEmpty) {
      setLoading(false);
      showToast('Please enter both your email and password.');
      setError('Please enter both your email and password.');
      return; // Stop the function if fields are empty
    }

    try {
      const apiUrl = '${Constants.apiBaseUrl}/api/v1/auth/login';
print('${state.email},${state.password}');
print(apiUrl);

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': state.email, 'password': state.password}),
      );
   

      print(response.statusCode);

      if (response.statusCode == 200) {

      
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('data') && data['data'] is Map) {
          print('yes');
            showToast('Login Successful');
          final token = data['data']['token'];
          await SharedPrefs.saveToken(token);

          // await SharedPrefs.getTokenTimestamp();
          // final prefs = await SharedPreferences.getInstance();
          // await prefs.setString('authToken', token);
          setToken(token);
          state = state.copyWith(isLogin: true);
          context.go('/home');
        } else {
          print('Token Not Found');
    
          setError('Invalid API response: Token not found');
               showToast('Invalid API response: Token not found');

        }
      } else {
        print('whoa no');
        
      
        final body = jsonDecode(response.body);
        setError(body['message'] ?? 'Login failed');
         showToast('Please Enter Valid Email and Password');
      }
    } catch (e) {
      print(e.toString());
      print('hell f');
        showToast('An error occurred, Please try again');
      setError('An error occurred, Please try again');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> isLoggedIn() async {
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('authToken');
    final token = await SharedPrefs.getToken();
    return token != null;
  }

  Future<void> logout() async {
    SharedPrefs.remove('authToken');
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('authToken');
    setToken(null);
    state = state.copyWith(isLogin: false);
  }
    void clearError() {
    setError(null);
  }
}

