import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MuzakiScreen extends StatelessWidget {
  static final routeName = '/muzaki';

  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        List<Map> clientList = cubit.client;

        return Scaffold(
          appBar: buildAppBar(
            title: "المُزَكُّون",
          ),
          body: clientList.length == 0
              ? Center(
                  child: Text(
                    "القائمة فارغة",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.separated(
                  itemCount: clientList.length,
                  separatorBuilder: (cx, _) => Container(),
                  itemBuilder: (_, index) {
                    print('${clientList[index]['nameClient']}');

                    /// Extract Ikhraj List
                    final List<Map> ikhrajList = cubit.ikhraj
                        .where((element) =>
                            element['idClient'] ==
                            clientList[index]['idClient'])
                        .toList();

                    ///
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          buildDetailDialog(
                              context: ctx,
                              title: (clientList[index]['prixTotal']).toString(),
                              children: [
                                buildTableRow(
                                    cells: ["الصنف", "العدد"], isHeader: true),
                                ...ikhrajList
                                    .map((ikhrajElement) => buildTableRow(cells: [
                                          "${getNameSinf(ikhrajElement['idSinf'], cubit)}",
                                          "${ikhrajElement["fois"]}"
                                        ]))
                                    .toList()
                              ]);
                        },
                        child: Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 20,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          child: Slidable(
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.3,
                            actions: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
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
                                              content: Text(
                                                "هل تريد إرجاع الأوزان إلى المخزون ؟",
                                                style: TextStyle(fontSize: 20),
                                                softWrap: true,
                                                textAlign: TextAlign.end,
                                              ),
                                              actions: [
                                                OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "لا",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.redAccent),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(cxd);
                                                    cubit.deleteClient(
                                                        idClient:
                                                            clientList[index]
                                                                ['idClient']);
                                                  },
                                                ),
                                                OutlinedButton(
                                                  style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    "نعم",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20,
                                                        color: Colors.lightBlue),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pop(cxd);

                                                    returnToStock(
                                                        cubit, clientList, index);
                                                    cubit.deleteClient(
                                                        idClient:
                                                            clientList[index]
                                                                ['idClient']);
                                                  },
                                                ),
                                              ],
                                            ));
                                  },
                                ),
                              )

                            ],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),

                              /// The big Row
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.add_to_photos,
                                        color: Colors.white),
                                    onPressed: () {
                                      duplicateFunction(
                                          cubit, clientList, index);
                                      // duplicateDialog(context);
                                      /*buildDialog(
                                        context,
                                        title: "ضاعِف",
                                        prefixIcon: FontAwesomeIcons.user,
                                        labelText: "إسم المُزكِّي",
                                        image: true,
                                        imageUrl: "assets/images/fitr_pic8.png",
                                        controller: name,
                                        keyBoardType: TextInputType.name,
                                        doneFunction: () async {

                                        },
                                      );*/
                                    },
                                  ),
                                  Spacer(),

                                  /// The little Row
                                  Container(
                                    child: Row(
                                      children: [
                                        Text(
                                          "د.ج",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              width: 2,
                                              color: Colors.greenAccent,
                                            ),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "${clientList[index]['prixTotal']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                  "عدد الأفراد : ${clientList[index]['nbPersonne']}",
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(height: 5)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  /// I used this function just to simplify the code
  String getNameSinf(String idSinf, cubit) {
    return cubit.sinf.firstWhere((element) =>
            (element['idSinf'] as String).compareTo(idSinf) == 0)['nameSinf']
        as String;
  }

  void duplicateFunction(
      AppCubit cubit, List<Map<dynamic, dynamic>> clientList, int index) {
    cubit.insertToClient(
      nameClient: name.text,
      nbPersonne: clientList[index]['nbPersonne'],
      prixTotal: clientList[index]['prixTotal'],
    );



    final asnafClient = cubit.ikhraj.where(
        (element) => element['idClient'] == clientList[index]['idClient']);
    asnafClient.forEach((element) {
      print('\n\nlast= ${cubit.client.last}\n\n');
      cubit.insertToIkhraj(
        idClient: cubit.client.last['idClient'] + 1 as int,
        idSinf: element['idSinf'],
        fois: element['fois'] as int,
      );

      /// Update WeightTotal of every sinf
      Map currentSinf =
          cubit.sinf.firstWhere((e) => e['idSinf'] == element['idSinf']);
      double oldWeightTotal = currentSinf['weightTotal'] as double;
      double newWeightTotal = oldWeightTotal +
          ((currentSinf['weight'] as double) * element['fois']);

      cubit.updateSinfWeightTotal(
          weightTotal: cubit.ceilToDouble2(newWeightTotal),
          idSinf: element['idSinf']);
    });
    _updateStock(cubit, clientList, index);
  }

  void returnToStock(
      AppCubit cubit, List<Map<dynamic, dynamic>> clientList, int index) {
    /// Extract asnafClient
    final List<Map> asnafClient = cubit.ikhraj
        .where(
            (element) => element['idClient'] == clientList[index]['idClient'])
        .toList();
    print('asnafClient= $asnafClient');

    /// add to stock
    asnafClient.forEach((element) {
      double stockAdd = (cubit.sinf.firstWhere((e) =>
              (e['idSinf'] as String).compareTo(element['idSinf']) ==
              0)['weight']) *
          (element['fois'] as int);
      cubit.addToStock(idSinf: element['idSinf'], stockAdd: stockAdd);
    });
  }

  void _updateStock (AppCubit cubit, List<Map<dynamic, dynamic>> clientList, int index) {
  /// Extract asnafClient
  final List<Map> asnafClient = cubit.ikhraj
      .where(
  (element) => element['idClient'] == clientList[index]['idClient'])
      .toList();
  print('asnafClient= $asnafClient');

  /// add to stock
  asnafClient.forEach((element) {
  double stockSub = (cubit.sinf.firstWhere((e) =>
  (e['idSinf'] as String).compareTo(element['idSinf']) ==
  0)['weight']) *
  (element['fois'] as int);
  cubit.subToStock(idSinf: element['idSinf'], stockSub: stockSub);
  });
}

}
