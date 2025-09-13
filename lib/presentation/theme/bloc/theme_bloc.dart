import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/usecases/theme_usecases.dart';

// Events
abstract class ThemeEvent extends Equatable {
  const ThemeEvent();
  
  @override
  List<Object> get props => [];
}

class LoadThemeEvent extends ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;
  
  const SetThemeEvent({required this.themeMode});
  
  @override
  List<Object> get props => [themeMode];
}

// States
abstract class ThemeState extends Equatable {
  const ThemeState();
  
  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;
  
  const ThemeLoaded({required this.themeMode});
  
  @override
  List<Object> get props => [themeMode];
}

// BLoC
class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final ThemeUsecases _themeUsecases;

  ThemeBloc({required ThemeUsecases themeUsecases})
      : _themeUsecases = themeUsecases,
        super(ThemeInitial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final themeMode = await _themeUsecases.getThemeMode();
      emit(ThemeLoaded(themeMode: themeMode));
    } catch (e) {
      emit(const ThemeLoaded(themeMode: ThemeMode.system));
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final newThemeMode = currentState.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      
      await _themeUsecases.setThemeMode(newThemeMode);
      emit(ThemeLoaded(themeMode: newThemeMode));
    }
  }

  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    await _themeUsecases.setThemeMode(event.themeMode);
    emit(ThemeLoaded(themeMode: event.themeMode));
  }
}