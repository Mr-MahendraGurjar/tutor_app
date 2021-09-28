import 'package:flutter/material.dart';
import 'package:tutor_app/widgets/constants.dart';

class CustomButtons extends StatelessWidget {
  final VoidCallback onSubmitPressed;
  final double width;
  final String title;

  CustomButtons({
     this.onSubmitPressed,
     this.width,
     this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(Constants.radius),
      ),
      child: Center(
        child: InkWell(
          onTap: onSubmitPressed,
          child: Container(
            width: width,
            height: 50,
            child: Center(
                child: Text(
              title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            )),
          ),
        ),
      ),
    );
  }
}
