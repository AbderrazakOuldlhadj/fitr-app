import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fitr/models/MySharedPrefrences.dart';
import 'package:fitr/modules/charity_modules/CharityHomeScreen.dart';
import 'package:fitr/modules/store_modules/MainScreen.dart';
import 'package:fitr/modules/store_modules/store_drawer/DisponibleScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/User.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  bool isObscure = true;

  final formKey = GlobalKey<FormState>();

  TextEditingController name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController address = new TextEditingController();

  String? uId;

  int selectedValueRadio = 0;

  Duration _duration = Duration(milliseconds: 700);

  void _clearData() {
    name.clear();
    email.clear();
    password.clear();
    address.clear();
    setState(() {
      isLogin = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color selectedColor = Theme.of(context).primaryColor;
    Color unselectedColor = Colors.grey;
    bool isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        return SafeArea(
          // we've wraped the scaffold with GestureDetector for hide the keyBoard on tap
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              body: SingleChildScrollView(
                reverse: isKeyboard,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 150,
                          child: Image.asset("assets/images/market.png"),
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(
                        isLogin ? "تسجيل الدخول" : "إنشاء حساب",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                      Visibility(
                        visible: !isLogin,
                        replacement: Container(),
                        child: storeOrCharity(selectedColor, unselectedColor),
                      ),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: AnimatedContainer(
                          padding: EdgeInsets.all(5),
                          duration: _duration,
                          curve: Curves.bounceOut,
                          //205,335/265,450
                          height: isLogin ? 220 : 350,
                          //color: Colors.red.withOpacity(0.5),
                          child: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: !isLogin,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "الاسم",
                                        prefixIcon: Icon(Icons.perm_identity),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      controller: name,
                                      validator: (val) {
                                        if (val!.isEmpty)
                                          return "يجب أن يكون هذا الحقل غير فارغٍ";
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Visibility(
                                    visible: !isLogin,
                                    replacement: Container(),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "العنوان",
                                        prefixIcon: Icon(Icons.location_on),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      controller: address,
                                      validator: (val) {
                                        if (val!.isEmpty)
                                          return "يجب أن يكون هذا الحقل غير فارغٍ";
                                        return null;
                                      },
                                    ),
                                  ),
                                  if (!isLogin) SizedBox(height: 10),
                                  TextFormField(
                                    controller: email,
                                    validator: (val) {
                                      return emailValidator(val!);
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: emailDecoration(),
                                  ),
                                  SizedBox(height: 10),
                                  TextFormField(
                                    // initialValue: "azerty",

                                    controller: password,
                                    obscureText: isObscure,
                                    validator: (val) {
                                      return passwordValidator(val!);
                                    },
                                    decoration: passwordDecoration("كلمة السر"),
                                  ),
                                  SizedBox(height: 10),
                                  state is AuthLoadingState
                                      ? CircularProgressIndicator()
                                      : ElevatedButton(
                                          style: styleConfirmedButton(context),
                                          child: Padding(
                                            padding: confirmedButtonPadding(),
                                            child: Text(
                                              "تم",
                                              style: TextStyle(fontSize: 25),
                                            ),
                                          ),
                                          onPressed: () async {
                                            FocusScope.of(context)
                                                .unfocus(); //// for hide keyboard
                                            if(!await cubit.checkConnexion()){
                                              showToast(msg: "تحقق من وجود الانترنت");
                                              return ;
                                            }

                                            if (formKey.currentState!
                                                .validate()) {
                                              if (isLogin) {
                                                try {
                                                  cubit.emit(
                                                    AuthLoadingState(),
                                                  );

                                                  final resAuth = await FirebaseAuth
                                                      .instance
                                                      .signInWithEmailAndPassword(
                                                    email: email.text,
                                                    password: password.text,
                                                  );

                                                  final resFire =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('users')
                                                          .doc(
                                                              resAuth.user!.uid)
                                                          .get();

                                                  cubit.emit(
                                                    AuthSuccessState(),
                                                  );

                                                  String type =
                                                      resFire.data()!['type'];

                                                  await MySharedPreferences
                                                      .setType(type);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    type == 'al'
                                                        ? MainScreen.routeName
                                                        : CharityHomeScreen
                                                            .routeName,
                                                  );
                                                  _clearData();
                                                } on FirebaseAuthException catch (error) {
                                                  cubit.emit(AuthErrorState());
                                                  showToast(
                                                    msg: firebaseError(
                                                        error.code),
                                                  );
                                                }
                                              } else {
                                                if (selectedValueRadio == 0)
                                                  showToast(
                                                    msg:
                                                        "عليك اختيار نوع الحساب",
                                                  );
                                                else {
                                                  String type =
                                                      selectedValueRadio == 1
                                                          ? "as"
                                                          : "al";
                                                  try {
                                                    cubit.emit(
                                                      AuthLoadingState(),
                                                    );

                                                    UserCredential res;
                                                    res = await FirebaseAuth
                                                        .instance
                                                        .createUserWithEmailAndPassword(
                                                      email: email.text,
                                                      password: password.text,
                                                    );

                                                    cubit.emit(
                                                      AuthSuccessState(),
                                                    );
                                                    uId = res.user!.uid;
                                                  } catch (error) {
                                                    cubit.emit(
                                                      AuthErrorState(),
                                                    );
                                                    showToast(
                                                      msg: firebaseError(
                                                        (error as FirebaseAuthException)
                                                            .code,
                                                      ),
                                                    );
                                                  }
                                                  try {
                                                    UserM user = UserM(
                                                      name: name.text,
                                                      address: address.text,
                                                      email: email.text,
                                                      uId: uId!,
                                                      type: type,
                                                    );

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(uId)
                                                        .set(user.toMap());
                                                    await MySharedPreferences
                                                        .setType(type);
                                                    Navigator
                                                        .pushReplacementNamed(
                                                      context,
                                                      selectedValueRadio == 1
                                                          ? CharityHomeScreen
                                                              .routeName
                                                          : DisponibleScreen
                                                              .routeName,
                                                    );
                                                    _clearData();
                                                  } catch (error) {
                                                    cubit.emit(
                                                      AuthErrorState(),
                                                    );

                                                    showToast(
                                                      msg: error.toString(),
                                                    );
                                                  }
                                                  MySharedPreferences.setType(
                                                      type);
                                                }
                                              }

                                              cubit.getNeeds();
                                              cubit.getAllNeeds();
                                              cubit.getAllUsers();
                                              print(MySharedPreferences
                                                  .getType());
                                            }
                                          },
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        child: Text(
                          isLogin ? "أنشئ حساباً" : "أملك حساباً مسبقاً",
                          style: TextStyle(
                            color: Colors.red,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus(); //for hide keyboard
                          ///for the UX
                          if (!isLogin) {
                            email.clear();
                            password.clear();
                            address.clear();
                          }
                          setState(() {
                            isLogin = !isLogin;
                            isObscure = true;
                            selectedValueRadio = 0;
                          });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Row storeOrCharity(Color selectedColor, Color unselectedColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text(
              'جمعية',
              style: TextStyle(
                color:
                    selectedValueRadio == 1 ? selectedColor : unselectedColor,
              ),
            ),
            Radio<int>(
              // title: Text('جمعية'),
              activeColor: selectedColor,
              value: 1,
              groupValue: selectedValueRadio,
              onChanged: (val) {
                setState(() => selectedValueRadio = val!);
              },
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'محل',
              style: TextStyle(
                color:
                    selectedValueRadio == 2 ? selectedColor : unselectedColor,
              ),
            ),
            Radio<int>(
              //title: Text('محل'),
              value: 2,
              groupValue: selectedValueRadio,
              activeColor: selectedColor,
              onChanged: (val) {
                setState(() => selectedValueRadio = val!);
              },
            ),
          ],
        ),
      ],
    );
  }

  InputDecoration emailDecoration() {
    return InputDecoration(
      labelText: "البريد الالكتروني",
      prefixIcon: Icon(Icons.mail),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  String? emailValidator(String val) {
    if (val.isEmpty)
      return "يجب أن يكون هذا الحقل غير فارغٍ";
    else if (!email.text.contains("@")) return "هذا ليس بريدا الكترونيا";
    return null;
  }

  /* String? addressValidator(String val) {
    if (val.isEmpty)
      return "يجب أن يكون هذا الحقل غير فارغٍ";
    else if (val.compareTo(password.text) != 0) return "كلمة السر غير صحيحة";
    return null;
  } */

  String? passwordValidator(String val) {
    if (val.isEmpty)
      return "يجب أن يكون هذا الحقل غير فارغٍ";
    else if (val.length < 5) return "كلمة السر أقل من خمسة حروف";
    return null;
  }

  InputDecoration passwordDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(Icons.lock),
      suffixIcon: InkWell(
        child: Icon(isObscure ? Icons.visibility : Icons.visibility_off),
        onTap: () {
          setState(() {
            isObscure = !isObscure;
          });
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  ButtonStyle styleConfirmedButton(BuildContext context) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      primary: Theme.of(context).primaryColor,
    );
  }

  String firebaseError(String errorCode) {
    String error;
    switch (errorCode) {
      case 'user-not-found':
        {
          error = "مستخدم عير مسجل";
          break;
        }
      case 'wrong-password':
        {
          error = "كلمة السر غير صحيحة";
          break;
        }
      case 'email-already-in-use':
        {
          error = "هذا الإيميل مستعمل من قبل";
          break;
        }

      default:
        error = errorCode;
    }
    return error;
  }
}
