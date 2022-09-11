import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitr/models/Message.dart';
import 'package:fitr/models/User.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  static const routeName = "/chat";
  final String imgUrl;
  final UserM receiverUser;

  ChatDetailsScreen(this.receiverUser, this.imgUrl);

  var messageController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _currentUser = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    print("receive= ${receiverUser.uId}");
    print("send= ${_currentUser!.uid}");
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {
        /*if (state is AddFriendSuccessState)
              AppCubit.getObject(ctx).getFriends();*/
      },
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: AssetImage(imgUrl),
                ),
                SizedBox(width: 15),
                Text(receiverUser.name),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(_currentUser!.uid)
                      .collection('chats')
                      .doc(receiverUser.uId)
                      .collection('messages')
                      .orderBy('dateTime')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: CircularProgressIndicator());
                    final messages = snapshot.data!.docs.reversed.toList();
                    return Expanded(
                      child: ListView.separated(
                        reverse: true,
                        itemCount: messages.length,
                        separatorBuilder: (cx, _) => SizedBox(height: 15.0),
                        itemBuilder: (cx, index) {
                          var message =
                              Message.fromJson(json: messages[index].data());
                          if (message.receiverId != receiverUser.uId)
                            return messageReceiver(message.text);

                          return myMessage(message.text);
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: TextFormField(
                            controller: messageController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "   اكتب رسالة",
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        minWidth: 1.0,
                        child: Icon(
                          Icons.send,
                          size: 40,
                        ),
                        onPressed: () {
                          cubit.sendMessage(
                            receiverId: receiverUser.uId,
                            text: messageController.text,
                            dateTime: DateTime.now().toString(),
                          );
                          //messageController.clear();
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget myMessage(String message) => BubbleSpecialThree(
        text: message,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        color: Colors.blue,
      );

  Widget messageReceiver(String message) => BubbleSpecialThree(
        text: message,
        textStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        color: Colors.blueGrey,
        isSender: false,
      );
}
