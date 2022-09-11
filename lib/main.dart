import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fitr/auth/LoginScreen.dart';
import 'package:fitr/modules/charity_modules/CharityAddNeeds.dart';
import 'package:fitr/modules/charity_modules/CharityHomeScreen.dart';
import 'package:fitr/modules/charity_modules/charity_drawer/MyNeeds.dart';
import 'package:fitr/modules/store_modules/store_drawer/AllNeeds.dart';
import 'package:fitr/modules/store_modules/store_drawer/chat/ChatsScreen.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/store_modules/store_drawer/AwzanScreen.dart';
import 'modules/store_modules/store_drawer/MuzakiScreen.dart';
import 'modules/store_modules/MainScreen.dart';
import 'modules/store_modules/AddPersonneScreen.dart';
import 'modules/store_modules/AsnafScreen.dart';
import 'modules/store_modules/store_drawer/DisponibleScreen.dart';
import 'shared/cubit/cubit.dart';
import 'shared/cubit/states.dart';
import 'shared/cubit/bloc_observer.dart';
import 'models/MySharedPrefrences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await MySharedPreferences.init();
  print("main getLogin= ${MySharedPreferences.getType()}");

  Bloc.observer = MyBlocObserver();

  runApp(
    BlocProvider(
      create: (ctx) {
        return AppCubit()
          ..createDatabase()
          ..getNeeds()
          ..getAllNeeds()
          ..getAllUsers();
      },
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (ctx, state) {},
        builder: (ctx, state) {
          AppCubit cubit = AppCubit.getObject(ctx);
          if (state is CreateDatabaseState) {
            cubit.getDataFromDatabase(cubit.myDb!);
            //cubit.getNeeds();
          }

          return MyApp();
        },
      ),
    ),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();



class MyApp extends StatelessWidget {

  final _auth=FirebaseAuth.instance;

Widget homeScreenStore(bool parameter){
  if(parameter)
    return DisponibleScreen() ;
  return MainScreen();
}

Widget homeScreen(String parameter){
  if(parameter=='al')
    return homeScreenStore(MySharedPreferences.getFirstTime());
  return CharityHomeScreen() ;
}

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff204254) /* Color.fromRGBO(21, 30, 61, 1) */,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Color(0xff204254),
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xff204254)),
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
      ),
      home: _auth.currentUser==null ? LoginScreen(): homeScreen(MySharedPreferences.getType()),

      routes: {
        AwzanScreen.routeName: (context) => AwzanScreen(),
        MuzakiScreen.routeName: (context) => MuzakiScreen(),
        AddPersonneScreen.routeName: (context) => AddPersonneScreen(),
        AsnafScreen.routeName: (context) => AsnafScreen(),
        MainScreen.routeName: (context) => MainScreen(),
        DisponibleScreen.routeName: (context) => DisponibleScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        CharityHomeScreen.routeName: (context) => CharityHomeScreen(),
        CharityAddNeeds.routeName: (context) => CharityAddNeeds(),
        MyNeeds.routeName: (context) => MyNeeds(),
        AllNeeds.routeName: (context) => AllNeeds(),
        ChatsScreen.routeName: (context)=>ChatsScreen(),
      },
    );
  }
}
