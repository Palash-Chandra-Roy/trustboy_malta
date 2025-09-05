import 'package:dartz/dartz.dart';

import '../../data/data_provider/local_data_source.dart';
import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/dashboard/dashboard_model.dart';
import '../../data/models/home/seller_model.dart';
import '../../data/models/refund/refund_item.dart';
import '../../data/models/service/service_item.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';
import '../cubit/change_password/change_password_cubit.dart';



abstract class ProfileRepository {
  Future<Either<Failure, SellerModel>> getProfileData(Uri url);

  Future<Either<dynamic, String>> updateUserInfo(Uri uri,SellerModel body);

  Future<Either<dynamic, String>> updateProfileAvatar(Uri uri,SellerModel body);

  Future<Either<Failure, List<ServiceItem>>> getWishList(Uri uri);

  Future<Either<Failure, String>> addToWishList(Uri uri);

  Future<Either<Failure, String>> removeWishList(Uri uri);

  Future<Either<dynamic, String>> passwordChange(Uri uri,ChangePasswordStateModel body);

  Future<Either<Failure, DashboardModel>> providerDashBoard(Uri uri);

  Future<Either<Failure, List<RefundItem>>> getRefunds(Uri uri);
}

class ProfileRepositoryImp extends ProfileRepository {
  final RemoteDataSources remoteDataSource;
  final LocalDataSources localDataSource;

  ProfileRepositoryImp({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, SellerModel>> getProfileData(Uri url) async {
    try {
      final result = await remoteDataSource.getProfileData(url);
      final data = SellerModel.fromMap(result['user']);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<dynamic, String>> updateUserInfo(Uri uri,SellerModel body) async {
    try {
      final result = await remoteDataSource.updateProfile(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> updateProfileAvatar(Uri uri,SellerModel body) async {
    try {
      final result = await remoteDataSource.updateProfileAvatar(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, List<ServiceItem>>> getWishList(Uri uri) async {
    try {
      final result = await remoteDataSource.getWishList(uri);
      final data = result['services'] as List;
      final order = List<ServiceItem>.from(data.map((e)=>ServiceItem.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<RefundItem>>> getRefunds(Uri uri) async {
    try {
      final result = await remoteDataSource.getRefunds(uri);
      final data = result['refunds'] as List;
      final order = List<RefundItem>.from(data.map((e)=>RefundItem.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> addToWishList(Uri uri) async {
    try {
      final result = await remoteDataSource.addToWishList(uri);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e){
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, String>> removeWishList(Uri uri) async {
    try {
      final result = await remoteDataSource.removeWishList(uri);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<dynamic, String>> passwordChange(Uri uri, ChangePasswordStateModel body) async {
    try {
      final result = await remoteDataSource.passwordChange(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, DashboardModel>> providerDashBoard(Uri uri) async {
    try {
      final result = await remoteDataSource.getProviderDashboard(uri);
      final data = DashboardModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
