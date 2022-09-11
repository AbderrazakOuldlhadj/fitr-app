import 'package:fitr/modules/store_modules/AddPersonneScreen.dart';
import 'package:fitr/modules/store_modules/MainScreen.dart';
import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AsnafScreen extends StatelessWidget {
  static final routeName = '/personne';
  final String title = 'next';

  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        //List<Map> asnaf = cubit.sinf;
        return WillPopScope(
          onWillPop: () async {
            cubit.clearData();
            Navigator.pushReplacementNamed(
                context, AddPersonneScreen.routeName);

            return true;
          },
          child: Scaffold(
            appBar: buildAppBar(
              title: "${cubit.name.text}",
              leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  cubit.clearData();
                  Navigator.pushReplacementNamed(
                      context, AddPersonneScreen.routeName);
                },
              ),
              actions: [
                cubit.nbPersonneTotal - cubit.nbPersonneCurrent > 0
                    ? Center(
                        child: Text(
                          "${cubit.nbPersonneTotal - cubit.nbPersonneCurrent}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.red),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(
                            FontAwesomeIcons.check,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            double price = 0;
                            if (cubit.nbPersonneCurrent ==
                                cubit.nbPersonneTotal) {
                              /// 1. Calculate the price
                              price = cubit.calculateClientPrice();
                              //Confirmation
                              showDialog(
                                context: context,
                                builder: (ctxD) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  title: Text(
                                    "الثمن",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.end,
                                  ),
                                  content: SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "د.ج",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(width: 15),
                                        Text(
                                          "${price.round()}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
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
                                        "تأكيد",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.lightBlue),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(ctxD);
                                        Navigator.pushReplacementNamed(
                                            context, MainScreen.routeName);

                                        confirmationFunction(cubit, price);
                                      },
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                SizedBox(width: 25),
              ],
            ),
            body: Container(
              margin: EdgeInsets.all(10),
              child: GridView(
                children: [
                  ...(cubit.sinf.where((sinfElement) => cubit
                          .parseStringToBool(sinfElement['disponibilite'])))
                      .map((sinfElementDisponible) => sinfItem(context, cubit,
                          imageUrl: sinfElementDisponible['imageUrl'],
                          name: sinfElementDisponible['nameSinf'],
                          idSinf: sinfElementDisponible['idSinf'],
                          sinfElementDisponible: sinfElementDisponible))
                      .toList(),
                ],
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.5,
                 // mainAxisExtent: MediaQuery.of(context).size.height * 0.2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// to simplify the code
  void confirmationFunction(AppCubit cubit, double price) {
    /// 2. Insert info to Client table
    cubit.insertToClient(
      nameClient: cubit.name.text,
      nbPersonne: cubit.nbPersonneTotal,
      prixTotal: price,
    );

    /// 3. Calculate and update the total weight and the stock of every sinf

    cubit.calculateSinfWeightTotal(cubit.nbSinf);

    /// 4. Extract the idClient for implement the information of his ikhraj
    cubit.getIdCurrentClient(cubit.myDb!).then((idCurrentClient) {
      (cubit.nbSinf).forEach((key, value) {
        if (value != 0)
          cubit.insertToIkhraj(
            idClient: idCurrentClient,
            idSinf: key,
            fois: value,
          );
      });

      cubit.clearData();
    });
  }
}
