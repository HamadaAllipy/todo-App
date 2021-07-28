import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/moduls/archived_screen.dart';
import 'package:todo_list/moduls/done_screen.dart';
import 'package:todo_list/moduls/newtasks_screen.dart';
import 'package:todo_list/shared/compents/cubit/app_states.dart';

class AppCubit extends Cubit<AppStates>{

  AppCubit():super(InitialState());

  int currentIndex = 0 ;
  bool isShow = false;
  IconData iconData = Icons.edit;
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  bool isProgress = false;
  List<Widget> screens = [
    NewTasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List<String> titles = [
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];

  static AppCubit get(context) =>BlocProvider.of(context);

  void changeScreen(int index){
    currentIndex = index;
    emit(ChangeScreen());
  }

  void toggleFab({
  required bool isShow,
  required IconData iconData,
}){
    this.isShow = isShow;
    this.iconData = iconData;
    emit(ToggleFab());
  }

  void createDatabase()async{
    await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (db,version){
        db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, states TEXT)',
        ).then((value) {
          print('Successfully table is created');

        }).catchError((onError){
          print('Error [50]: when is creating table ${onError.toString()}');
        });
      },
      onOpen: (db){
        print('Database is opened ');
        getDataFromDatabase(db);

      },
    ).then((value){
      database = value;
      emit(CreateDatabase());
    } ).catchError((onError){
      print('Error [59]: when is creating database ${onError.toString()}');
    });
  }

  void insertIntoDatabase({
    required String title,
    required String time,
    required String date,
  }) {
    emit(InsertRawIntoDatabase());
    database!.transaction((txn) {
      return txn.rawInsert(
        'INSERT INTO tasks(title, time, date, states)VALUES("$title","$time","$date","new")',);})
        .then((value) {
          print('Successfully Inserting row[$value]');
          emit(InsertRawIntoDatabase());
          getDataFromDatabase(database!);
        })
        .catchError((onError) {
          print('Error [73]: when is inserting ${onError.toString}');
        });
  }

  void getDataFromDatabase(Database db){


    db.rawQuery(
        'SELECT * FROM tasks',
    ).then((value) {
      // circularProgressState(isProgress: true);
      print('Query is Successfully');
      emit(GetDataFromDatabase());
      newTasks = [];
      doneTasks = [];
      archivedTasks = [];
      value.forEach((element) {
        if(element['states'] == 'new'){
          newTasks.add(element);
        }
        else if(element['states'] == 'done'){
          doneTasks.add(element);
        }
        else{
          archivedTasks.add(element);
        }
      });
      circularProgressState(isProgress: false);
    });
  }

  void updateData(String states , int id){
    database!.rawUpdate(
      'UPDATE tasks SET states = ? WHERE id = ?',
      ['$states',id]
    ).then((value) {
      emit(UpdateRawFromDatabase());
      print('Updating is successfully Row [$value]');
      getDataFromDatabase(database!);
    }).catchError((onError){
      print('Error [119]: when is updating ${onError.toString()}');
    });
  }

  void deleteData(int id){
    database!.rawDelete(
      'DELETE FROM tasks WHERE id = ? ',
      [id]
    ).then((value) {
      emit(DeleteRawFromDatabase());
      print('Deleting is successfully Row[$value]');
      getDataFromDatabase(database!);
    }).catchError((onError){
      print('Error [131]: when is Deleting ${onError.toString()}');
    });
  }

  void circularProgressState({required bool isProgress}){
    this.isProgress = isProgress;
    emit(CircularProgressState());
  }
}