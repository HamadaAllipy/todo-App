import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/shared/compents/compents.dart';
import 'package:todo_list/shared/compents/cubit/app_cubit.dart';
import 'package:todo_list/shared/compents/cubit/app_states.dart';

class ArchivedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.archivedTasks.length > 0,
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: ListView.separated(
              itemBuilder: (context, index) =>
                  buildItem(cubit.archivedTasks[index], cubit),
              separatorBuilder: (context, index) => buildSeparated(),
              itemCount: cubit.archivedTasks.length,
            ),
          ),
          fallback: (context) => buildEmpty(),
        );
      },
    );
  }
}
