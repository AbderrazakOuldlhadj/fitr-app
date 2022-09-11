import 'package:fitr/modules/store_modules/AddPersonneScreen.dart';
import 'package:fitr/modules/store_modules/store_drawer/AppDrawer.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin{


  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).unfocus();
    //final size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(
            title: "فِطر",
          ),
          drawer: Drawer(
            child: AppDrawer(),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*Text(
                  "ما نقصَ مالٌ مِن صدقة",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),*/
                SizedBox(height: 30),
                Image.asset("assets/images/zakatHomeScreen.png"),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AddPersonneScreen.routeName,
                (Route<dynamic> route) => false,
              );
            },
            icon: Icon(Icons.add),
            label: Text("إضافة إخراج"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      },
    );
  }
}
