import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitr/models/User.dart';
import 'package:fitr/modules/store_modules/store_drawer/chat/ChatDetailsDetails.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  static const routeName = "/chats";

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        //cubit.getFriends();
        return Scaffold(
          appBar: buildAppBar(title: "المحادثات"),
          body: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .collection('friends')
                    .snapshots(),
                builder: (cx, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                      child: Text(
                        "لا يوجد محادثات",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  final friends = snapshot.data!.docs;
                  return Expanded(
                    child: ListView.separated(
                      itemCount: friends.length,
                      separatorBuilder: (cx, _) => Container(height: 10),
                      itemBuilder: (cx, index) {
                        UserM user = UserM.fromJson(json: friends[index].data());

                        return ListTile(
                          title: Text(
                            user.name,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          subtitle: Text(
                            user.address,
                            textAlign: TextAlign.end,
                          ),
                          trailing: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/fitr_pic8.png'),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDetailsScreen(
                                  user,
                                  'assets/images/fitr_pic8.png',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }
}
