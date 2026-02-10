class VerifyOtpResponse {
  final bool success;
  final int? customerId;
  final String? message;
  final String? error;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? customer;

  VerifyOtpResponse({
    required this.success,
    this.customerId,
    this.message,
    this.error,
    this.accessToken,
    this.refreshToken,
    this.customer,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      success: json['success'] ?? false,
      customerId: json['customerId'],
      message: json['message'],
      error: json['error'],
      // Support both camelCase and snake_case keys from API
      accessToken: json['accessToken'] ?? json['access_token'],
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      customer: json['customer'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['customer'])
          : null,
    );
  }
}

