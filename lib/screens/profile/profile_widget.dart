import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
 

// ignore: must_be_immutable
class BankingButton extends StatefulWidget {
  static String tag = '/BankingButton';
  var textContent;
  VoidCallback onPressed;
  var isStroked = false;
  var height = 50.0;
  var radius = 5.0;

  BankingButton(
      {Key? key, required this.textContent,
      required this.onPressed,
      this.isStroked = false,
      this.height = 45.0,
      this.radius = 5.0}) : super(key: key);

  @override
  BankingButtonState createState() => BankingButtonState();
}

class BankingButtonState extends State<BankingButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: widget.height,
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        alignment: Alignment.center,
        child: Text(
          widget.textContent.toUpperCase(),
          style: primaryTextStyle(
              color:
                  widget.isStroked ? Banking_Primary : Banking_whitePureColor,
              size: 18,
              fontFamily: fontMedium),
        ).center(),
      ),
    );
  }
}

Widget bankingOption(var icon, var heading, Color color) {
  return Container(
    padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
    child: Row(
      children: <Widget>[
        Row(
          children: <Widget>[
            Image.asset(icon, color: color, height: 20, width: 20),
            16.width,
            Text(heading,
                style: primaryTextStyle(
                    color: Banking_TextColorPrimary, size: 18)),
          ],
        ).expand(),
        const Icon(Icons.keyboard_arrow_right, color: Banking_TextColorSecondary),
      ],
    ),
  );
}

class TopCard extends StatelessWidget {
  final String name;
  final String acno;
  final String bal;

  const TopCard({Key? key, required this.name, required this.acno, required this.bal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                        color: Banking_Primary, size: 30)
                    .paddingOnly(top: 8, left: 8),
                Text(name, style: primaryTextStyle(size: 18))
                    .paddingOnly(left: 8, top: 8)
                    .expand(),
                const Icon(Icons.info, color: Banking_greyColor, size: 20)
                    .paddingOnly(right: 8)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Account Number", style: secondaryTextStyle(size: 16))
                  .paddingOnly(left: 8, top: 8, bottom: 8),
              Text(acno,
                      style: primaryTextStyle(color: Banking_TextColorYellow))
                  .paddingOnly(right: 8, top: 8, bottom: 8),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Balance", style: secondaryTextStyle(size: 16))
                  .paddingOnly(left: 8, top: 8, bottom: 8),
              Text(bal,
                      style:
                          primaryTextStyle(color: Banking_TextLightGreenColor))
                  .paddingOnly(right: 8, top: 8, bottom: 8),
            ],
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class EditText extends StatefulWidget {
  var isPassword;
  var isSecure;
  var fontSize;
  var textColor;
  var fontFamily;
  var text;
  var maxLine;
  TextEditingController? mController;

  VoidCallback? onPressed;

  EditText({Key? key, 
    var this.fontSize = textSizeNormal,
    var this.textColor = Banking_TextColorPrimary,
    var this.fontFamily = fontRegular,
    var this.isPassword = true,
    var this.isSecure = false,
    var this.text = "",
    var this.mController,
    var this.maxLine = 1,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return EditTextState();
  }
}

class EditTextState extends State<EditText> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isSecure) {
      return TextField(
          controller: widget.mController,
          obscureText: widget.isPassword,
          cursorColor: Banking_Primary,
          maxLines: widget.maxLine,
          style: TextStyle(
              fontSize: widget.fontSize,
              color: Banking_TextColorPrimary,
              fontFamily: widget.fontFamily),
          decoration: InputDecoration(
            hintText: widget.text,
            hintStyle: const TextStyle(fontSize: textSizeMedium),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Banking_Primary, width: 0.5),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Banking_TextColorSecondary, width: 0.5),
            ),
          ));
    } else {
      return TextField(
        controller: widget.mController,
        obscureText: widget.isPassword,
        cursorColor: Banking_Primary,
        style: TextStyle(
            fontSize: widget.fontSize,
            color: Banking_TextColorPrimary,
            fontFamily: widget.fontFamily),
        decoration: InputDecoration(
            hintText: widget.text,
            hintStyle: const TextStyle(fontSize: textSizeMedium),
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  widget.isPassword = !widget.isPassword;
                });
              },
              child: Icon(
                widget.isPassword ? Icons.visibility : Icons.visibility_off,
                color: Banking_TextColorSecondary,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide:
                  BorderSide(color: Banking_TextColorSecondary, width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Banking_Primary, width: 0.5),
            )),
      );
    }
  }
}

Widget headerView(var title, double height, BuildContext context) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.chevron_left,
              size: 25,
              color: Banking_blackColor,
            ).paddingAll(6).paddingOnly(top: spacing_standard).onTap(() {
              finish(context);
            }).paddingOnly(
                left: spacing_standard,
                right: spacing_standard_new,
                top: spacing_standard_new,
                bottom: spacing_standard),
          ],
        ),
        Text(title,
                style: primaryTextStyle(
                    color: Banking_TextColorPrimary,
                    size: 30,
                    fontFamily: fontBold))
            .paddingOnly(left: spacing_standard_new, right: spacing_standard),
      ],
    ),
  );
}



const Banking_Primary = Color(0xFF008000);
const Banking_Secondary = Color(0xFF4a536b);
const Banking_ColorPrimaryDark = Color(0x000fffff);

const Banking_TextColorPrimary = Color(0xFF070706);
const Banking_TextColorSecondary = Color(0xFF747474);
const Banking_TextColorWhite = Color(0xFFffffff);
const Banking_TextColorOrange = Color(0xFF008000);
const Banking_TextColorYellow = Color(0xFF242525);
const Banking_TextLightGreenColor = Color(0xFF8ed16f);

const Banking_app_Background = Color(0xFFf3f5f9);
const Banking_blackColor = Color(0xFF070706);
const Banking_view_color = Color(0XFFDADADA);
const Banking_blackLightColor = Color(0xFF242525);
const Banking_shadowColor = Color(0X95E9EBF0);
const Banking_greyColor = Color(0xFFA3A0A0);
const Banking_bottomEditTextLineColor = Color(0xFFDBD9D9);
const Banking_backgroundFragmentColor = Color(0xFFF7F5F5);
const Banking_palColor = Color(0xFF4a536b);
const Banking_BalanceColor = Color(0xFF8ed16f);
const Banking_whitePureColor = Color(0xFFffffff);
const Banking_subTitleColor = Color(0xFF5C5454);
const Banking_blueColor = Color(0xFF041887);
const Banking_blueLightColor = Color(0xFF41479B);
const Banking_pinkColor = Color(0xFFE91E63);
const Banking_RedColor = Color(0xFFD80027);
const Banking_greenLightColor = Color(0xFF05E10E);
const Banking_skyBlueColor = Color(0xFF03A9F4);
const Banking_pinkLightColor = Color(0xFFE7586A);
const Banking_purpleColor = Color(0xFFAD3AC3);

/*fonts*/
const fontRegular = 'Regular';
const fontMedium = 'Medium';
const fontSemiBold = 'Semibold';
const fontBold = 'Bold';

/* font sizes*/
const textSizeSmall = 12.0;
const textSizeSMedium = 14.0;
const textSizeMedium = 16.0;
const textSizeLargeMedium = 18.0;
const textSizeNormal = 20.0;
const textSizeLarge = 24.0;
const textSizeXLarge = 28.0;
const textSizeXXLarge = 30.0;
const textSizeBig = 50.0;

const spacing_control_half = 2.0;
const spacing_control = 4.0;
const spacing_standard = 8.0;
const spacing_middle = 10.0;
const spacing_standard_new = 16.0;
const spacing_large = 24.0;
const spacing_xlarge = 32.0;
const spacing_xxLarge = 40.0;
