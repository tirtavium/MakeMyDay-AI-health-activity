import 'package:flutter/material.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/screens/profile/profile_constant.dart';
import 'package:provider/provider.dart';

//Show a bottom sheet that allows the user to create or edit a task.
//### MISSING FEATURES ###
// Proper Form Focus and keyboard actions.
// BottomModalSheet size is too big and doesn't work proper with keyboard.
// Keyboard must push the sheet up so the "ADD TASK" button is visible.

class AddNewCondition extends StatefulWidget {
  final bool isEditMode;
  final String? editConditionString;
  final int editIndex;
  final ConditionType conditionType;
  const AddNewCondition(
      {Key? key, required this.isEditMode,
      this.editConditionString,
      this.editIndex = 0,
      required this.conditionType}) : super(key: key);

  @override
  _AddNewConditionState createState() => _AddNewConditionState();
}

class _AddNewConditionState extends State<AddNewCondition> {
  late String _inputDescription = "";

  final _formKey = GlobalKey<FormState>();

  void _validateForm(UserProvider userProvider) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      updateConditionList(userProvider);
      Navigator.of(context).pop();
    }
  }

  void updateConditionList(UserProvider userProvider) {
    
    final user = userProvider.getUser!;

    switch (widget.conditionType) {
      case ConditionType.currentMedication:
        if (!widget.isEditMode) {
          user.medicationCurrent.add(_inputDescription);
        } else {
          _inputDescription = widget.editConditionString ?? "";
          user.medicationCurrent.removeAt(widget.editIndex);
          user.medicationCurrent.add(_inputDescription);
        }
        break;
      case ConditionType.foodAlergies:
        if (!widget.isEditMode) {
          user.foodAlergies.add(_inputDescription);
        } else {
          _inputDescription = widget.editConditionString ?? "";
          user.foodAlergies.removeAt(widget.editIndex);
          user.foodAlergies.add(_inputDescription);
        }
        break;
      case ConditionType.healthCondition:
        if (!widget.isEditMode) {
          user.healthConditions.add(_inputDescription);
        } else {
          _inputDescription = widget.editConditionString ?? "";
          user.healthConditions.removeAt(widget.editIndex);
          user.healthConditions.add(_inputDescription);
        }
        break;
    }
    
    userProvider.updateUser(user);
  }

  @override
  void initState() {
    if (widget.isEditMode) {
      _inputDescription = widget.editConditionString ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.conditionType.getTitle(),
                style: Theme.of(context).textTheme.titleMedium),
            TextFormField(
              initialValue: _inputDescription ?? "",
              decoration: const InputDecoration(
                hintText: 'Describe your condition',
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
            Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                child: Text(
                  !widget.isEditMode ? 'Add' : 'Edit',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontFamily: 'Lato',
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _validateForm(userProvider);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
