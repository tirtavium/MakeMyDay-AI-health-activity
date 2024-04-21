import 'package:flutter/material.dart';
import 'package:MakeMyDay/screens/diaryScreen/fitness_app_theme.dart';
import 'package:MakeMyDay/screens/profile/conditionScreen/widgets/add_new_condition.dart';
import 'package:MakeMyDay/screens/profile/conditionScreen/widgets/list_condition.dart';
import 'package:MakeMyDay/screens/profile/profile_constant.dart';
import 'package:nb_utils/nb_utils.dart';

//Homepage of the app. It allows the user to insert new tasks to his list.
//It'll allow the user to add new lists too (later features).

class ProfileConditionScreen extends StatelessWidget {
  final ConditionType conditionType;

  const ProfileConditionScreen({Key? key, required this.conditionType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: FitnessAppTheme.background,
        title: Text(conditionType.getTitle(),
            style: boldTextStyle(color: FitnessAppTheme.darkText, size: 35)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: black),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => AddNewCondition(
                    isEditMode: false, conditionType: conditionType),
              );
            },
          ),
        ],
      ),
      body: ListCondition(conditionType: conditionType),
    );
  }
}
