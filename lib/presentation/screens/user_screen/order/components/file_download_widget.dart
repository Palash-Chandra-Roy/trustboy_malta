import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../logic/cubit/buyer_order/buyer_order_cubit.dart';
import '../../../../utils/constraints.dart';
import '../../../../utils/utils.dart';
import '../../../../widgets/custom_text.dart';


class FileDownloadWidget extends StatelessWidget {
  final String id;
  final String extension;

  const FileDownloadWidget({super.key, required this.id,required this.extension});

  @override
  Widget build(BuildContext context) {
    final download = context.read<BuyerOrderCubit>();

    return GestureDetector(
      onTap: ()  async{
        bool permissionGranted = await Utils.getStoragePermission();
        if (permissionGranted) {
          final result = await download.chatFileDownload(id,extension);

          result.fold((failure) {
            Utils.errorSnackBar(context, Utils.translatedText(context, 'Something went wrong'));
          }, (success) {
            // Navigator.of(context).pop();
            if (success) {
              Utils.showSnackBar(context, Utils.translatedText(context, 'Successfully file downloaded'));
            } else {
              Utils.errorSnackBar(context, Utils.translatedText(context, 'File download failed.'));
            }
          });
        }
        else {
          Utils.errorSnackBar(context, Utils.translatedText(context, 'Storage permission is required to download files.'));
        }
      },
      child:  CustomText(
        text: Utils.translatedText(context, 'Download File'),
        fontSize: 14.0,
        color: redColor,
        maxLine: 1,
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.underline,
        decorationColor: redColor,

      ),
      /* child: Row(
        children: [
          const Icon(Icons.download, color: redColor, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              shortenFileName(getFileName(id)),
              style: const TextStyle(
                fontSize: 14.0,
                color: redColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),*/
    );
  }

  /// Extracts the file name from the URL or ID
  String getFileName(String url) {
    return url.split('/').last;
  }

  /// Shortens the file name for display purposes
  String shortenFileName(String fileName, {int maxLength = 15}) {
    if (fileName.length <= maxLength) return fileName;
    return '${fileName.substring(0, maxLength)}...';
  }

}
