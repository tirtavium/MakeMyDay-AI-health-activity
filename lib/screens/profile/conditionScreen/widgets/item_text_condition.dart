import 'package:flutter/material.dart';
import 'package:MakeMyDay/screens/diaryScreen/fitness_app_theme.dart';

//Just shows the text inside a ListItem.
// Show due date and due time if they exist.
//### MISSING FEATURES ###
//Code needs to be refactored.
// Treat text overflow.

class ItemTextCondition extends StatelessWidget {
  
  final String text;
   

  const ItemTextCondition(
    this.text, {Key? key}
  ) : super(key: key);

  Widget _buildText(BuildContext context) {
    return Column(
      
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
                    text: TextSpan(
                      style: const TextStyle(color: FitnessAppTheme.darkText),
                      children: [
                        TextSpan(
                          text: text,
                        ),
                      ],
                    ),
                  ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildText(context);
    //Search if it's ok to return something like this :P
  }
}
