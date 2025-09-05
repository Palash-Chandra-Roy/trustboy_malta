import 'package:dartz/dartz.dart';

import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/payment/payment_model.dart';
import '../../data/models/setting/currencies_model.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';



abstract class PaymentRepository {
  // Future<Either<Failure, List<PricePlan>>> getPricePlan();

  Future<Either<Failure, PaymentModel>> getPaymentInfo(Uri uri);

  // Future<Either<Failure, String>> freeEnrollment(String token, String planSlug);
  //
  // Future<Either<Failure, String>> bankPayment(String token, String planSlug, Map<String, String> body);
  //
  Future<Either<Failure, String>> stripePayment(Uri uri,CurrenciesModel body);

  //
  // Future<Either<Failure, Map<String, dynamic>>> flutterWavePayment(Uri uri);
}

class PaymentRepositoryImpl implements PaymentRepository {
  final RemoteDataSources remoteDataSource;

  const PaymentRepositoryImpl({required this.remoteDataSource});

  // @override
  // Future<Either<Failure, List<PricePlan>>> getPricePlan() async {
  //   try {
  //     final result = await remoteDataSource.getPricePlan();
  //     final dataList = result['pricing_plans'] as List;
  //     final data =
  //         List<PricePlan>.from(dataList.map((e) => PricePlan.fromMap(e)))
  //             .toList();
  //     return Right(data);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }

  @override
  Future<Either<Failure, PaymentModel>> getPaymentInfo(Uri uri) async {
    try {
      final result = await remoteDataSource.getPaymentInfo(uri);

      final data = PaymentModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

/*  @override
  Future<Either<Failure, String>> freeEnrollment(
      String token, String planSlug) async {
    try {
      final result = await remoteDataSource.freeEnrollment(token, planSlug);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }*/

/*  @override
  Future<Either<Failure, String>> bankPayment(
      String token, String planSlug, Map<String, String> body) async {
    try {
      final result = await remoteDataSource.bankPayment(token, planSlug, body);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }*/

  @override
  Future<Either<Failure, String>> stripePayment(Uri uri,CurrenciesModel body) async {
    try {
      final result =
          await remoteDataSource.stripePayment(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  // @override
  // Future<Either<Failure, Map<String, dynamic>>> flutterWavePayment(
  //     Uri uri) async {
  //   try {
  //     final result = await remoteDataSource.flutterWavePayment(uri);
  //
  //     return Right(result);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }
}
