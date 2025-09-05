import 'package:flutter/material.dart';

import '../../../../utils/constraints.dart';
import '../../../../utils/k_images.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';
import '../../../../widgets/feedback_dialog.dart';
import '../../../../widgets/primary_button.dart';

class DeclinedOrderDialog extends StatelessWidget {
  const DeclinedOrderDialog({
    super.key,
    required this.onDelete,
    this.successText = 'Delete',
    this.cancelText = 'Cancel',
    this.messageText = 'Delete Booking?',
    this.subMessageText = 'Do you want to Delete this booking?',
    this.cancelColor = primaryColor,
    this.deleteColor = redColor,
  });

  final VoidCallback onDelete;
  final String successText;
  final String cancelText;
  final String messageText;
  final String subMessageText;
  final Color cancelColor;
  final Color deleteColor;

  @override
  Widget build(BuildContext context) {
    return FeedBackDialog(
      image: KImages.declinedIcon,
      height: Utils.vSize(dialogHeight - 10.0),
      message: messageText,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: subMessageText,
            textAlign: TextAlign.center,
            color: const Color(0xFF535769),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            height: 1.43,
          ),
          Utils.verticalSpace(24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: PrimaryButton(
                  text: cancelText,
                  onPressed: () => Navigator.of(context).pop(),
                  borderRadiusSize: 4.0,
                  textColor: whiteColor,
                  fontSize: 14.0,
                  bgColor: cancelColor,
                  minimumSize: Size(Utils.hSize(150.0), Utils.vSize(52.0)),
                  maximumSize: Size(Utils.hSize(150.0), Utils.vSize(52.0)),
                ),
              ),
              Utils.horizontalSpace(20),
              Expanded(
                child: PrimaryButton(
                  text: successText,
                  onPressed: onDelete,
                  bgColor: deleteColor,
                  textColor: whiteColor,
                  borderRadiusSize: 4.0,
                  fontSize: 13.5,
                  minimumSize: Size(Utils.hSize(156.0), Utils.vSize(52.0)),
                  maximumSize: Size(Utils.hSize(156.0), Utils.vSize(52.0)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
