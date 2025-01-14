import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/features/order/widgets/custom_stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TrackingStepperWidget extends StatelessWidget {
  final String? status;
  final bool takeAway;
  const TrackingStepperWidget({super.key, required this.status, required this.takeAway});

  @override
  Widget build(BuildContext context) {
    int state = -1;
    if(status == 'pending') {
      state = 0;
    }else if(status == 'accepted' || status == 'confirmed') {
      state = 1;
    }else if(status == 'processing') {
      state = 2;
    }else if(status == 'handover') {
      state = takeAway ? 3 : 2;
    }else if(status == 'picked_up') {
      state = 3;
    }else if(status == 'delivered') {
      state = 4;
    }

    return Container(height: 700,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Column(children: [
        CustomStepperWidget(
          title: 'order_placed'.tr, isActive: state > -1, haveLeftBar: false, haveRightBar: true, rightActive: state > 0,haveBottomBar: true, haveTopBar: false,
        ),
        CustomStepperWidget(
          title: 'order_confirmed'.tr, isActive: state > 0, haveLeftBar: true, haveRightBar: true, rightActive: state > 1,haveBottomBar: true, haveTopBar: true,
        ),
        CustomStepperWidget(
          title: 'preparing_item'.tr, isActive: state > 1, haveLeftBar: true, haveRightBar: true, rightActive: state > 2,haveBottomBar: true, haveTopBar: true,
        ),
        CustomStepperWidget(
          title: takeAway ? 'ready_for_handover'.tr : 'delivery_on_the_way'.tr, isActive: state > 2, haveLeftBar: true, haveRightBar: true, rightActive: state > 3,haveBottomBar: true, haveTopBar: true,
        ),
        CustomStepperWidget(
          title: 'delivered'.tr, isActive: state > 3, haveLeftBar: true, haveRightBar: false, rightActive: state > 4,haveBottomBar: true, haveTopBar: true,
        ),
      ]),
    );
  }
}
