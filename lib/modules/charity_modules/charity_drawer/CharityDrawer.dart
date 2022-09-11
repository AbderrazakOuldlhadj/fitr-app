import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitr/auth/LoginScreen.dart';
import 'package:fitr/modules/charity_modules/charity_drawer/MyNeeds.dart';
import 'package:fitr/modules/store_modules/store_drawer/chat/ChatsScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CharityDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Center(
            child: Container(
              height: 200,
              child: Image.asset(
                "assets/images/imageDrawer.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 30),
          Divider(),
          ListTile(
            title: Text(
              "طلباتي",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Icon(
              FontAwesomeIcons.handHolding,
              //color: Colors.red,
            ),
            onTap: () async {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(MyNeeds.routeName);
            },
          ),
          SizedBox(height: 10),
          buildDrawerItem(context,
              title: "المحادثات", icon: FontAwesomeIcons.rocketchat, onTap: () {

            Navigator.of(context).pushNamed(ChatsScreen.routeName);
          }),
          Divider(),
          ListTile(
            title: Text(
              "خروج",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onTap: () async {
              //await MySharedPreferences.setLogin(true);
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
