import 'package:dartz/dartz.dart';

import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/order/order_detail_model.dart';
import '../../data/models/order/order_model.dart';
import '../../data/models/refund/refund_item.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';



abstract class OrderRepository {
  Future<Either<Failure, OrderModel>> getBuyerOrder(Uri uri);

  Future<Either<Failure, OrderDetail>> getBuyerOrderDetail(Uri uri);

  Future<Either<Failure, String>> buyerOrderCancelOrComplete(Uri uri);

  Future<Either<Failure, String>> fileSubmission(Uri uri,RefundItem body);
  // Future<Either<Failure, String>> buyerOrderComplete(Uri uri);

}

class OrderRepositoryImpl implements OrderRepository {
  final RemoteDataSources remoteDataSource;

  const OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, OrderModel>> getBuyerOrder(Uri uri) async {
    try {
      final result = await remoteDataSource.getBuyerOrder(uri);
      final data = OrderModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, OrderDetail>> getBuyerOrderDetail(Uri uri) async {
    try {
      final result = await remoteDataSource.getBuyerOrderDetail(uri);
      final data = OrderDetail.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> buyerOrderCancelOrComplete(Uri uri) async {
    try {
      final result = await remoteDataSource.buyerOrderCancelOrComplete(uri);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> fileSubmission(Uri uri,RefundItem body) async {
    try {
      final result = await remoteDataSource.fileSubmission(uri,body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }on InvalidAuthData catch(e){
      return Left(InvalidAuthData(e.errors));
    }
  }

  // @override
  // Future<Either<Failure, String>> buyerOrderComplete(Uri uri) async {
  //   try {
  //     final result = await remoteDataSource.buyerOrderComplete(uri);
  //     return Right(result['message']);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }

}
