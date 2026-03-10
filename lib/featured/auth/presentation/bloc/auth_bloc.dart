import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/hive_storage_service.dart';
import '../../data/models/session_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final HiveStorageService _storageService;

  AuthBloc({required HiveStorageService storageService})
    : _storageService = storageService,
      super(AuthState.initial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<SignUpEvent>(_onSignUp);
    on<LogoutEvent>(_onLogout);
    on<AutoLoginEvent>(_onAutoLogin);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthState.loading());

    try {
      final isLoggedIn = _storageService.isLoggedIn();

      if (isLoggedIn) {
        final session = _storageService.getSession();

        if (session != null) {
          // Check if session is still valid (optional)
          final now = DateTime.now();
          final difference = now.difference(session.loginTime);

          // Auto-logout after 30 days (optional)
          if (difference.inDays > 30) {
            await _storageService.clearSession();
            emit(AuthState.unauthenticated());
          } else {
            emit(AuthState.authenticated(session));
          }
        } else {
          emit(AuthState.unauthenticated());
        }
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error('Failed to check auth status: ${e.toString()}'));
    }
  }

  Future<void> _onAutoLogin(
    AutoLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final session = _storageService.getSession();

    if (session != null) {
      emit(AuthState.authenticated(session));
    } else {
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());

    try {
      await Future.delayed(Duration(seconds: 2));

      // Simulated successful login
      final session = SessionModel(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
        username: event.username,
        token: 'token_${DateTime.now().millisecondsSinceEpoch}',
        loginTime: DateTime.now(),
      );

      // Save session to local storage
      final saved = await _storageService.saveSession(session);

      if (saved) {
        emit(AuthState.authenticated(session));
      } else {
        emit(AuthState.error('Failed to save session'));
      }
    } catch (e) {
      emit(AuthState.error('Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());

    try {
      await Future.delayed(Duration(seconds: 2));

      // Simulated successful signup
      final session = SessionModel(
        userId: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: event.email,
        username: event.username,
        token: 'token_${DateTime.now().millisecondsSinceEpoch}',
        loginTime: DateTime.now(),
      );

      // Save session to local storage
      final saved = await _storageService.saveSession(session);

      if (saved) {
        emit(AuthState.authenticated(session));
      } else {
        emit(AuthState.error('Failed to save session'));
      }
    } catch (e) {
      emit(AuthState.error('Sign up failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthState.loading());

    try {
      // Clear local storage
      await _storageService.clearSession();

      emit(AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.error('Logout failed: ${e.toString()}'));
    }
  }
}
