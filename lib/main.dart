import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:todo_app/bloc_observer.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/share/bloc/db_cubit.dart';

Future main() async{
  Bloc.observer = MyBlocObserver();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.remove();
  await initilization(null);
  runApp(MyApp());
}

Future initilization(context) async{
  await Future.delayed(Duration(seconds: 5));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Tasks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          useMaterial3: true
      ),
      home: BlocProvider(
        create: (context) => DbCubit(),
        child: HomePage(),
      ),
    );
  }
}