import 'package:flutter/material.dart';
import 'package:MakeMyDay/providers/user_provider.dart';
import 'package:MakeMyDay/resources/auth_methods.dart';
import 'package:MakeMyDay/screens/diaryScreen/fitness_app_theme.dart';
import 'package:MakeMyDay/screens/login_screen.dart';
import 'package:MakeMyDay/screens/profile/conditionScreen/profile_condition_list_screen.dart';
import 'package:MakeMyDay/screens/profile/personal_information.dart';
import 'package:MakeMyDay/screens/profile/profile_constant.dart';
import 'package:MakeMyDay/screens/profile/profile_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
const assetTest = 'assets/fitness_app/breakfast.png';
class ProfileScreenMenu extends StatefulWidget {

  const ProfileScreenMenu({Key? key}) : super(key: key);
  @override
  _ProfileScreenMenuState createState() => _ProfileScreenMenuState();
}


class _ProfileScreenMenuState extends State<ProfileScreenMenu> {
  
  
  @override
  void initState() {
    super.initState();
     
  }
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: FitnessAppTheme.background,
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              10.height,
              Text(labelProfile,
                  style:
                      boldTextStyle(color: FitnessAppTheme.darkText, size: 35)),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                        backgroundImage: NetworkImage(
                              userProvider.getUser!.photoUrl,
                            ),
                        backgroundColor: FitnessAppTheme.background,
                        radius: 40),
                    10.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        5.height,
                        Text(userProvider.getUser!.username,
                            style: boldTextStyle(
                                color: FitnessAppTheme.darkText, size: 18)),
                        5.height,
                        Text(userProvider.getUser!.bio,
                            style: primaryTextStyle(
                                color: FitnessAppTheme.lightText,
                                size: 16,
                                fontFamily: fontFamilySecondaryGlobal)),
                      ],
                    ).expand()
                  ],
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    bankingOption(assetTest, labelSetupPersonalInformation,
                        Banking_blueColor).onTap(() {
                        PersonalInformation().launch(context);
                    }),
                  ],
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    10.height,
                    bankingOption(assetTest, labelSetupHealthCondition,
                            Banking_blueColor)
                        .onTap(() {
                          const ProfileConditionScreen(conditionType: ConditionType.healthCondition).launch(context);
                    }),
                    bankingOption(
                            assetTest,
                            labelSetupCurrentMedication,
                            Banking_greenLightColor)
                        .onTap(() {
                     const ProfileConditionScreen(conditionType: ConditionType.currentMedication).launch(context);
                    }),
                    bankingOption(assetTest, labelSetupFoodAlergies,
                            Banking_greenLightColor)
                        .onTap(() {
                      const ProfileConditionScreen(conditionType: ConditionType.foodAlergies).launch(context);
                    }),
                    10.height,
                  ],
                ),
              ),
              16.height,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: boxDecorationWithShadow(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: <Widget>[
                    bankingOption(assetTest, labelLogout,
                            Banking_pinkColor)
                        .onTap(() {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const CustomDialog(),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}

dialogContent(BuildContext context) {
  return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black26,
              blurRadius: 10.0,
              offset: Offset(0.0, 10.0)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          16.height,
          Text(labelLogoutConfirmation,
                  style: primaryTextStyle(size: 18))
              .onTap(() {
            finish(context);
          }).paddingOnly(top: 8, bottom: 8),
          const Divider(height: 10, thickness: 1.0, color: Banking_greyColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Cancel", style: primaryTextStyle(size: 18)).onTap(() {
                finish(context);
              }).paddingRight(16),
              Container(width: 1.0, height: 40, color: Banking_greyColor)
                  .center(),
              Text("Logout",
                      style: primaryTextStyle(size: 18, color: Banking_Primary))
                  .onTap(() async {
                finish(context);
                await AuthMethods().signOut();
                                              if (context.mounted) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const LoginScreen(),
                                                  ),
                                                );
                                              }
              }).paddingLeft(16)
            ],
          ),
          16.height,
        ],
      ));
}
