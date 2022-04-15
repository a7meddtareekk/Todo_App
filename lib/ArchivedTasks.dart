// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Cubits/Cubits.dart';
import 'Cubits/States.dart';
import 'components.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (BuildContext context, state) {  },
      builder: (BuildContext context, Object? state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return tasks.length>0? ListView.separated(
            itemBuilder: (context,index)=> buildTaskItem(tasks[index],context),
            separatorBuilder: (context,index)=>Container(
              color: Colors.grey[300],
              width: double.infinity,
              height: 1,
            ),
            itemCount: tasks.length): Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Icon(Icons.menu),
          Text('No Tasks Yet')
        ],),);  },

    );
  }
}
