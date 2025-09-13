import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/di/injection_container.dart' as di;
import '../core/theme/app_theme.dart';
import '../core/routes/app_router.dart';
import '../presentation/auth/bloc/auth_bloc.dart';
import '../presentation/theme/bloc/theme_bloc.dart';

class SmartShebaApp extends StatelessWidget {
  const SmartShebaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => di.sl<ThemeBloc>()..add(LoadThemeEvent()),
        ),
        BlocProvider<AuthBloc>(
          create: (context) => di.sl<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'SmartSheba',
            debugShowCheckedModeBanner: false,
            
            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState is ThemeLoaded 
                ? themeState.themeMode 
                : ThemeMode.system,
            
            // Localization
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('bn', 'BD'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            
            // Navigation
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}
