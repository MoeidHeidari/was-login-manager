import 'dart:io';

import 'package:aws_login_manager/presentation/aws_login_manager_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart'; // Import provider for theme management
import 'core/theme_context.dart';
import 'data/aws_login_manger_repository_impl.dart';
import 'data/local_storage_datasource.dart';
import 'presentation/aws_login_manager_bloc.dart';
import 'presentation/pages/home_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  windowManager.setResizable(false);

  WindowOptions windowOptions = const WindowOptions(
    size: Size(400, 800),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  final dataSource = LocalStorageDataSource();
  final repository = AwsLoginManagerRepositoryImpl(dataSource);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Apothems(),
        ),
      ],
      child: BlocProvider<AwsLoginManagerBloc>(
        create: (context) => AwsLoginManagerBloc(repository)
          ..add(LoadProfilesEvent(isSSO: false)),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AWS Login Manager',

      home: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Provider.of<Apothems>(context).currentTheme == AppTheme.dark ? const Color.fromARGB(255, 33, 33, 33):const Color.fromARGB(255, 255, 255, 255), // Thin white border
              width: 2.0, // Adjust thickness here
            ),
          ),
          child: HomePage(),
        ),
      ),
    );
  }
}
