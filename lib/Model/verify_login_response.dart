class VerifyLoginResponse {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;
  final Map<String, dynamic>? customer;

  VerifyLoginResponse({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
    this.customer,
  });

  factory VerifyLoginResponse.fromJson(Map<String, dynamic> json) {
    return VerifyLoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      // Support both camelCase and snake_case keys coming from API
      accessToken: json['accessToken'] ?? json['access_token'],
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      customer: json['customer'] is Map<String, dynamic> ? Map<String, dynamic>.from(json['customer']) : null,
    );
  }
}
