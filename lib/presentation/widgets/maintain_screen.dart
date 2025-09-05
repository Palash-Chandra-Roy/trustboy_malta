import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../data/data_provider/remote_url.dart';
import '../../logic/cubit/setting/setting_cubit.dart';
import '../utils/utils.dart';
import 'confirm_dialog.dart';
import 'custom_image.dart';


class MaintainScreen extends StatelessWidget {
  const MaintainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sCubit = context.read<SettingCubit>();
    return WillPopScope(
      onWillPop: ()async{
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => ConfirmDialog(
            // icon: KImages.logoutPower,
            // message: 'Are you sure, you\nwant to EXIT?',
            confirmText: 'Yes, Exit',
            onTap: () => SystemNavigator.pop(),
          ),
        );
        return true;
      },
      child: Scaffold(
        body:  Padding(
          padding: Utils.symmetric(h: 10.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomImage(path: RemoteUrls.imageUrl(sCubit.settingModel?.setting?.maintenanceImage??Utils.defaultImg(context,false))),
                const SizedBox(height: 20.0),
                HtmlWidget(sCubit.settingModel?.setting?.maintenanceText??'',textStyle: const TextStyle(fontSize: 16.0,fontWeight: FontWeight.w600),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
