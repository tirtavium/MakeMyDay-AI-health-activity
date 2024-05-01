import 'package:flutter/material.dart';
import 'package:MakeMyDay/screens/diaryScreen/fitness_app_theme.dart';
import 'package:nb_utils/nb_utils.dart';

import '../widgets/add_new_task.dart';
import '../widgets/list.dart';

//Homepage of the app. It allows the user to insert new tasks to his list.
//It'll allow the user to add new lists too (later features).

class ActionRequiredScreen extends StatelessWidget {
  const ActionRequiredScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: FitnessAppTheme.background,
        title: Text("To Do",
            style: boldTextStyle(color: FitnessAppTheme.darkText, size: 35)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => AddNewTask(
                    isEditMode: false, id: DateTime.now().toString()),
              );
            },
          ),
        ],
      ),
      body: const List(),
    );
  }
}
