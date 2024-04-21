import 'package:flutter/material.dart';
import 'package:MakeMyDay/screens/diaryScreen/fitness_app_theme.dart';
import 'package:intl/intl.dart';

//Just shows the text inside a ListItem.
// Show due date and due time if they exist.
//### MISSING FEATURES ###
//Code needs to be refactored.
// Treat text overflow.

class ItemText extends StatelessWidget {
  final bool check;
  final String text;
  final DateTime dueDate;
  final TimeOfDay dueTime;

  const ItemText(this.check, this.text, this.dueDate, this.dueTime, {Key? key})
      : super(key: key);

  Widget _buildText(BuildContext context) {
    double cWidth = MediaQuery.of(context).size.width * 0.8;
    if (check) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: const TextStyle(color: FitnessAppTheme.darkText),
              children: [
                TextSpan(
                  style: const TextStyle(color: FitnessAppTheme.darkText),
                  text: text,
                ),
              ],
            ),
          ),
          // Text(
          //   text,
          //   overflow: TextOverflow.ellipsis,
          //   style: const TextStyle(
          //       fontSize: 22,
          //       color: Colors.grey,
          //       decoration: TextDecoration.lineThrough),
          // ),
          _buildDateTimeTexts(context),
        ],
      );
    }
    return Container(
        padding: const EdgeInsets.all(3.0),
        width: cWidth,
        child: Column(
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
            const SizedBox(
              height: 25,
            ),
            _buildDateTimeTexts(context),
          ],
        ));
  }

  Widget _buildDateText(BuildContext context) {
    return Text(
      DateFormat.yMMMd().format(dueDate).toString(),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        color: check ? Colors.grey : Theme.of(context).primaryColorDark,
      ),
    );
  }

  Widget _buildTimeText(BuildContext context) {
    return Text(
      dueTime.format(context),
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        color: check ? Colors.grey : Theme.of(context).primaryColorDark,
      ),
    );
  }

  Widget _buildDateTimeTexts(BuildContext context) {
    if (dueTime == null) {
      return _buildDateText(context);
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildDateText(context),
          const SizedBox(
            width: 10,
          ),
          _buildTimeText(context),
        ],
      );
    }

    return Container();
    //What would be a better approach?
  }

  @override
  Widget build(BuildContext context) {
    return _buildText(context);
    //Search if it's ok to return something like this :P
  }
}
