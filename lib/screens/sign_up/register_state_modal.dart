
class RegisterState {
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final bool isLoading;
  final String? error;
  final bool isRegistered;

  RegisterState({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    this.isLoading = false,
    this.error,
    this.isRegistered = false,
  });

  RegisterState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNumber,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    String? error,
    bool? isRegistered,
  }) {
    return RegisterState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isRegistered: isRegistered ?? this.isRegistered,
    );
  }
}
