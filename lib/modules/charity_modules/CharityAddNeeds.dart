import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CharityAddNeeds extends StatelessWidget {
  static const routeName = "/charityAdd";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        return Scaffold(
          appBar: buildAppBar(
            title: "إدخال الاحتياجات",
            actions: [
              state is InsertNeedsLoadingState
                  ? CircularProgressIndicator()
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

                          /*cubit.insertNeeds(cubit.asnafNeeds);
                          cubit.clearAsnafNeeds();*/
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
              SizedBox(width: 10),
            ],
          ),
          body: Container(
            margin: EdgeInsets.all(10),
            child: GridView(
              children: [
                ...(cubit.sinf)
                    .map(
                      (sinfElementDisponible) => sinfItemCharity(
                        context,
                        cubit,
                        imageUrl: sinfElementDisponible['imageUrl'],
                        name: sinfElementDisponible['nameSinf'],
                        idSinf: sinfElementDisponible['idSinf'],
                      ),
                    )
                    .toList(),
              ],
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.3,
                mainAxisExtent: MediaQuery.of(context).size.height * 0.2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
            ),
          ),
        );
      },
    );
  }
}
