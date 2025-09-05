import 'package:flutter/material.dart';
import 'package:work_zone/data/data_provider/remote_url.dart';
import 'package:work_zone/presentation/utils/utils.dart';
import 'package:work_zone/presentation/widgets/circle_image.dart';

import '../../../../data/models/home/seller_model.dart';
import '../../../utils/constraints.dart';
import '../../../widgets/custom_text.dart';


class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.item,this.isBorder});

  final SellerModel? item;
  final bool? isBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Utils.symmetric(h: 0.0,v: 12.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isBorder??true? borderColor:transparent))
      ),
      child: Row(
        children: [
          CircleImage(image: RemoteUrls.imageUrl(item?.image??Utils.defaultImg(context)),size: 50.0,),
          Utils.horizontalSpace(12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: item?.name??'',fontWeight: FontWeight.w400,fontSize: 16.0,color: blackColor,height: 1.6,),
              CustomText(text: item?.designation??'',fontWeight: FontWeight.w400,fontSize: 14.0,color: gray5B),
            ],
          ),
        ],
      ),
    );
  }
}
