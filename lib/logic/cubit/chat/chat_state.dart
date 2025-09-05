part of 'chat_cubit.dart';

sealed class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

final class ChatInitial extends ChatState {
  const ChatInitial();
}


class RefreshStateEveryFive extends ChatState {
  const RefreshStateEveryFive();
}

final class SupportMessaging extends ChatState {}

final class SupportMessageError extends ChatState {
  final String message;
  final int statusCode;

  const SupportMessageError({required this.message, required this.statusCode});

  @override
  List<Object> get props => [message, statusCode];
}

final class SupportMessaged extends ChatState {
  final String ticket;

  const SupportMessaged({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}

final class SupportTicketFormError extends ChatState {
  final Errors errors;

  const SupportTicketFormError({required this.errors});

  @override
  List<Object> get props => [errors];
}

final class ChatBuyerLoading extends ChatState {}

final class ChatBuyerLoaded extends ChatState {
  final List<ChatModel> buyerModel;

  const ChatBuyerLoaded(this.buyerModel);

  @override
  List<Object> get props => [buyerModel];
}

final class ChatBuyerErrors extends ChatState {
  final String message;
  final int statusCode;

  const ChatBuyerErrors(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}

final class ChatMessageLoading extends ChatState {}

final class ChatMessageLoaded extends ChatState {
  final List<MessageModel> messages;

  const ChatMessageLoaded(this.messages);

  @override
  List<Object> get props => [messages];
}

final class ChatMessageError extends ChatState {
  final String message;
  final int statusCode;

  const ChatMessageError(this.message, this.statusCode);

  @override
  List<Object> get props => [message, statusCode];
}