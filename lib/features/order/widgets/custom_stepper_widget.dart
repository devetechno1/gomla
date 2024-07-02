import 'package:flutter/widgets.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/util/styles.dart';
import 'package:flutter/material.dart';

class CustomStepperWidget extends StatelessWidget {
  final bool isActive;
  final bool haveLeftBar;
  final bool haveRightBar;
  final bool haveBottomBar;
  final bool haveTopBar;
  final String title;
  final bool rightActive;
  const CustomStepperWidget({super.key, required this.title, required this.isActive, required this.haveLeftBar, required this.haveRightBar,
    required this.rightActive, required this.haveBottomBar, required this.haveTopBar});

  @override
  Widget build(BuildContext context) {
    Color color = isActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;
    Color right = rightActive ? Theme.of(context).primaryColor : Theme.of(context).disabledColor;

    return Expanded(
      child: Row( mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
          children: [

        Column(
            children: [
          Expanded(child: haveLeftBar ? VerticalDivider(color: color, thickness: 5) : const SizedBox()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isActive ? 0 : 5),
            child: Icon(isActive ? Icons.check_circle : Icons.blur_circular, color: color, size: isActive ? 35 : 25),
          ),
          Expanded(child: haveRightBar ? VerticalDivider(color: right, thickness: 5) : const SizedBox()),
        ]),

        const SizedBox(width: 20,),

        Text(
          '$title\n', maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
          style: robotoMedium.copyWith(color: color, fontSize: Dimensions.fontSizeLarge),
        ),

      ]),
    );
  }
}
