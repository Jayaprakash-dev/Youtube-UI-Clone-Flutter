// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yt_ui_clone/app/home_screen/bloc/home_bloc.dart';
import 'package:yt_ui_clone/config/app_routes.dart';
import 'package:yt_ui_clone/service_locator.dart';

void main() {
  loadDependencies();
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = BlocDelegate();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: services.allReady(),
      builder: (context, snapshot) {

        if (snapshot.hasData) {
          return BlocProvider<HomeBloc>(
            create: (context) => services()..add(AppStarted()),
            child: ScreenUtilInit(
              designSize: const Size(430.0, 932.0),
              builder: (BuildContext context, Widget? child) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  onGenerateRoute: AppRoutes.onGenerateRoutes,
                );
              },
            ),
          );
        }

        else {
          return const Center(child: CircularProgressIndicator(color: Colors.red));
        }
      }
    );
  }
}

class BlocDelegate extends BlocObserver {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }
}