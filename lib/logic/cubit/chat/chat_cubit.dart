import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data_provider/remote_url.dart';
import '../../../data/models/chat/chat_model.dart';
import '../../../data/models/chat/message_model.dart';
import '../../../presentation/errors/errors_model.dart';
import '../../../presentation/errors/failure.dart';
import '../../../presentation/utils/utils.dart';
import '../../bloc/login/login_bloc.dart';
import '../../repository/chat_repository.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<MessageModel> {

  final LoginBloc _loginBloc;
  final ChatRepository _repository;

  ChatCubit({
    required LoginBloc loginBloc,
    required ChatRepository repository,
  })  : _loginBloc = loginBloc,
        _repository = repository,
        super(MessageModel.init());


  Timer? _timer;

  List<MessageModel>? messages = [];
  List<ChatModel>? chats = [];

  TextEditingController messageController = TextEditingController();

  void isOpen(bool val) {
    emit(state.copyWith(isOpenSupport: val));
    if (val) {
      _startPeriodicRefresh();
    } else {
      _stopPeriodicRefresh();
    }
  }
  void isSellerPanle(bool val)=>emit(state.copyWith(isSeller: val));

  void _startPeriodicRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (state.isOpenSupport) {
        emit(state.copyWith(chatState: const RefreshStateEveryFive()));
      } else {
        _timer?.cancel();
      }
    });
  }

  void _stopPeriodicRefresh() {
    _timer?.cancel();
  }

  void initState() {
    emit(state.copyWith(chatState: const ChatInitial()));
  }

  // void sendId(int id)=>emit(state.copyWith(id: id));
  void sellerId(int id)=>emit(state.copyWith(sellerId: id));
  void buyerId(int id)=>emit(state.copyWith(buyerId: id));
  void serviceId(int id)=>emit(state.copyWith(serviceId: id));
  void clientName(String id)=>emit(state.copyWith(createdAt: id));
  // void detailId(String id)=>emit(state.copyWith(transectionId: id));
  void addMessage(String id)=>emit(state.copyWith(message: id,chatState: const ChatInitial()));
  // void clearApplyField()=>emit(state.copyWith(updatedAt: '',createdAt: '',bidState: const BidInitial()));



  Future<void> getAllBuyerList() async {
    if (_loginBloc.userInformation?.accessToken.isNotEmpty??false) {

      final Uri uri;
      String chatType;

      if(_loginBloc.userInformation?.user?.isSeller == 1){
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.sellerChat, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);
        chatType = 'buyers';
      }else{
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.buyerChat, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);
        chatType = 'sellers';
      }
      //debugPrint('chat uri $uri');

      emit(state.copyWith(chatState: ChatBuyerLoading()));
      final result = await _repository.getChatList(uri,chatType);
      result.fold((failure) {
        final errors = ChatBuyerErrors(failure.message, failure.statusCode);
        emit(state.copyWith(chatState: errors));
      }, (success) {
        chats = success;
        final loaded = ChatBuyerLoaded(success);
        emit(state.copyWith(chatState: loaded));
      });
    }else{
      chats = [];
      const error = ChatBuyerErrors('', 401);
      emit(state.copyWith(chatState: error));
    }
  }

  Future<void> getMessageList() async {
    if (_loginBloc.userInformation?.accessToken.isNotEmpty??false) {

      final Uri uri;

      if(_loginBloc.userInformation?.user?.isSeller == 1){
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.sellerMsg, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);
      }else{
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.buyerMsg, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);
      }
      //debugPrint('single-message uri $uri');
      emit(state.copyWith(chatState: ChatMessageLoading()));
      final result = await _repository.getMessages(uri);
      result.fold((failure) {
        final errors = ChatMessageError(failure.message, failure.statusCode);
        emit(state.copyWith(chatState: errors));
      }, (success) {
        messages = success;
        final loaded = ChatMessageLoaded(success);
        emit(state.copyWith(chatState: loaded));
      });
    }else{
      messages = [];
      const error = ChatMessageError('', 401);
      emit(state.copyWith(chatState: error));
    }
  }

  Future<void> sendTicketMessage() async {

    debugPrint('message-body ${state.toMap()}');

    if(state.message.trim().isNotEmpty){

      final Uri uri;

      if(_loginBloc.userInformation?.user?.isSeller == 1){
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.sellerToBuyer, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);

      }else{
        if(state.serviceId != 0){
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.fromService, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);
        }else{
        uri = Utils.tokenWithCode(RemoteUrls.chatRoute(ChatType.buyerToSeller, state.sellerId), _loginBloc.userInformation?.accessToken??'',_loginBloc.state.langCode);
        }
      }
     debugPrint('send uri $uri');
      emit(state.copyWith(chatState: SupportMessaging()));
      final result = await _repository.sendMessage(uri,state);
      result.fold((failure) {
        if (failure is InvalidAuthData) {
          final errors = SupportTicketFormError(errors:failure.errors);
          emit(state.copyWith(chatState: errors));
        } else {
          final errors = SupportMessageError(message: failure.message, statusCode: failure.statusCode);
          emit(state.copyWith(chatState: errors));
        }
      }, (data) {
        emit(state.copyWith(chatState: SupportMessaged(ticket: data)));
      });
    }

  }
}
