import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fitr/models/User.dart';
import 'package:fitr/modules/store_modules/store_drawer/chat/ChatsScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'chat/ChatDetailsDetails.dart';

class AllNeeds extends StatelessWidget {
  static const routeName = '/allNeeds';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);

        return Scaffold(
          appBar: buildAppBar(title: "الطلبات", actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ChatsScreen.routeName);
              },
              icon: Icon(FontAwesomeIcons.rocketchat),
            ),
            SizedBox(width: 5),
          ]),
          body:RefreshIndicator(
            onRefresh: () async {
              cubit.getAllNeeds();
              cubit.getAllUsers();
            },
            child: ConditionalBuilder(
              condition: cubit.allNeeds.length > 0,
              fallback: (context) => Center(child: CircularProgressIndicator()),
              builder: (context) {
                cubit.allNeeds.removeWhere((element) => element.data().isEmpty);



                return  ListView.separated(
                  itemCount: cubit.allNeeds.length,
                  separatorBuilder: (cx, _) => Container(
                    height: 10,
                  ),
                  itemBuilder: (cx, index) {
                    UserM user = cubit.getUserDetail(cubit.allNeeds[index].id);
                    Map<String, dynamic> needs = cubit.allNeeds[index].data();
                    List<String> keys =
                    cubit.allNeeds[index].data().keys.toList();
                    return Card(
                      elevation: 10,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
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
                              child: Text(
                                "${user.name}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text("${user.address}"),
                            SizedBox(height: 20),
                            Table(
                              border: TableBorder.all(),
                              textDirection: TextDirection.rtl,
                              children: [
                                ...keys.map((e) {
                                  return buildTableRow(cells: [
                                    "${cubit.sinf.firstWhere((element) => element['idSinf'] == e)['nameSinf']}",
                                    "${needs[e]}"
                                  ]);
                                }).toList(),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ) ,
        );
      },
    );
  }

}
