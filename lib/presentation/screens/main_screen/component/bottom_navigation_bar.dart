import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../logic/cubit/setting/setting_cubit.dart';
import '../../../utils/constraints.dart';
import '../../../utils/k_images.dart';
import '../../../utils/utils.dart';
import 'main_controller.dart';

class MyBottomNavigationBar extends StatelessWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = MainController();
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Container(
          height: Platform.isAndroid ? 80 : 100,
          decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              )),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: StreamBuilder(
              initialData: 0,
              stream: controller.naveListener.stream,
              builder: (_, AsyncSnapshot<int> index) {
                int selectedIndex = index.data ?? 0;
                return BottomNavigationBar(
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: whiteColor,
                  selectedLabelStyle:
                  const TextStyle(fontSize: 14, color: blackColor),
                  unselectedLabelStyle:
                  const TextStyle(fontSize: 14, color: grayColor),
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      tooltip: Utils.translatedText(context, "Home"),
                      icon: _navIcon(context,KImages.homeIcon),
                      activeIcon: _navIcon(context,KImages.homeActive),
                      label: Utils.translatedText(context, "Home"),
                    ),
                      if(Utils.isAddon(context)?.liveChat == true)...[
                        BottomNavigationBarItem(
                          tooltip: Utils.translatedText(context, "Inbox"),
                          icon: _navIcon(context,KImages.chatIcon),
                          label: Utils.translatedText(context, "Inbox"),
                          activeIcon: _navIcon(context,KImages.inboxActive),
                        ),
                      ],

                    BottomNavigationBarItem(
                      tooltip: Utils.translatedText(context, 'Order'),
                      icon: _navIcon(context,KImages.order),
                      activeIcon: _navIcon(context,KImages.orderActive),
                      label: Utils.translatedText(context, 'Order'),
                    ),
                    BottomNavigationBarItem(
                      tooltip: Utils.translatedText(context, 'More'),
                      icon: _navIcon(context,KImages.more),
                      activeIcon: _navIcon(context,KImages.moreActive),
                      label: Utils.translatedText(context, 'More'),
                    ),

                  ],
                  // type: BottomNavigationBarType.fixed,
                  currentIndex: selectedIndex,
                  onTap: (int index) {
                    controller.naveListener.sink.add(index);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _navIcon(BuildContext context,String path) => Padding(
      padding: Utils.symmetric(v: 8.0, h: 0.0), child: SvgPicture.asset(path));
}
