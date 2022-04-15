// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:todo_app/Cubits/Cubits.dart';

Widget DefultFormField({
  @required TextEditingController? controller,
  @required TextInputType? type,
  Function? onSubmit,
  Function? onChange,
  Function? validate,
  @required String? lable,
  @required IconData? Prefix,
}) =>
    TextFormField(
      controller: controller!,
      keyboardType: type!,
      validator: validate!(),
      onChanged: onChange!(),
      decoration: InputDecoration(
        labelText: '${lable!}',
        prefixIcon: Icon(Prefix!),
        border: OutlineInputBorder(),
      ),
      onFieldSubmitted: onSubmit!(),
    );

Widget buildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text(
                '${model['time']}',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).UpdateDataBase('done', model['id']);
              },
              icon: Icon(Icons.done),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).UpdateDataBase('archive', model['id']);
              },
              icon: Icon(Icons.archive_outlined),
              color: Colors.red,
            ),
          ],
        ),
      ),
  onDismissed: (direction){
        AppCubit.get(context).DeleteDataBase(model['id']);  },
    );
