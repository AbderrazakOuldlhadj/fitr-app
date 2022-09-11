import 'package:badges/badges.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildDrawerItem(
  context, {
  required String title,
  required IconData icon,
  void Function()? onTap,
}) =>
    ListTile(
      title: Text(title),
      leading: Icon(
        icon,
        color: Theme.of(context).primaryColor,
      ),
      onTap: onTap,
    );

Container sinfItem(
  context,
  AppCubit cubit, {
  required String imageUrl,
  required String name,
  required String idSinf,
  required Map<dynamic, dynamic> sinfElementDisponible,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        width: 2,
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(20),
      color: Colors.white70,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),

        /// Image
        Container(
          height: 80,
          child: GestureDetector(
            onTap: () {
              buildDetailDialog(
                context: context,
                title: sinfElementDisponible['nameSinf'],
                children: [
                  buildTableRow(
                      cells: ["المقدار (كغ)", "الثمن (د.ج)", "المخزون (كغ)"],
                      isHeader: true),
                  buildTableRow(cells: [
                    "${sinfElementDisponible['weight']}",
                    "${sinfElementDisponible['prixKg']}",
                    "${sinfElementDisponible['stock']}",
                  ]),
                ],
              );
            },
            child: Badge(
              badgeColor: Colors.transparent,
              elevation: 0.0,
              badgeContent: cubit.allowedSinf[idSinf]! <= 5
                  ? Text('${cubit.allowedSinf[idSinf]}',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ))
                  : null,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        SizedBox(height: 5),

        /// Name
        Text(
          name,
          style: TextStyle(fontWeight: FontWeight.bold),
          softWrap: true,
        ),

        /// Add and Sub
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  cubit.decrementSinf(idSinf);
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 20,
                  foregroundColor: Colors.white,
                  child: Icon(FontAwesomeIcons.minus),
                ),
              ),
              Text(
                "${cubit.nbSinf['$idSinf']}",
                style: TextStyle(
                    color: cubit.nbSinf['$idSinf'] == 0
                        ? Colors.red
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
              GestureDetector(
                onTap: () {
                  cubit.incrementSinf(idSinf);
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 20,
                  foregroundColor: Colors.white,
                  child: Icon(FontAwesomeIcons.plus),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    ),
  );
}

GestureDetector sinfItemCharity(
  context,
  AppCubit cubit, {
  required String imageUrl,
  required String name,
  required String idSinf,
}) {
  return GestureDetector(
    onTap: () {
      buildDialog(
        context,
        title: "طلب",
        sinfName: name,
        prefixIcon: FontAwesomeIcons.balanceScale,
        labelText: "الوزن",
        counterText: "كغ",
        image: true,
        imageUrl: imageUrl,
        controller: cubit.sinfController,
        keyBoardType:
            TextInputType.numberWithOptions(decimal: true, signed: false),
        doneFunction: () {
          String key = idSinf;
          double value = double.parse(cubit.sinfController.text);
          cubit.insertNeed({key: value});
          cubit.sinfController.clear();

          //print("asnafNeeds= ${cubit.asnafNeeds}");
        },
      );
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white70,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 5,
          ),

          /// Image
          Container(
            height: 80,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(height: 5),

          /// Name
          Text(
            name,
            style: TextStyle(fontWeight: FontWeight.bold),
            softWrap: true,
          ),
          SizedBox(height: 5),
        ],
      ),
    ),
  );
}

Future buildDialog(
  context, {
  required String title,
  required IconData prefixIcon,
  required String labelText,
  required bool image,
  required TextEditingController controller,
  required TextInputType keyBoardType,
  required Future<void>? Function() doneFunction,
  String imageUrl = "",
  String counterText = "",
  String sinfName = "",
}) =>
    showDialog(
      context: context,
      builder: (cxd) => AlertDialog(
        elevation: 50,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          "$title",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (image)
                  Container(
                    height: 100,
                    child: Image.asset(imageUrl, fit: BoxFit.fill),
                  ),
                SizedBox(height: 5),
                Text(
                  sinfName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: labelText,
                    counterText: counterText,
                    counterStyle: TextStyle(fontWeight: FontWeight.bold),
                    prefixIcon: Icon(
                      prefixIcon,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  controller: controller,
                  validator: (val) {
                    if (val!.isEmpty) return "يجب أن يكون هذا الحقل غير فارغٍ";
                    return null;
                  },
                  keyboardType: keyBoardType,
                ),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "إلغاء",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.redAccent),
            ),
            onPressed: () {
              Navigator.pop(cxd);
            },
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              "تمّ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.lightBlue),
            ),
            onPressed: () {
              doneFunction();
              Navigator.pop(cxd);
            },
          ),
        ],
      ),
    );

AppBar buildAppBar(
        {required String title, List<Widget>? actions, Widget? leading}) =>
    AppBar(
      title: Text("$title", overflow: TextOverflow.fade),
      leading: leading,
      actions: actions,
    );

TableRow buildTableRow({required List<String> cells, bool isHeader = false}) {
  return TableRow(children: [
    ...cells
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                e,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: isHeader ? FontWeight.bold : FontWeight.normal),
              ),
            ))
        .toList()
  ]);
}




Future buildDetailDialog({
  required BuildContext context,
  required String title,
  required List<TableRow> children,
}) =>
    showDialog(
        barrierColor: Colors.black.withOpacity(0.1),
        context: context,
        builder: (cxd) => SimpleDialog(
              title: Text(
                title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Table(
                    border: TableBorder.all(),
                    textDirection: TextDirection.rtl,
                    children: children,
                  ),
                )
              ],
            ));

Card buildWeightTotalSinf(
    {required BuildContext context,
    required List<Map<dynamic, dynamic>> awzanList,
    required int index,
    AppCubit? cubit}) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              buildDetailDialog(
                context: context,
                title: cubit!.sinf[index]['nameSinf'],
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
            child: Container(
              height: 80,
              child: Image.asset(awzanList[index]['imageUrl']),
            ),
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 2,
                      color: awzanList[index]['weightTotal'] > 0
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                  child: Center(
                      child: Text(
                    "${(awzanList[index]['weightTotal'] as double)}",
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
            "${awzanList[index]['nameSinf']}",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool?> showToast({required String msg}) => Fluttertoast.showToast(
      msg: msg,
      fontSize: 15,
      backgroundColor: Colors.red,
    );

EdgeInsets confirmedButtonPadding() =>
    const EdgeInsets.symmetric(horizontal: 20.0);
