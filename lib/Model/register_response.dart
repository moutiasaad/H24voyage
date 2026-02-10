class RegisterResponse {
  final bool success;
  final String message;
  final String? expiresIn;
  final DateTime? pendingExpiration;

  RegisterResponse({
    required this.success,
    required this.message,
    this.expiresIn,
    this.pendingExpiration,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      expiresIn: json['expiresIn'],
      pendingExpiration: json['pendingExpiration'] != null
          ? DateTime.parse(json['pendingExpiration'])
          : null,
    );
  }

  bool get isOtpSent => success == true;

  bool get isPendingRegistration =>
      success == false && pendingExpiration != null;
}
