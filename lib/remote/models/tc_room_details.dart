// lib/models/tc_room_details.dart

class JitsiDetails {
  final String token;
  final String room;
  final String email;
  final String name;

  JitsiDetails(
      {required this.token,
      required this.room,
      required this.email,
      required this.name});

  factory JitsiDetails.fromJson(Map<String, dynamic> json) {
    return JitsiDetails(
      token: json['token'],
      room: json['room'],
      email: json['email'],
      name: json['name'],
    );
  }
}

/**
 * 100ms auth token
 */
class HmsDetails {
  final String token;

  HmsDetails({required this.token});

  factory HmsDetails.fromJson(Map<String, dynamic> json) {
    return HmsDetails(token: json['token']);
  }
}
