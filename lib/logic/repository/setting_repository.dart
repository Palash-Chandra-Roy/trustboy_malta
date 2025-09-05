import 'package:dartz/dartz.dart';

import '../../data/data_provider/local_data_source.dart';
import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/contact/contact_us_model.dart';
import '../../data/models/setting/website_setup_model.dart';
import '../../data/models/terms_conditions/terms_conditions.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';

abstract class SettingRepository {
  Future<Either<Failure, WebsiteSetupModel>> getSetting(Uri uri);

  Either<Failure, bool> checkOnBoarding();

  Future<Either<Failure, bool>> cachedOnBoarding();

  Future<Either<Failure, TermsConditionsModel>> termsAndConditions(Uri url);

  Future<Either<Failure, TermsConditionsModel>> privacyPolicy(Uri url);
  Future<Either<Failure, ContactUsModel>> getContactUs(Uri url,ContactUsModel ? body);
  Future<Either<Failure, String>> submitContact(Uri url,ContactUsModel ? body);
  Future<Either<Failure, List<ContactUsModel>>> getFaqs(Uri url);
}

class SettingRepositoryImpl implements SettingRepository {
  final LocalDataSources localDataSources;
  final RemoteDataSources remoteDataSources;

  SettingRepositoryImpl(
      {required this.remoteDataSources, required this.localDataSources});

  @override
  Future<Either<Failure, WebsiteSetupModel>> getSetting(Uri uri) async {
    try {
      final result = await remoteDataSources.getSetting(uri);
      final web = WebsiteSetupModel.fromMap(result);
      return Right(web);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, ContactUsModel>> getContactUs(Uri uri,ContactUsModel ? body) async {
    try {
      final result = await remoteDataSources.getContactUs(uri,body);
      final web = ContactUsModel.fromMap(result['contact_us']);
      return Right(web);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, String>> submitContact(Uri uri,ContactUsModel ? body) async {
    try {
      final result = await remoteDataSources.getContactUs(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, bool>> cachedOnBoarding() async {
    try {
      final result = await localDataSources.cachedOnBoarding();
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<ContactUsModel>>> getFaqs(Uri uri) async {
    try {
      final result = await remoteDataSources.getContactUs(uri,null);
      final data = result['faqs'] as List;
      final order = List<ContactUsModel>.from(data.map((e)=>ContactUsModel.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Either<Failure, bool> checkOnBoarding() {
    try {
      return Right(localDataSources.checkOnBoarding());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, TermsConditionsModel>> termsAndConditions(
      Uri url) async {
    try {
      final result = await remoteDataSources.termsConditions(url);
      final termsData = result['terms_conditions'];
      final data = TermsConditionsModel.fromMap(termsData);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, TermsConditionsModel>> privacyPolicy(Uri url) async {
    try {
      final result = await remoteDataSources.privacyPolicy(url);
      final termsData = result['privacy_policy'];
      final data = TermsConditionsModel.fromMap(termsData);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
}
