import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/OrderStatusModel.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../widgets/appbar_common.dart';

class ReplacementStatusScreen extends StatefulWidget {
  const ReplacementStatusScreen({super.key});

  @override
  State<ReplacementStatusScreen> createState() => _ReplacementStatusScreenState();
}

class _ReplacementStatusScreenState extends State<ReplacementStatusScreen> {
  int activeStep =0;
  List<OrderStatusModel> orderStatusList = <OrderStatusModel>[];

  void _onBackPressed() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    setOrderStatusList();
  }

  setOrderStatusList(){
    setState(() {
      orderStatusList.add(OrderStatusModel('Request submitted',true));
      orderStatusList.add(OrderStatusModel('Delivery agent will pick the item on 10-05-2024',false));
      orderStatusList.add(OrderStatusModel('Item reached on workshop',false));
      orderStatusList.add(OrderStatusModel('Replaced order shipped',false));
      orderStatusList.add(OrderStatusModel('Out for delivery',false));
      orderStatusList.add(OrderStatusModel('Arriving today by 07:00-19:00',false));
    });
  }
  @override
  Widget build(BuildContext context) {
    return PopScope(
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          if (context.mounted) {
            _onBackPressed();
          }
        },
        child: Scaffold(
          backgroundColor: CustomColor.backgroundColor,
          appBar: CommonAppbar(
            title: 'Replacement Request',
            leadingOnTap: _onBackPressed,
            hasBottom: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            children: [
              _orderStatus()
            ],
          ),
        )
    );
  }

  _orderStatus() {
    return Stepper(
      margin: EdgeInsets.zero,
      currentStep: activeStep,
      stepIconBuilder: (stepIndex, stepState) {
        return Container(
          decoration: BoxDecoration(
            color: stepIndex <= activeStep ? CustomColor.primaryColor : CustomColor.whiteColor,
            borderRadius: BorderRadius.circular(Dimensions.radius*0.2),
            border: Border.all(
                color: stepIndex <= activeStep ? CustomColor.primaryColor : CustomColor.borderColor,width: 0.8)
          ),
          child: Icon(Icons.done,
            color: stepIndex <= activeStep ? CustomColor.whiteColor : CustomColor.cardColor,),
        );
      },
      controlsBuilder: (context, details) {
        return Container();
      },
      type: StepperType.vertical,
      onStepCancel: () {
        if (activeStep > 0) {
          setState(() {
            activeStep -= 1;
          });
        }
      },
      onStepContinue: () {
        if (activeStep <= 0) {
          setState(() {
            activeStep += 1;
          });
        }
      },
      onStepTapped: (int index) {
        // setState(() {
        //   activeStep = index;
        // });
      },
      steps: <Step>[
        for(int i=0;i<orderStatusList.length;i++)
          _buildOrderStatusStep(i)
      ],
    );
  }

  _buildOrderStatusStep(int index)
  {
    return Step(
      title: Text(orderStatusList.elementAt(index).status ?? '',style: CustomStyle.inputTextStyle,),
      label: Icon(Icons.add),
      content: Container(),
    );
  }
}
