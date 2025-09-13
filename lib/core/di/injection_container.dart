// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/theme_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/theme_usecases.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/theme/bloc/theme_bloc.dart';
import '../network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - BLoCs
  sl.registerFactory(
    () => AuthBloc(authUsecases: sl()),
  );
  sl.registerFactory(
    () => ThemeBloc(themeUsecases: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AuthUsecases(authRepository: sl()));
  sl.registerLazySingleton(() => ThemeUsecases(themeRepository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ThemeRepository>(
    () => ThemeRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    // Use Mock for development, switch to Impl when backend is ready
    () => AuthRemoteDataSourceMock(),
    // () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ThemeLocalDataSource>(
    () => ThemeLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => Connectivity());
}
