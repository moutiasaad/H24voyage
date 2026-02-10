class LoginResponse {
  final bool success;
  final String? message;
  final int? customerId;
  final bool requiresOTP;

  LoginResponse({
    required this.success,
    this.message,
    this.customerId,
    required this.requiresOTP,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      customerId: json['customerId'],
      requiresOTP: json['requiresOTP'] ?? false,
    );
  }
}

