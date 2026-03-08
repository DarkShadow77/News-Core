import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeChanged>((event, emit) {
      emit(event.isDark ? ThemeMode.dark : ThemeMode.light);
    });
  }

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final isDark = json['isDark'] as bool?;
    return (isDark ?? false) ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    return {'isDark': state == ThemeMode.dark};
  }
}
