import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../chat/chat_list_screen.dart';
import '/presentation/screens/home/home_screen.dart';
import '/state_injection_packages.dart';
import '../../../data/models/home/seller_model.dart';
import '../../../logic/cubit/profile/profile_state.dart';
import '../../utils/utils.dart';
import '../../widgets/confirm_dialog.dart';
import '../buyer_screen/dashboard/seller_dashboard_screen.dart';
import '../buyer_screen/more/seller_more_screen.dart';
import '../user_screen/order/buyer_seller_order_screen.dart';
import '../user_screen/user_more/buyer_more_screen.dart';
import 'component/bottom_navigation_bar.dart';
import 'component/main_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _homeController = MainController();
  late List<Widget> screenList;
  late LoginBloc loginBloc;
  late HomeCubit homeCubit;
  // late  SettingCubit settingCubit;
  late DashBoardCubit dCubit;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    loginBloc = context.read<LoginBloc>();
    homeCubit = context.read<HomeCubit>();
    dCubit = context.read<DashBoardCubit>();
    // settingCubit = context.read<SettingCubit>();

    final isSeller = Utils.isSeller(context);
    final liveChatEnable = Utils.isAddon(context)?.liveChat == true;

    if (isSeller) {
      screenList = [
        const SellerDashboardScreen(),
        if (liveChatEnable) const ChatListScreen(),
        const BuyerSellerOrderScreen(isPayment: ''),
        const BuyerMoreScreen(),
      ];
      dCubit.getDashBoard();
    } else {
      screenList = [
        const HomeScreen(),
        if (liveChatEnable) const ChatListScreen(),
        const BuyerSellerOrderScreen(isPayment: ''),
        const UserMoreScreen(),
      ];
      context.read<WishListCubit>().getWishList();
      context.read<JobPostCubit>().jobPostCreateInfo();
    }

    // Common
    context.read<ProfileCubit>().getProfileData();
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
        body: Utils.logout(
          child: BlocListener<ProfileCubit, SellerModel>(
            listener: (context,states){
              final state = states.profileState;
              if(state is GetProfileStateError){
                Utils.logoutFunction(context);
              }
            },
            child: StreamBuilder<int>(
              initialData: 0,
              // initialData: loginBloc.state.isLastTab ?2: 0,
              stream: _homeController.naveListener.stream,
              builder: (context, AsyncSnapshot<int> snapshot) {
                int item = snapshot.data ?? 0;
                return screenList[item];
              },
            ),
          ),
        ),
        bottomNavigationBar: const MyBottomNavigationBar(),
        // bottomNavigationBar: Utils.isSeller(context)?_dashBottom():_homeBottom(),
      ),
    );
  }

  /*_homeBottom(){
    // debugPrint('_homeBottom-called');
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        //return const MyBottomNavigationBar();
        // if (state is HomeStateLoading) {
        //   return const SizedBox.shrink();
        // }else if(state is HomeStateLoaded){
        //   return const MyBottomNavigationBar();
        // }
        // if (homeCubit.homeModel != null) {
        //   return const MyBottomNavigationBar();
        // } else {
        //   return const SizedBox.shrink();
        // }
      },
    );
  }*/

  /*_dashBottom(){
    // debugPrint('_dashBottom-called');
    return BlocBuilder<DashBoardCubit, DashBoardState>(
      builder: (context, state) {
        if (state is DashBoardStateLoading) {
          return const SizedBox.shrink();
        }else if(state is DashBoardStateLoaded){
          return const MyBottomNavigationBar();
        }
        if (dCubit.providerDashboard != null) {
          return const MyBottomNavigationBar();
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }*/
}
