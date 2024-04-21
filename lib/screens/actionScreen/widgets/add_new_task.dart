import 'package:flutter/material.dart';
import 'package:MakeMyDay/models/ActionRequired.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../providers/task.dart';

//Show a bottom sheet that allows the user to create or edit a task.
//### MISSING FEATURES ###
// Proper Form Focus and keyboard actions.
// BottomModalSheet size is too big and doesn't work proper with keyboard.
// Keyboard must push the sheet up so the "ADD TASK" button is visible.

class AddNewTask extends StatefulWidget {
  final String? id;
  final bool isEditMode;

  const AddNewTask({Key? key, 
    this.id,
    required this.isEditMode,
  }) : super(key: key);

  @override
  _AddNewTaskState createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  late Task task;
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late DateTime _selectedDate = DateTime.now();
  late String _inputDescription = "";
  final _formKey = GlobalKey<FormState>();
  late final UserProvider userProvider ;


  
  void _pickUserDueDate() {
    showDatePicker(
            context: context,
            initialDate: widget.isEditMode ? _selectedDate : DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2030))
        .then((date) {
      if (date == null) {
        return;
      }
      date = date;
      setState(() {
        _selectedDate = date!;
      });
    });
  }

  void _pickUserDueTime() {
    showTimePicker(
      context: context,
      initialTime: widget.isEditMode ? _selectedTime : TimeOfDay.now(),
    ).then((time) {
      if (time == null) {
        return;
      }
      setState(() {
        _selectedTime = time;
      });
    });
  }

  Future<void> _validateForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _selectedDate ??= DateTime.now();
      if (!widget.isEditMode) {
        // Provider.of<TaskProvider>(context, listen: false).createNewTask(
        //   Task(
        //     id: DateTime.now().toString(),
        //     description: _inputDescription,
        //     dueDate: _selectedDate,
        //     dueTime: _selectedTime,
        //   ),
        // );
      } else {
        // Provider.of<TaskProvider>(context, listen: false).editTask(
        //   Task(
        //     id: task.id,
        //     description: _inputDescription,
        //     dueDate: _selectedDate,
        //     dueTime: _selectedTime,
        //   ),
        // );
      }
      final uid = userProvider.getUser!.uid;
      final username = userProvider.getUser!.username;
      String actionId = const Uuid().v1(); 
      final actionRequired = ActionRequiredPost(selectedDate: DateTime.now(), description: _inputDescription, uid: uid, username: username, datePublished: DateTime.now(), actionRequiredId: actionId);
      await FireStoreMethods().uploadActionRequiderPost(actionRequired);
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    userProvider = context.read<UserProvider>();
    if (widget.isEditMode) {
      // task =
      //     Provider.of<TaskProvider>(context, listen: false).getById(widget.id!);
      // _selectedDate = task.dueDate;
      // _selectedTime = task.dueTime;
      // _inputDescription = task.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Title', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue:
                  _inputDescription ?? "",
              decoration: const InputDecoration(
                hintText: 'Describe your task',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) {
                _inputDescription = value!;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Due date', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              onTap: () {
                _pickUserDueDate();
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: _selectedDate == null
                    ? 'Provide your due date'
                    : DateFormat.yMMMd().format(_selectedDate).toString(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Due time', style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              onTap: () {
                _pickUserDueTime();
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: _selectedTime == null
                    ? 'Provide your due time'
                    : _selectedTime.format(context),
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  !widget.isEditMode ? 'ADD TASK' : 'EDIT TASK',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _validateForm();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
