import 'package:dartz/dartz.dart';

import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/chat/chat_model.dart';
import '../../data/models/chat/message_model.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatModel>>> getChatList(Uri uri,String chatType);
  Future<Either<Failure, List<MessageModel>>> getMessages(Uri uri);

  // Future<Either<Failure, OrderDetail>> getBuyerOrderDetail(Uri uri);


  Future<Either<Failure, String>> sendMessage(Uri uri,MessageModel body);

}

class ChatRepositoryImpl implements ChatRepository {
  final RemoteDataSources remoteDataSource;

  const ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ChatModel>>> getChatList(Uri uri,String chatType) async {
    try {
      final result = await remoteDataSource.getChatList(uri,chatType);
      final data = result[chatType] as List;
      final order = List<ChatModel>.from(data.map((e)=>ChatModel.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<MessageModel>>> getMessages(Uri uri) async {
    try {
      final result = await remoteDataSource.getMessages(uri);
      final data = result['messages'] as List;
      final order = List<MessageModel>.from(data.map((e)=>MessageModel.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  // @override
  // Future<Either<Failure, OrderDetail>> getBuyerOrderDetail(Uri uri) async {
  //   try {
  //     final result = await remoteDataSource.getBuyerOrderDetail(uri);
  //     final data = OrderDetail.fromMap(result);
  //     return Right(data);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }


  @override
  Future<Either<Failure, String>> sendMessage(Uri uri,MessageModel body) async {
    try {
      final result = await remoteDataSource.sendMessage(uri,body);
      return Right(result['success']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }on InvalidAuthData catch(e){
      return Left(InvalidAuthData(e.errors));
    }
  }

}
