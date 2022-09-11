import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fitr/modules/charity_modules/CharityAddNeeds.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyNeeds extends StatelessWidget {
  static const routeName = "/myNeeds";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        List<String> keys = cubit.myNeeds.keys.toList();

        return Scaffold(
          appBar: buildAppBar(
            title: "طلباتي",
            actions: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CharityAddNeeds.routeName);
                  },
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          body: state is GetNeedsLoadingState
              ? Center(child: CircularProgressIndicator())
              : ConditionalBuilder(
                  condition: keys.length > 0,
                  fallback: (_) => Center(
                    child: Text(
                      "لا توجد طلبات",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  builder: (_) => ListView.separated(
                    itemCount: keys.length,
                    separatorBuilder: (cx, _) => Container(),
                    itemBuilder: (cx, index) => Card(
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 1.5,
                        ),
                      ),
                      child: Slidable(
                        actionPane: SlidableScrollActionPane(),
                        actionExtentRatio: 0.3,
                        secondaryActions: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: IconSlideAction(
                              color: Theme.of(context).primaryColor,
                              caption: "تعديل",
                              icon: Icons.edit,
                              onTap: () {
                                buildDialog(
                                  context,
                                  title: "تعديل",
                                  sinfName: cubit.sinf.firstWhere((element) =>
                                      element['idSinf'] ==
                                      keys[index])['nameSinf'],
                                  prefixIcon: FontAwesomeIcons.balanceScale,
                                  labelText: "الوزن",
                                  counterText: "كغ",
                                  image: true,
                                  imageUrl: cubit.sinf.firstWhere((element) =>
                                      element['idSinf'] ==
                                      keys[index])['imageUrl'],
                                  controller: cubit.sinfController,
                                  keyBoardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: false),
                                  doneFunction: () {
                                    String idSinf = keys[index];
                                    double newNeed =
                                        double.parse(cubit.sinfController.text);
                                    cubit.updateNeed(idSinf, newNeed);
                                    cubit.sinfController.clear();

                                    //print("asnafNeeds= ${cubit.asnafNeeds}");
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                        actions: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: IconSlideAction(
                              color: Colors.red,
                              caption: "حذف",
                              icon: Icons.delete,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (cxd) => AlertDialog(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "هل تريد حذف ؟",
                                                style: TextStyle(fontSize: 20),
                                                softWrap: true,
                                                textAlign: TextAlign.end,
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                height: 100,
                                                child: Image.asset(
                                                    cubit.sinf.firstWhere(
                                                            (element) =>
                                                                element[
                                                                    'idSinf'] ==
                                                                keys[index])[
                                                        'imageUrl'],
                                                    fit: BoxFit.fill),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                cubit.sinf.firstWhere(
                                                        (element) =>
                                                            element['idSinf'] ==
                                                            keys[index])[
                                                    'nameSinf'],
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: Text(
                                                "لا",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(cxd);
                                              },
                                            ),
                                            OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    20,
                                                  ),
                                                ),
                                              ),
                                              child: Text(
                                                "نعم",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    color: Colors.lightBlue),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(cxd);
                                                cubit.deleteNeed(keys[index]);
                                              },
                                            ),
                                          ],
                                        ));
                              },
                            ),
                          ),
                        ],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 15,
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 80,
                                child: Image.asset(cubit.sinf.firstWhere(
                                    (element) =>
                                        element['idSinf'] ==
                                        keys[index])['imageUrl']),
                              ),
                              Spacer(),
                              Container(
                                child: Row(
                                  children: [
                                    Text(
                                      "كغ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: Theme.of(context).primaryColor,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${cubit.myNeeds[keys[index]]}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color:
                                                Theme.of(context).primaryColor),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              Text(
                                "${cubit.sinf.firstWhere((element) => element['idSinf'] == keys[index])['nameSinf']}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
