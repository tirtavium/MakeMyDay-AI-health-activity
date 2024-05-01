import 'package:flutter/material.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/screens/profile/profile_constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'add_new_condition.dart';
import 'item_text_condition.dart';

//A widget that composes every single item in the list.
//Allows the user to check it as done.
//Deletes a task when dismissed.
//### MISSING FEATURES ###
// Edit a task through the icon button.

class ListItemCondition extends StatefulWidget {
  final String condition;
  final int index;
  final ConditionType conditionType;
  const ListItemCondition(this.condition, this.index, this.conditionType,
      {Key? key})
      : super(key: key);

  @override
  _ListItemConditionState createState() => _ListItemConditionState();
}

class _ListItemConditionState extends State<ListItemCondition> {
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    void _checkItem() {
      setState(() {});
    }

    return Dismissible(
      key: ValueKey(widget.condition),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        final user = userProvider.getUser!;
        switch (widget.conditionType) {
          case ConditionType.currentMedication:
            user.medicationCurrent.removeAt(widget.index);
            break;
          case ConditionType.foodAlergies:
            user.foodAlergies.removeAt(widget.index);
            break;
          case ConditionType.healthCondition:
            user.healthConditions.removeAt(widget.index);
            break;
        }
        userProvider.updateUser(user);
      },
      background: Container(
         padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'DELETE',
              style: TextStyle(
                color: Theme.of(context).shadowColor,
                fontFamily: 'Lato',
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.delete,
              color: Theme.of(context).shadowColor,
              size: 28,
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: _checkItem,
        child: SizedBox(
          height: 65,
          child: Card(
            color: Colors.white,
            elevation: 10,
            child: Row(
            
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    const SizedBox(width: 10),
                    ItemTextCondition(widget.condition),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => AddNewCondition(
                        isEditMode: true,
                        editConditionString: widget.condition,
                        editIndex: widget.index,
                        conditionType: widget.conditionType,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
