import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/shared/compents/compents.dart';
import 'package:todo_list/shared/compents/cubit/app_cubit.dart';
import 'package:todo_list/shared/compents/cubit/app_states.dart';

class HomeLayout extends StatelessWidget {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return AppCubit()..createDatabase();
      },
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                '${cubit.titles[cubit.currentIndex]}',
              ),
            ),
            body: ConditionalBuilder(
              condition: cubit.isProgress,
              fallback: (context)=> cubit.screens[(cubit.currentIndex)],
              builder: (context)=> Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isShow){
                  if(formKey.currentState!.validate()){
                    cubit.toggleFab(
                        isShow: false,
                        iconData: Icons.edit);
                    Navigator.pop(context);
                    cubit.insertIntoDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                  }
                }
                else {
                  cubit.toggleFab(
                      isShow: true,
                      iconData: Icons.add);
                  scaffoldKey.currentState!.showBottomSheet(
                    (context) => Form(
                      key: formKey,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextForm(
                              prefixIcon: Icon(Icons.title),
                              labelText: 'Title',
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Title can not be is empty';
                              },
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            defaultTextForm(
                              prefixIcon: Icon(Icons.watch_later_outlined),
                              labelText: 'Time',
                              controller: timeController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Time can not be is empty';
                              },
                              readOnly: true,
                              onTap: () {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value) => timeController.text =
                                    value!.format(context).toString());
                              },
                            ),
                            SizedBox(
                              height: 12.0,
                            ),
                            defaultTextForm(
                              prefixIcon: Icon(Icons.title),
                              labelText: 'Date',
                              controller: dateController,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Title can not be is empty';
                              },
                              readOnly: true,
                              onTap: () {
                                showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now().add(
                                    Duration(
                                      days: 30,
                                    ),
                                  ),
                                ).then((value) {
                                  var formatter = DateFormat('yyyy-MM-dd');
                                  dateController.text = formatter.format(value!);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 20
                  ).closed.then((value) {
                    cubit.toggleFab(
                        isShow: false,
                        iconData: Icons.edit);
                  });
                }
              },
              child: Icon(
                cubit.iconData,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                  ),
                  label: 'New tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.check_circle_outline,
                  ),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                  ),
                  label: 'Archived',
                ),
              ],
              currentIndex: cubit.currentIndex,
              onTap: (value) => cubit.changeScreen(value),
            ),
          );
        },
      ),
    );
  }
}
