import 'package:fitr/shared/components/Components.dart';
import 'package:fitr/shared/cubit/cubit.dart';
import 'package:fitr/shared/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AwzanScreen extends StatelessWidget {
  static final routeName = "/awzan";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (_, state) {},
      builder: (ctx, state) {
        AppCubit cubit = AppCubit.getObject(ctx);
        List<Map> awzanList = cubit.sinf;

        return Scaffold(
          appBar: buildAppBar(
            title: "الأوزان الكلية",
          ),
          body: ListView.separated(
            itemCount: awzanList.length,
            separatorBuilder: (cx, _) => Container(),
            itemBuilder: (cx, index) {
              return buildWeightTotalSinf(
                context: context,
                awzanList: awzanList,
                index: index,
                cubit:cubit
              );
            },
          ),
        );
      },
    );
  }
}
