// lib/features/auth/data/models/session_model.dart
import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final String userId;
  final String email;
  final String username;
  final String? token;
  final DateTime loginTime;

  const SessionModel({
    required this.userId,
    required this.email,
    required this.username,
    this.token,
    required this.loginTime,
  });

  // Convert to Map for Hive storage
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'username': username,
      'token': token,
      'loginTime': loginTime.toIso8601String(),
    };
  }

  // Create from Map from Hive storage
  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      userId: map['userId'] as String,
      email: map['email'] as String,
      username: map['username'] as String,
      token: map['token'] as String?,
      loginTime: DateTime.parse(map['loginTime'] as String),
    );
  }

  @override
  List<Object?> get props => [userId, email, username, token, loginTime];
}
