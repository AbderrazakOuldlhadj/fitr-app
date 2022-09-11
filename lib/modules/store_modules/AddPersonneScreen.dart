import 'package:fitr/modules/store_modules/AsnafScreen.dart';
import 'package:fitr/modules/store_modules/MainScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPersonneScreen extends StatelessWidget {
  static final routeName = '/add';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    /* final size = MediaQuery
        .of(context)
        .size; */
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext ctx, AppStates state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushReplacementNamed(context, MainScreen.routeName);
            return true;
          },
          child: Scaffold(
            appBar: buildAppBar(
              title: "معلومات حول المُزكِّي",
              leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, MainScreen.routeName);
                },
              ),
            ),
            body: Center(
              child: SingleChildScrollView(
                reverse: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          AssetImage('assets/images/fitr_pic8.png'),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            Text(
                              "عدد الأفراد",
                              style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.4),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    offset: Offset(2, 5),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () => cubit.subPersonne(),
                                    child: CircleAvatar(
                                      child: Icon(FontAwesomeIcons.minus),
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    foregroundColor: Colors.white,
                                    child: Text(
                                      '${cubit.nbPersonneTotal}',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => cubit.addPersonne(),
                                    child: CircleAvatar(
                                      child: Icon(FontAwesomeIcons.plus),
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            //SizedBox(height: 10),
                            /* Text(
                              "الإسم",
                              style: TextStyle(fontSize: 30),
                            ), */
                            /*TextFormField(
                              controller: cubit.name,
                              validator: (val) {
                                if (val!.isEmpty)
                                  return "يجب أن يكون هذا الحقل غير فارغٍ";
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: "إسم المُزكِّي",
                                prefixIcon: Icon(FontAwesomeIcons.user),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),*/
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    offset: Offset(2, 5),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    primary: Theme.of(context).primaryColor),
                                child: Padding(
                                  padding: confirmedButtonPadding(),
                                  child: Text("تم",
                                      style: TextStyle(
                                        fontSize: 25,
                                      )),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    Navigator.pushReplacementNamed(
                                        context, AsnafScreen.routeName);
                                    print("valid");
                                  } else
                                    print("not valid");
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
