import 'package:dartz/dartz.dart';

import '../../data/data_provider/local_data_source.dart';
import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/auth/login_state_model.dart';
import '../../data/models/auth/user_response_model.dart';
import '../../data/models/kyc/kyc_model.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';
import '../bloc/signup/sign_up_state_model.dart';
import '../cubit/forgot_password/forgot_password_state_model.dart';

abstract class AuthRepository {
  Future<Either<dynamic, UserResponseModel>> login(LoginStateModel body);

  Future<Either<dynamic, String>> userRegistration(SignUpStateModel body);
  Future<Either<dynamic, String>> newUserVerification(SignUpStateModel body);
  Future<Either<dynamic, String>> resendVerificationCode(Map<String, dynamic> body);

  Future<Either<Failure, String>> logout(Uri uri);

  Future<Either<dynamic, String>> forgotPassword(Uri uri,Map<String, dynamic> body);
  Future<Either<dynamic, String>> updatePassword(Uri uri,PasswordStateModel body);
  Future<Either<dynamic, String>> deleteAccount(Uri uri,PasswordStateModel body);

  Future<Either<Failure, KycModel>> getKycInfo(Uri uri);

  Future<Either<dynamic, String>> submitKyc(Uri uri, KycItem body);

  Future<Either<Failure, bool>> clearLocalUser();


  Either<Failure, UserResponseModel> getExistingUserInfo();
}

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSources remoteDataSources;
  final LocalDataSources localDataSources;

  AuthRepositoryImpl(
      {required this.remoteDataSources, required this.localDataSources});

  @override
  Future<Either<dynamic, UserResponseModel>> login(LoginStateModel body) async {
    try {
      final result = await remoteDataSources.login(body);
      final data = UserResponseModel.fromMap(result);
      localDataSources.cacheUserResponse(data);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Either<Failure, UserResponseModel> getExistingUserInfo() {
    try {
      final result = localDataSources.getExistingUserInfo();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> logout(Uri uri) async {
    try {
      final logout = await remoteDataSources.logout(uri);
      localDataSources.clearUserResponse();
      return Right(logout);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<dynamic, String>> userRegistration(
      SignUpStateModel body) async {
    try {
      final result = await remoteDataSources.userRegistration(body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> newUserVerification(
      SignUpStateModel body) async {
    try {
      final result = await remoteDataSources.newUserVerification(body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> resendVerificationCode(Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSources.resendVerificationCode(body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> forgotPassword(Uri uri,
      Map<String, dynamic> body) async {
    try {
      final result = await remoteDataSources.forgotPassword(uri,body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> updatePassword(Uri uri,
      PasswordStateModel body) async {
    try {
      final result = await remoteDataSources.updatePassword(uri,body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> deleteAccount(Uri uri,
      PasswordStateModel body) async {
    try {
      final result = await remoteDataSources.deleteAccount(uri,body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, bool>> clearLocalUser() async{
    try {
      await localDataSources.clearUserResponse();
      return const Right(true);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, KycModel>> getKycInfo(Uri uri) async {
    try {
      final result = await remoteDataSources.getKycInfo(uri);
      final data = KycModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<dynamic, String>> submitKyc(Uri uri, KycItem body) async {
    try {
      final result = await remoteDataSources.submitKyc(uri, body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }
}
