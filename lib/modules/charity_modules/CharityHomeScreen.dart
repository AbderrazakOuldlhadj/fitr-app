import 'package:fitr/modules/charity_modules/CharityAddNeeds.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:flutter/material.dart';

import 'charity_drawer/CharityDrawer.dart';
class CharityHomeScreen extends StatelessWidget {
  
  static const routeName="/charityHome";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: buildAppBar(
            title: "فِطر",
          ),
          drawer: Drawer(
            child: CharityDrawer(),
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
              Navigator.pushNamed(
                context,
                CharityAddNeeds.routeName,
                
              );
            },
            icon: Icon(Icons.add),
            label: Text("إضافة طلب"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
  }
}