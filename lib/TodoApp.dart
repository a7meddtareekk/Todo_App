// ignore_for_file: file_names, non_constant_identifier_names, null_check_always_fails, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/ArchivedTasks.dart';
import 'package:todo_app/Cubits/Cubits.dart';
import 'package:todo_app/Cubits/States.dart';
import 'package:todo_app/DoneTasks.dart';
import 'package:todo_app/Tasks.dart';
import 'constants.dart';


class TodoApp extends StatelessWidget {

  var titleController= TextEditingController();
  var timeController= TextEditingController();
  var dateController= TextEditingController();
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();

  TodoApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreateDataBase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) {
          if (state is AppInsertDataBaseState){
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, Object? state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex:cubit.CurrentIndex ,
              onTap: (index){
                cubit.ChangeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
            ),
            appBar: AppBar(
              title: const Text('Todo App '),
            ),
            body:state is! AppGetDataBaseLoadingState? cubit.Screens[cubit.CurrentIndex]:Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              child:Icon(cubit.fabIcon),
              onPressed: (){
                if(cubit.isBottomSheetShowen){
                  if(formkey.currentState!.validate()){
                    cubit.InsertDataBase(title: titleController.text, time: timeController.text, date: dateController.text);


                  }

                }else{
                  scaffoldkey.currentState!.showBottomSheet((context) =>
                      Container(
                        color: Colors.grey[150],
                        padding: EdgeInsets.all(20),
                        child: Form(
                          key: formkey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller:titleController ,
                                keyboardType: TextInputType.text,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'Title Must not be empty ';
                                  }
                                  return null ;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task Title',
                                  prefixIcon: Icon(Icons.title),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                onTap: (){
                                  showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                                    timeController.text=value!.format(context).toString();
                                  });
                                },
                                controller:timeController ,
                                keyboardType: TextInputType.datetime,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'time Must not be empty ';
                                  }
                                  return null ;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task time',
                                  prefixIcon: Icon(Icons.watch_later_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 10,),
                              TextFormField(
                                onTap: (){
                                  showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2025-01-01')
                                  ).then((value) {
                                    dateController.text=DateFormat.yMMMd().format(value!);
                                  });
                                },
                                controller:dateController ,
                                keyboardType: TextInputType.datetime,
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'date Must not be empty ';
                                  }
                                  return null ;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Task date',
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      elevation: 15.0).closed.then((value) {

                        cubit.ChangeBottomSheet(false, Icons.edit);
                  });
                  cubit.ChangeBottomSheet(true, Icons.add);

                }

              },
            ),
          );
        }

      ),
    );
  }

}
