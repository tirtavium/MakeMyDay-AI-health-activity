import 'package:flutter/material.dart';
import 'package:MakeMyDay/models/ActionRequired.dart';
import 'package:MakeMyDay/resources/firestore_methods.dart';
import 'package:nb_utils/nb_utils.dart';

import '../widgets/add_new_task.dart';
import './item_text.dart';

//A widget that composes every single item in the list.
//Allows the user to check it as done.
//Deletes a task when dismissed.
//### MISSING FEATURES ###
// Edit a task through the icon button.

class ListItem extends StatefulWidget {
  final snap;

  const ListItem(this.snap, {Key? key}) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  late ActionRequiredPost task;
  @override
  void initState() {
    // TODO: implement initState
    task = ActionRequiredPost.fromSnap(widget.snap);
  }

  @override
  Widget build(BuildContext context) {
    void _checkItem() {
      setState(() {
        // Provider.of<TaskProvider>(context, listen: false)
        //     .changeStatus(widget.task.id);
        //print('SET STATE ${widget.task.isDone.toString()}');
      });
    }

    return Dismissible(
      key: UniqueKey(),//Key(task.actionRequiredId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        FireStoreMethods().deleteActionRequiredPost(task.actionRequiredId);
      },
      background: Container(
 
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'DELETE',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontFamily: 'Lato',
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
              size: 28,
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: _checkItem,
        child: 
        SizedBox(
          height: 165,
          child: 
          Card(
            color: white,
            margin: const EdgeInsets.all(15),
            elevation: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                     ItemText(
                      false,
                      task.description,
                      task.selectedDate,
                      TimeOfDay.now(),
                  )
                    ,
                  ],
                ),
                // if (true)
                //   IconButton(
                //     icon: const Icon(Icons.edit),
                //     onPressed: () {
                //       showModalBottomSheet(
                //         context: context,
                //         builder: (_) => AddNewTask(
                //           id: task.actionRequiredId,
                //           isEditMode: true,
                //         ),
                //       );
                //     },
                //   ),
              ],
          ),
          ),
        ),
      ),
    );
  }
}
