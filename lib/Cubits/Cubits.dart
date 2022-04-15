// ignore_for_file: file_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/Cubits/States.dart';
import 'package:todo_app/DoneTasks.dart';
import 'package:todo_app/Tasks.dart';

import '../ArchivedTasks.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppInitialState());
  static AppCubit get(context)=> BlocProvider.of(context);


  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  Database? database;
  int CurrentIndex = 0 ;
  List<Widget> Screens = [
    Tasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  bool isBottomSheetShowen=false;
  IconData fabIcon = Icons.edit;

  void ChangeBottomSheet(
       @required bool isShowen ,
       @required IconData icon,
      ){
    isBottomSheetShowen=isShowen;
    fabIcon=icon;
    emit(AppChangeBottomSheet());
  }

  void ChangeIndex(int index){
    CurrentIndex=index;
    emit(AppChangeBotNavBar());
  }

  void CreateDataBase() {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database, version)async {
          await database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY , title TEXT , date TEXT , time TEXT , status TEXT )')
              .then((value){
            print('Table Created');
          }).catchError((onError){
            print('Erorr when Creating Table ${onError.toString()}');
          });
        },
        onOpen: (database){
          getDaTaBase(database);
        }

    ).then((value) {
      database=value;
      emit(AppCreateDataBaseState());
     });
  }

 InsertDataBase(
      {required String? title,
        required String? time,
        required String? date}) async{
     await database!.transaction((txn) {
      return txn.rawInsert('INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new") ').then((value) {
        print('$value inserted successfuly');
        emit(AppInsertDataBaseState());
        getDaTaBase(database);

      }).catchError((onError){
        print('Erorr when inserting a new record ${onError.toString()}');
      });

    });
  }


  void getDaTaBase(database){
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
    emit(AppGetDataBaseLoadingState());
     database!.rawQuery('SELECT * FROM tasks').then((value) {
       value.forEach((element){
         if(element['status']=='new')
        newTasks.add(element);
         else if(element['status']=='done')
           doneTasks.add(element);
         else archivedTasks.add(element);

       });
       emit(AppGetDataBaseState());
     });;
  }


  void UpdateDataBase(
      @required String status ,
      @required int id ,
      )async{
      database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
        getDaTaBase(database);
          emit(AppUpdateDataBaseState());
      });

  }

  void DeleteDataBase(
      @required int id ,
      )async{
    database!.rawDelete(
        'DELETE FROM tasks WHERE id = ?', [id],
        ).then((value) {
      getDaTaBase(database);
      emit(AppDeleteDataBaseState());
    });

  }

}