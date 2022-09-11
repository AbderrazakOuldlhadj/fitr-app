import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitr/auth/LoginScreen.dart';
import 'package:fitr/modules/store_modules/store_drawer/AllNeeds.dart';
import 'package:fitr/modules/store_modules/store_drawer/AwzanScreen.dart';

import 'package:fitr/modules/store_modules/store_drawer/MuzakiScreen.dart';
import 'package:fitr/modules/store_modules/store_drawer/DisponibleScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat/ChatsScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        return SafeArea(
          child: Column(
            children: [
              Container(
                  height: 200,
                  child: Image.asset(
                    "assets/images/imageDrawer.png",
                    fit: BoxFit.cover,
                  )),
              SizedBox(height: 30),
              Divider(),
              buildDrawerItem(
                context,
                title: "الأوزان الكلية",
                icon: FontAwesomeIcons.balanceScale,
                onTap: () {
                  Navigator.of(context).pushNamed(AwzanScreen.routeName);
                },
              ),
              SizedBox(height: 10),
              buildDrawerItem(
                context,
                title: "المزكون",
                icon: FontAwesomeIcons.user,
                onTap: () {
                  Navigator.of(context).pushNamed(MuzakiScreen.routeName);
                },
              ),
              SizedBox(height: 10),
              buildDrawerItem(
                context,
                title: "تعديل",
                icon: FontAwesomeIcons.edit,
                onTap: () {
                  Navigator.of(context).pushNamed(DisponibleScreen.routeName);
                },
              ),
              Divider(),
              buildDrawerItem(context,
                  title: "الطلبات",
                  icon: FontAwesomeIcons.handHolding, onTap: () {
                Navigator.of(context).pushNamed(AllNeeds.routeName);
              }),
              SizedBox(height: 10),
              buildDrawerItem(
                context,
                title: "المحادثات",
                icon: FontAwesomeIcons.rocketchat,
                onTap: (){
                  
                  Navigator.of(context).pushNamed(ChatsScreen.routeName);
                }
              ),
              Divider(),
              ListTile(
                title: Text(
                  "خروج",
                  style: TextStyle(color: Colors.red),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                onTap: () async {
                 // await MySharedPreferences.setLogin(true);
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
