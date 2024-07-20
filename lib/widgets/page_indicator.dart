import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uttam_toys/utils/custom_color.dart';

class PageIndicator extends StatelessWidget {
  final bool isActive;
  const PageIndicator({
    super.key,
    required this.isActive
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: 10,
        width: 10.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
              color: const Color(0XFF2FB7B2).withOpacity(0.72),
              blurRadius: 4.0,
              spreadRadius: 1.0,
              offset: const Offset(
                0.0,
                0.0,
              ),
            )
                : BoxShadow(
              color: Colors.transparent,
            ),
          ],
          borderRadius: isActive ? BorderRadius.circular(18.0) : BorderRadius.circular(18.0),
          shape: BoxShape.rectangle,
          color: isActive ? CustomColor.primaryColor : CustomColor.indicatorColor,
        ),
      ),
    );
  }
}
