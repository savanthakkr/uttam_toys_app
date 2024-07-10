import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uttam_toys_app/utils/custom_color.dart';
import 'package:uttam_toys_app/widgets/primary_button.dart';

import '../../utils/assets.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';
import '../../utils/size.dart';
import '../../utils/ui_utils.dart';
import '../../widgets/appbar_common.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();
  double rating=0;

  void _onBackPressed() {
    Navigator.of(context).pop();
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
            title: 'Review',
            leadingOnTap: _onBackPressed,
            hasBottom: true,
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.heightSize,
                horizontal: Dimensions.widthSize
            ),
            children: [
              Image.asset(
                Assets.train,
                height: 70,width: 70,),
              addVerticalSpace(Dimensions.heightSize,),
              Text('How would you rate it?',style: CustomStyle.blackMediumTextStyle,),
              _ratingBar(),
              addVerticalSpace(Dimensions.heightSize,),
              Text('Upload a photo',style: CustomStyle.blackMediumTextStyle,),
              _photoUpload(),
              addVerticalSpace(Dimensions.heightSize),
              Text('Title your review',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.4),
              _titleTextField(),
              addVerticalSpace(Dimensions.heightSize),
              Text('Write your review',style: CustomStyle.blackMediumTextStyle,),
              addVerticalSpace(Dimensions.heightSize*0.4),
              _reviewTextField(),
              addVerticalSpace(Dimensions.heightSize*1.5),
              PrimaryButtonWidget(
                  text: 'Submit',
                  onPressed: () {

                  },
              )
            ],
          ),
        )
    );
  }

  _ratingBar() {
    return RatingBar.builder(
      initialRating: 0,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemBuilder: (context, index) {
        return rating > index ? Icon(
          Icons.star_rounded,
          color: Colors.amber,
        )
        : Icon(
          Icons.star_border_rounded,
          color: Colors.amber,
        );
      },
      onRatingUpdate: (mRating) {
        debugPrint('Rating :$mRating');
        setState(() {
          rating = mRating;
        });
      },
    );
  }

  _photoUpload()
  {
    return DottedBorder(
      color: CustomColor.borderColor,
      radius: Radius.circular(Dimensions.radius),
      child: Container(
        decoration: const BoxDecoration(
            color: CustomColor.cardColor
        ),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.heightSize,
            horizontal: Dimensions.widthSize
        ),
        height: 120,
        child: Center(
          child: SvgPicture.asset(Assets.cameraSvg,height: 45,width: 45,),
        ),
      ),
    );
  }

  _titleTextField() {
    return TextFormField(
      controller: _titleController,
      keyboardType: TextInputType.text,
      maxLines: 1,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Title of your review',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) {
      //   if(value==null || value.isEmpty)
      //     {
      //       return 'I'
      //     }
      // },
    );
  }

  _reviewTextField() {
    return TextFormField(
      controller: _reviewController,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      cursorColor: CustomColor.primaryColor,
      decoration: InputDecoration(
        border: UIUtils.textInputBorder,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: UIUtils.textinputPadding,
        errorBorder: UIUtils.errorBorder,
        enabledBorder: UIUtils.textInputBorder,
        focusedBorder: UIUtils.textInputBorder,
        errorStyle: CustomStyle.errorTextStyle,
        filled: false,
        hintText: 'Write your experience with our product',
        hintStyle: CustomStyle.hintTextStyle,
        counterText: '',
        // fillColor: CustomColor.editTextColor,
      ),
      style: CustomStyle.inputTextStyle,
      textAlign: TextAlign.start,
      // autovalidateMode: AutovalidateMode.onUserInteraction,
      // validator: (value) {
      //   if(value==null || value.isEmpty)
      //     {
      //       return 'I'
      //     }
      // },
    );
  }
}
