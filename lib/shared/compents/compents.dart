import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/shared/compents/cubit/app_cubit.dart';

Widget defaultTextForm({
  required String labelText,
  required Icon prefixIcon,
  Icon? suffixIcon,
  double radius = 10.0,
  GestureTapCallback? onTap,
  TextInputType? keyboardType,
  bool readOnly = false,
  bool obscureText = false,
  FormFieldValidator<String>? validator,
  TextEditingController? controller,
}) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: labelText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
    onTap: onTap,
    keyboardType: keyboardType,
    readOnly: readOnly,
    validator: validator,
    controller: controller,
    obscureText: obscureText,
  );
}

Widget buildItem(Map model, AppCubit cubit) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      cubit.deleteData(model['id']);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 45,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    '${model['title']}',
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              cubit.updateData('done', model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.deepOrange,
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              end: 12,
            ),
            child: IconButton(
              onPressed: () {
                cubit.updateData('archived', model['id']);
              },
              icon: Icon(
                Icons.archive,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildSeparated() {
  return Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey,
  );
}

Widget buildEmpty() {
  return (Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100,
          color: Colors.grey,
        ),
        Text(
          'Please add to some tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  ));
}
