import 'package:flutter/material.dart';

import '../../../../../utils/constraints.dart';
import '../../../../../utils/language_string.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/custom_text.dart';



class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  int selectedTab = 0;
  PageController controller =
  PageController(initialPage: 0, keepPage: true, viewportFraction: 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 40,
              offset: Offset(0, 2),
              spreadRadius: 10,
            )
          ],
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: true,
              pinned: true,
              surfaceTintColor: scaffoldBgColor,
              backgroundColor: scaffoldBgColor,
              toolbarHeight: Utils.vSize(80.0),
              centerTitle: true,
              title:  CustomText(
                text: Utils.translatedText(context, Language.myOrder),
                fontSize: 22.0,
                fontWeight: FontWeight.w700,
                color: blackColor,
              ),
              bottom: const OrderTabContent(),
            ),
            SliverList.list(
              children: List.generate(
                10,
                    (index) {
                  // final item =
                  // DummyData.singleServiceModel.relatedServices[index];
                  return Padding(
                    padding: Utils.symmetric(h: 20.0, v: 6.0),
                    child:   Container(),
                    // child:  const OrderCard(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderTabContent extends StatefulWidget implements PreferredSizeWidget {
  const OrderTabContent({super.key});

  @override
  State<OrderTabContent> createState() => _OrderTabContentState();

  @override
  Size get preferredSize => Size.fromHeight(Utils.vSize(40.0));
}

class _OrderTabContentState extends State<OrderTabContent> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Utils.hPadding()),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            orderTabItems.length,
                (index) {
              final active = _currentIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _currentIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(seconds: 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: primaryColor
                    ),
                    color: active ? primaryColor : Colors.transparent,
                    borderRadius: Utils.borderRadius(r: 25.0),
                  ),
                  padding: Utils.symmetric(v: 8.0, h: 24.0),
                  margin: Utils.only(
                      left: index == 0 ? 0.0 : 18.0, bottom: 10.0, top: 14.0),
                  child: CustomText(
                    text: orderTabItems[index],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: blackColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

List<String> orderTabItems = ['All', 'Active', 'Awaiting', 'Reject','cancel','complete'];
