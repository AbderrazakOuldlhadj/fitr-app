import 'package:fitr/models/MySharedPrefrences.dart';
import 'package:fitr/modules/store_modules/MainScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DisponibleScreen extends StatefulWidget {
  static const routeName = '/dispo';

  @override
  _DisponibleScreenState createState() => _DisponibleScreenState();
}

class _DisponibleScreenState extends State<DisponibleScreen> {
  TextEditingController price = TextEditingController();
  TextEditingController stock = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);

        return Scaffold(
          appBar: buildAppBar(
            title: "فعِّل المواد المُتاحة",
            actions: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle),
                child: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    Navigator.pushReplacementNamed(
                        context, MainScreen.routeName);

                    yesFunction(cubit);

                    /// set firstTime variable (first run ever) to false
                    if (MySharedPreferences.getFirstTime())
                      MySharedPreferences.setFirstTime(false);
                  },
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          body: ListView.separated(
            itemCount: cubit.sinf.length,
            separatorBuilder: (cx, _) => Container(),
            itemBuilder: (cx, index) => GestureDetector(
              onTap: () {
                buildDetailDialog(
                  context: cx,
                  title: cubit.sinf[index]['nameSinf'],
                  children: [
                    buildTableRow(
                        cells: ["المقدار (كغ)", "الثمن (د.ج)", "المخزون (كغ)"],
                        isHeader: true),
                    buildTableRow(cells: [
                      "${cubit.sinf[index]['weight']}",
                      "${cubit.sinf[index]['prixKg']}",
                      "${cubit.sinf[index]['stock']}",
                    ]),
                  ],
                );
              },
              child: Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: cubit.asnafDisponible[index]
                        ? Colors.greenAccent.withOpacity(0.7)
                        : Colors.redAccent.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: Row(
                    children: [
                      CupertinoSwitch(
                          trackColor: Colors.redAccent.withOpacity(0.5),
                          value: cubit.asnafDisponible[index],
                          onChanged: (val) {
                            /// don't change sinf to true if stock less than weight
                            if (cubit.sinf[index]['stock'] >=
                                cubit.sinf[index]['weight']) {
                              cubit.asnafDisponible[index] = val;
                              setState(() {});
                            }
                            print('${cubit.asnafDisponible}');
                          }),
                      Spacer(),
                      IconButton(
                        color: Theme.of(context).primaryColor.withOpacity(0.7),
                        icon: Icon(FontAwesomeIcons.weight),
                        onPressed: () {
                          buildDialog(
                            context,
                            title: "المخزون",
                            prefixIcon: FontAwesomeIcons.weight,
                            labelText: "الوزن",
                            image: true,
                            imageUrl: cubit.sinf[index]['imageUrl'],
                            sinfName: cubit.sinf[index]['nameSinf'],
                            counterText: "كغ",
                            controller: stock,
                            keyBoardType:
                                TextInputType.numberWithOptions(decimal: true),
                            doneFunction: () {
                              cubit.stockSinf[cubit.sinf[index]['idSinf']] =
                                  double.parse(stock.text);
                              stock.clear();
                              print('stockSinf= ${cubit.stockSinf}');
                            },
                          );
                        },
                      ),
                      if (cubit.asnafDisponible[index])
                        IconButton(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                          icon: Icon(FontAwesomeIcons.dollarSign),
                          onPressed: () {
                            buildDialog(
                              context,
                              title: "ثمن الكيلوغرام الواحد",
                              prefixIcon: FontAwesomeIcons.dollarSign,
                              labelText: "الثمن",
                              image: true,
                              imageUrl: cubit.sinf[index]['imageUrl'],
                              sinfName: cubit.sinf[index]['nameSinf'],
                              controller: price,
                              keyBoardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              counterText: "د.ج",
                              doneFunction: () {
                                cubit.priceKgSinf[cubit.sinf[index]['idSinf']] =
                                    double.parse(price.text);
                                price.clear();
                                print('prixKgSinf= ${cubit.priceKgSinf}');
                                //cubit.getDataFromDatabase(cubit.myDb!);
                              },
                            );
                          },
                        ),
                      Spacer(),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            child: Image.asset(cubit.sinf[index]['imageUrl']),
                          ),
                          SizedBox(height: 8),
                          Text(
                            index == 8
                                ? "جلبانة مكسرة"
                                : "${cubit.sinf[index]['nameSinf']}",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
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

  /// just to simplify the code
  void yesFunction(AppCubit cubit) {
    /// 1. Update the priceKg for every Sinf has been updated
    cubit.priceKgSinf.forEach((key, value) {
      if (value != 0)
        cubit.updateSinfPrixKg(
          prixKg: value,
          idSinf: key,
        );
    });
    print('${cubit.priceKgSinf}');

    /// 2. Update the stock every Sinf has been updated
    cubit.stockSinf.forEach((key, value) {
      if (value != 0)
        cubit.updateSinfStock(
          stock: value,
          idSinf: key,
        );
    });
    print('${cubit.stockSinf}');
    int i = 0;
    cubit.sinf.forEach(
      (element) {
        cubit.updateSinfDisponibilite(
          disponibilite: cubit.asnafDisponible[i],
          idSinf: element['idSinf'],
        );
        i++;
      },
    );
    i = 0;
  }
}
