import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_zone/presentation/routes/route_packages_name.dart';

import '../../../data/models/chat/chat_model.dart';
import '../../../data/models/chat/message_model.dart';
import '../../../data/models/home/seller_model.dart';
import '../../../logic/cubit/chat/chat_cubit.dart';
import '../../routes/route_names.dart';
import '../../utils/k_images.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/empty_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/page_refresh.dart';
import '../../widgets/please_signin_widget.dart';
import 'component/chat_component.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {


  late ChatCubit serviceCubit;
  final _scrollController = ScrollController();

  @override
  void initState() {
    _initState();
    super.initState();
  }

  _initState() {
    serviceCubit = context.read<ChatCubit>();

    Future.microtask(()=>serviceCubit.getAllBuyerList());

    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // if (serviceCubit.state.totalService > 1) {
    //   serviceCubit.initPage();
    // }
    // _scrollController.dispose();
    super.dispose();
  }

  // void _onScroll() {
  //   if (_scrollController.position.atEdge) {
  //     if (_scrollController.position.pixels != 0.0) {
  //       if (serviceCubit.state.isListEmpty == false) {
  //         serviceCubit.getAllServices();
  //       }
  //     }
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: whiteColor,
      appBar: DefaultAppBar(title: Utils.translatedText(context, Utils.isSeller(context) ? 'Buyer List':'Seller List'),isShowBackButton: false),
      body: PageRefresh(
        onRefresh: () async {

          serviceCubit.getAllBuyerList();
        },
        child: BlocConsumer<ChatCubit, MessageModel>(
          listener: (context, service) {
            final state = service.chatState;
            if (state is ChatBuyerErrors) {
              if (state.statusCode == 503) {
                serviceCubit.getAllBuyerList();
              }

              if(state.statusCode == 401 && state.message.isNotEmpty){
                Utils.logoutFunction(context);
              }
            }

          },
          builder: (context, service) {
            final state = service.chatState;
            if (state is ChatBuyerLoading ) {
              return const LoadingWidget();
            } else if (state is ChatBuyerErrors) {
              if (state.statusCode == 503) {
                return LoadedChatView(items: serviceCubit.chats);
              }else if(state.statusCode == 401) {
                return const PleaseLoginFirst();
              }else {
                return FetchErrorText(text: state.message);
              }
            } else if (state is ChatBuyerLoaded) {
              return LoadedChatView(items: state.buyerModel);
            }
            if (serviceCubit.chats?.isNotEmpty??false) {
              return LoadedChatView(items: serviceCubit.chats);
            } else {
              return EmptyWidget2(image: KImages.emptyChat,isSliver: false,text: 'No Message Yet',subText: 'Please choose one');
            }
          },
        ),
      ),
    );
  }
}

class LoadedChatView extends StatelessWidget {
  const LoadedChatView({super.key, required this.items});
  final List<ChatModel>? items;
  @override
  Widget build(BuildContext context) {
    if(items?.isNotEmpty??false){
      return ListView.builder(
        padding: Utils.symmetric(v: 16.0),
        itemCount: items?.length,
          itemBuilder: (context,index){
            SellerModel? client;
            int messageId;
            if(Utils.isSeller(context)){
               client = items?[index].buyer;
               messageId = items?[index].buyerId??0;
            }else{
               client = items?[index].seller;
               messageId = items?[index].sellerId??0;
            }

        final isBorder = index != (items?.length??0) - 1;
        // debugPrint('isBorder $isBorder');
            return GestureDetector(
              onTap: (){
                context.read<ChatCubit>()..sellerId(messageId)..clientName(client?.name??'');
                Navigator.pushNamed(context,RouteNames.chatScreen);
              },
              child: ChatListItem(item: client,isBorder: isBorder),
            );
      });
    }else{
      return EmptyWidget2(image: KImages.emptyChat,isSliver: false,text: 'No Message Yet',subText: 'Please choose one');
    }
  }
}

