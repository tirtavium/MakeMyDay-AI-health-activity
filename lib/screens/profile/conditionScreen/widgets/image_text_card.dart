import 'package:flutter/cupertino.dart';

class ImageTextCard extends StatelessWidget {
  const ImageTextCard({Key? key, required this.text, required this.icon}) : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 50,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFFDCDCDC),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
