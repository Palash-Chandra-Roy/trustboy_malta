import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/chat/message_model.dart';
import '../../../logic/bloc/login/login_bloc.dart';
import '../../../logic/cubit/chat/chat_cubit.dart';
import '../../utils/constraints.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/fetch_error_text.dart';
import '../../widgets/page_refresh.dart';
import 'component/message_input_field.dart';
import 'component/single_chat_component.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  //final String buyerId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatCubit inboxCubit;
  late ScrollController controller;
  late LoginBloc loginBloc;


  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    inboxCubit = context.read<ChatCubit>();
    loginBloc = context.read<LoginBloc>();
    Future.microtask(() => inboxCubit.getMessageList());
    inboxCubit..isOpen(true)..isSellerPanle(Utils.isSeller(context));
  }




  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    inboxCubit.isOpen(false);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      // appBar: AppBar(
      //   centerTitle: false,
      //   elevation: 0.0,
      //   automaticallyImplyLeading: false,
      //   title: BlocBuilder<ChatCubit,MessageModel>(builder: (context,state){
      //     return Row(
      //       mainAxisAlignment: MainAxisAlignment.start,
      //       children: [
      //         GestureDetector(
      //           onTap: () => Navigator.of(context).pop(),
      //           child: Container(
      //             height: Utils.vSize(24.0),
      //             width: Utils.vSize(24.0),
      //             alignment: Alignment.center,
      //             child: const Icon(
      //               Icons.arrow_back_ios,
      //               size: 18.0,
      //               color: grayColor,
      //             ),
      //           ),
      //         ),
      //         CircleImage(image: RemoteUrls.imageUrl(image??Utils.defaultImg(context)),size: 30.0),
      //         Utils.horizontalSpace(6.0),
      //         Flexible(child: CustomText(text: name??'',fontSize: 18.0,fontWeight: FontWeight.w500,maxLine: 1,)),
      //       ],
      //     );
      //   }),
      // ),
      appBar: DefaultAppBar(title: inboxCubit.state.createdAt),
      body: PageRefresh(
        onRefresh: () async {
          inboxCubit.getMessageList();
          _scrollToBottom();
        },
        child: MultiBlocListener(
          listeners: [
            BlocListener<ChatCubit, MessageModel>(
              listener: (context, state) {
                final sCubit = state.chatState;
                if (sCubit is SupportMessaged) {
                  inboxCubit.addMessage('');
                  inboxCubit.getMessageList();
                  _scrollToBottom();
                }

                if(sCubit is SupportMessageError){
                  inboxCubit.addMessage('');
                  Utils.errorSnackBar(context, sCubit.message);
                }
              },
            ),
            // BlocListener<LoginBloc, LoginModelState>(
            //   listener: (context, state) {
            //     final logout = state.state;
            //     if (logout is LoginStateLogOutLoading) {
            //       Utils.loadingDialog(context);
            //     } else {
            //       Utils.closeDialog(context);
            //       if (logout is LoginStateLogOut) {
            //         Utils.errorSnackBar(context, logout.msg);
            //       } else if (logout is LoginStateLogOut) {
            //         leaveChatChannel();
            //         Utils.showSnackBar(context, logout.msg);
            //         Navigator.pushNamedAndRemoveUntil(
            //           context,
            //           RouteNames.authenticationScreen,
            //               (route) => false,
            //         );
            //       }
            //     }
            //   },
            // ),
          ],
          child: BlocConsumer<ChatCubit, MessageModel>(
            listener: (context, state) {
              final package = state.chatState;
              if (package is ChatMessageError) {
                if (package.statusCode == 503) {
                  inboxCubit.getMessageList();
                }
                if (package.statusCode == 401) {
                  Utils.logoutFunction(context);
                }
              }

              if (package is SupportMessaged) {
                inboxCubit.addMessage('');
                inboxCubit.getMessageList();
                _scrollToBottom();
              }

              if (package is RefreshStateEveryFive) {
                if (state.isOpenSupport == true) {
                  inboxCubit.getMessageList();
                  _scrollToBottom();
                }
              }
            },
            builder: (context, state) {
              final plan = state.chatState;
              if (plan is ChatMessageError) {
                if (plan.statusCode == 501) {
                  return LoadedChatWidget(messageInbox: inboxCubit.messages, controller: controller);
                } else {
                  return FetchErrorText(text: plan.message);
                }
              } else if (plan is ChatMessageLoaded) {
                _scrollToBottom();
                return LoadedChatWidget(messageInbox: plan.messages, controller: controller);
              }
              if (inboxCubit.messages?.isNotEmpty??false) {
                return LoadedChatWidget(messageInbox: inboxCubit.messages, controller: controller);
              } else {
                return FetchErrorText(text: '${Utils.translatedText(context, 'Loading')}..', textColor: blackColor);
              }
            },
          ),
        ),
      ),
    );
  }
}

class LoadedChatWidget extends StatefulWidget {
  const LoadedChatWidget(
      {super.key, required this.messageInbox, required this.controller});

  final List<MessageModel>? messageInbox;
  final ScrollController controller;

  @override
  State<LoadedChatWidget> createState() => _LoadedChatWidgetState();
}

class _LoadedChatWidgetState extends State<LoadedChatWidget> {
  late ChatCubit inboxCubit;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    inboxCubit = context.read<ChatCubit>();
    loginBloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.messageInbox?.isNotEmpty??false) ...[
          Expanded(
            child: ListView.builder(
              padding: Utils.symmetric(v: 12.0,h: 0.0),
              controller: widget.controller,
              shrinkWrap: true,
              itemCount: widget.messageInbox?.length,
              itemBuilder: (context, index) {
                final m = widget.messageInbox?[index];
                final isSeller = m?.sendBy == 'seller' && Utils.isSeller(context);
                final isSeller2 = m?.sendBy == 'buyer' && !Utils.isSeller(context);

                if(m != null){
                  if(isSeller){
                    return SingleChat(m: m, isSeller: isSeller);
                  }else{
                    return SingleChat(m: m, isSeller: isSeller2);
                  }
                }else{
                  return const SizedBox.shrink();
                }

              },
            ),
          ),
        ] else ...[
          Center(child: Text(Utils.translatedText(context, 'No messages available'))),
        ],
        MessageInputField(),
      ],
    );
  }
}
