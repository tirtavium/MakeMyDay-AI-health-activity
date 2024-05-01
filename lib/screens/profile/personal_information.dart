import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/resources/bmi_calculator.dart';
import 'package:MakeMyDay/screens/diaryScreen/fitness_app_theme.dart';
import 'package:MakeMyDay/screens/profile/conditionScreen/widgets/image_text_card.dart';
import 'package:MakeMyDay/screens/profile/conditionScreen/widgets/reuseable_card.dart';
import 'package:MakeMyDay/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PersonalInformation extends StatefulWidget {
  String height = '';
  String weight = '';
  String bmi = '';
  String caloriesPerDay = '';
  DateTime dateOfBirth = DateTime.now();
  String gender = '';
  int age = 0;

  PersonalInformation({Key? key}) : super(key: key);

  @override
  _PersonalInformationState createState() => _PersonalInformationState();
}

const Color inactiveCard = Color(0xFF303030);
const Color activeCard = Color.fromARGB(255, 208, 24, 24);

class _PersonalInformationState extends State<PersonalInformation> {
  final _formKey = GlobalKey<FormState>();
  Color maleCard = inactiveCard, femaleCard = inactiveCard;

  void updateGenderSelected(int x) {
    if (x == 1) {
      widget.gender = "Male";
      maleCard = activeCard;
      femaleCard = inactiveCard;
    } else {
      widget.gender = "Female";
      maleCard = inactiveCard;
      femaleCard = activeCard;
    }
  }

  void _pickUserDueDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1945),
            lastDate: DateTime.now())
        .then((date) {
      if (date == null) {
        return;
      }
      date = date;
      setState(() {
        widget.dateOfBirth = date!;
      });
    });
  }

  void _validateForm(UserProvider userProvider) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final user = userProvider.getUser!;
      user.dateOfBirth = widget.dateOfBirth;
      user.height = double.tryParse(widget.height);
      user.weight = double.tryParse(widget.weight);
      widget.age = calculateAge(widget.dateOfBirth);
      final calculator = BmiCalculator(
        height: widget.height.toInt(),
        weight: widget.weight.toInt(),
        age: widget.age,
        gender: widget.gender,
        goal: 'Lose 1kg per week',
        activity: 'Light exercise (1–3 days per week)',
      );
      final bmiData = calculator.calculate();
      user.bmi = calculator.getBMIScore();
      calculator.calculateBMR();
      calculator.getActivity();

      widget.caloriesPerDay = calculator.getGoal();
      widget.bmi = bmiData;
      widget.age = calculateAge(widget.dateOfBirth);
      user.caloriesPerDay = double.tryParse(widget.caloriesPerDay);
      user.gender = widget.gender;
      userProvider.updateUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    initData(userProvider);
    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: FitnessAppTheme.background,
        title: Text("Personal Information",
            style: boldTextStyle(color: FitnessAppTheme.darkText, size: 35)),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Weight in KG',
                  style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                initialValue: widget.weight,
                decoration: const InputDecoration(
                  hintText: 'Weight in KG',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  widget.weight = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Height in CM',
                  style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                initialValue: widget.height,
                decoration: const InputDecoration(
                  hintText: 'Height in CM',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (value) {
                  widget.height = value!;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Date Of Birth',
                  style: Theme.of(context).textTheme.titleMedium),
              TextFormField(
                onTap: () {
                  _pickUserDueDate();
                },
                readOnly: true,
                decoration: InputDecoration(
                  hintText: widget.dateOfBirth == null
                      ? 'Provide your birth date'
                      : DateFormat.yMMMd()
                          .format(widget.dateOfBirth)
                          .toString(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print("FEMALE");
                      updateGenderSelected(2);
                    });
                  },
                  child: ReusableCard(
                    color: femaleCard,
                    card: const ImageTextCard(
                      text: 'FEMALE',
                      icon: FontAwesomeIcons.venus,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      print("MALE");
                      updateGenderSelected(1);
                    });
                  },
                  child: ReusableCard(
                    color: maleCard,
                    card: const ImageTextCard(
                      text: "MALE",
                      icon: FontAwesomeIcons.mars,
                    ),
                  ),
                ),
              ),],
              )
              ,
              Text('BMI : ${widget.bmi}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                height: 20,
              ),
              Text('calories per day : ${widget.caloriesPerDay}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                height: 20,
              ),
              Text('age : ${widget.age}',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  child: Text(
                    'Save',
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
      ),
    );
  }

  void initData(UserProvider userProvider) {
    final user = userProvider.getUser!;
    if (widget.weight.isEmpty) {
      widget.weight = user.weight.toString();
      widget.height = user.height.toString();
      widget.dateOfBirth = user.dateOfBirth ?? DateTime.now();
      widget.age = calculateAge(widget.dateOfBirth);
      widget.caloriesPerDay = user.caloriesPerDay.toString();
      widget.gender = user.gender ?? 'male';
      if (user.bmi != null) {
        widget.bmi = user.bmi!.toStringAsFixed(1);
      }

      if (user.gender != null && user.gender!.toLowerCase() == 'male') {
        updateGenderSelected(1);
      } else {
        updateGenderSelected(2);
      }
    }
  }
}
