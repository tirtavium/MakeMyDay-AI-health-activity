// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';

enum BMILevelEnum { over, normal, under }

extension BMILevel on BMILevelEnum {
  String getString() {
    switch (this) {
      case BMILevelEnum.over:
        return "over weight";
      case BMILevelEnum.normal:
        return "normal";
      case BMILevelEnum.under:
        return "under weight";
    }
  }

}

class BmiCalculator {
  BmiCalculator(
      {required this.age,
      required this.gender,
      required this.goal,
      required this.activity,
      required this.height,
      required this.weight});
  final int height;
  final int weight;
  final int age;
  final String gender, goal, activity;
  double bmi = 0, _calorie_activity = 0, calorie_goal = 0, _bmr = 0;

  String calculate() {
    bmi = (weight / pow(height / 100, 2));
    return bmi.toStringAsFixed(1);
  }

  double getMinimumProteinInTake(){
    final minimumProteinIntake = 1.4 * weight.toDouble();
    return minimumProteinIntake;
  }

  double getMinimumCarbsIntake(){
    final minimumCarbsIntake = 0.4 * calorie_goal;
    return minimumCarbsIntake;
  }

  double getBodyFatPercentage(){
     if (gender.toLowerCase() == 'female'){
      return 1.20 * bmi + 0.23 * age - 5.4;
     }else{
      return 1.20 * bmi + 0.23 * age - 16.2;
     }
  }

  BMILevelEnum getBMILevel() {
    if (bmi >= 25) {
      return BMILevelEnum.over;
    } else if (bmi > 18.5) {
      return BMILevelEnum.normal;
    } else {
      return BMILevelEnum.under;
    }
  }

  double getBMIScore() {
    return bmi;
  }

  String getAdvise() {
    if (bmi >= 25) {
      return 'You have a more than normal body weight.\n Try to do more Exercise';
    } else if (bmi > 18.5) {
      return 'You have a normal body weight.\nGood job!';
    } else {
      return 'You have a lower than normal body weight.\n Try to eat more';
    }
  }

  String calculateBMR() {
    if (gender.toLowerCase() == 'female') {
      _bmr = (10 * weight + 6.25 * height * 2.54 - 5 * age - 161) - 166;
    } else {
      _bmr = (10 * weight + 6.25 * height - 5 * age + 5) + 166;
    }
    return _bmr.toStringAsFixed(2);
    // return height.toString();
  }

  String getActivity() {
    if (activity == "Little to no exercise") {
      _calorie_activity = _bmr * 1.2;
    } else if (activity == "Light exercise (1–3 days per week)")
      _calorie_activity = _bmr * 1.375;
    else if (activity == "Moderate exercise (3–5 days per week)")
      _calorie_activity = _bmr * 1.55;
    else if (activity == "Heavy exercise (6–7 days per week")
      _calorie_activity = _bmr * 1.725;
    else
      _calorie_activity = _bmr * 1.9;
    return _calorie_activity.toStringAsFixed(2);
  }

  String getGoal() {
    if (goal == "Lose 0.5kg per week") {
      calorie_goal = _calorie_activity - 500;
    } else if (goal == "Lose 1kg per week")
      calorie_goal = _calorie_activity - 1000;
    else if (goal == "Gain 0.5kg per week")
      calorie_goal = _calorie_activity + 500;
    else if (goal == "Gain 1kg per week")
      calorie_goal = _calorie_activity + 1000;
    else
      calorie_goal = _calorie_activity;
    return calorie_goal.toStringAsFixed(2);
  }

  String getResult() {
    if (bmi >= 25) {
      return "Overweight";
    } else if (bmi > 18.5)
      return "Normal";
    else
      return "Underweight";
  }

  String getInterpretation() {
    if (bmi >= 25) {
      return "You have a higher than normal body weight. Try to exercise more.";
    } else if (bmi > 18.5)
      return "You have normal body weight. Good Job!!";
    else
      return "You have a lower than normal body weight. You can eat a bit more.";
  }
}
