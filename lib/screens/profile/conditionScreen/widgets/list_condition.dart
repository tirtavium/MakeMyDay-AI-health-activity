import 'package:flutter/material.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/screens/profile/profile_constant.dart';
import 'package:provider/provider.dart';
import 'list_item_condition.dart';

//Parent widget of all ListItems, this widget role is just to group all list tiles.

class ListCondition extends StatelessWidget {
  final ConditionType conditionType;

  const ListCondition({Key? key, required this.conditionType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> conditionList = getConditionList(context);
    return conditionList.isNotEmpty
        ? ListView.builder(
            itemCount: conditionList.length,
            itemBuilder: (context, index) {
              return ListItemCondition(conditionList[index], index, conditionType);
            },
          )
        : LayoutBuilder(
            builder: (ctx, constraints) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: Image.asset('assets/fitness_app/bell.png',
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'No tasks added yet...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            },
          );
  }

  List<dynamic> getConditionList(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.getUser!;
    var conditionList = user.healthConditions;
    switch (conditionType) {
      case ConditionType.currentMedication:
        conditionList = user.medicationCurrent;
        break;
      case ConditionType.foodAlergies:
        conditionList = user.foodAlergies;
        break;
      case ConditionType.healthCondition:
        conditionList = user.healthConditions;
         break;
    }
    return conditionList;
  }
}
