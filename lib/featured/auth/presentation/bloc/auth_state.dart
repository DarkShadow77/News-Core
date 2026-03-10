part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final SessionModel? session;
  final String? errorMessage;

  const AuthState({required this.status, this.session, this.errorMessage});

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading);
  }

  factory AuthState.authenticated(SessionModel session) {
    return AuthState(status: AuthStatus.authenticated, session: session);
  }

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  factory AuthState.error(String message) {
    return AuthState(status: AuthStatus.error, errorMessage: message);
  }

  AuthState copyWith({
    AuthStatus? status,
    SessionModel? session,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: session ?? this.session,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, session, errorMessage];
}
