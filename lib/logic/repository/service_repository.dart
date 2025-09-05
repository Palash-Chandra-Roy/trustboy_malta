import 'package:dartz/dartz.dart';

import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/filter/filter_model.dart';
import '../../data/models/home/job_post.dart';
import '../../data/models/home/seller_model.dart';

import '../../data/models/service/service_edit_model.dart';
import '../../data/models/service/service_item.dart';
import '../../data/models/service/service_model.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';

abstract class ServiceRepository {
  Future<Either<Failure, ServiceModel>> serviceDetail(Uri uri); // used for both service detail & seller services

  Future<Either<Failure, List<ServiceItem>>> getAllServices(Uri uri);

  Future<Either<Failure, List<SellerModel>>> getAllSellers(Uri uri);

  Future<Either<Failure, List<JobPostItem>>> getAllJobs(Uri uri);

  Future<Either<Failure, JobPostModel>> jobPostDetail(Uri uri);

  Future<Either<Failure, FilterModel>> getFilterData(Uri uri);


///seller service or gig related functions
  //serviceDetail() is also used for this section
  Future<Either<Failure, ServiceEditInfo>> createEditInfo(Uri uri);
  Future<Either<Failure, ServiceEditInfo>> addUpdate(Uri uri,ServiceItem body);
  Future<Either<Failure, ServiceEditInfo>> addPackage(Uri uri,ServiceItem body);
  Future<Either<Failure, String>> addSeoInfo(Uri uri,ServiceItem body);
  Future<Either<Failure, String>> deleteImage(Uri uri);
  Future<Either<Failure, String>> addImages(Uri uri,ServiceItem body);
  Future<Either<Failure, String>> reqToPublish(Uri uri);
}

class ServiceRepositoryImpl implements ServiceRepository {
  final RemoteDataSources remoteDataSource;

  const ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ServiceModel>> serviceDetail(Uri uri) async {
    try {
      final result = await remoteDataSource.serviceDetail(uri);
      final data = ServiceModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<ServiceItem>>> getAllServices(Uri uri) async {
    try {
      final result = await remoteDataSource.getAllServices(uri);
      final data = result['services']['data'] as List;
      final order = List<ServiceItem>.from(data.map((e)=>ServiceItem.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, List<SellerModel>>> getAllSellers(Uri uri) async {
    try {
      final result = await remoteDataSource.getAllSellers(uri);
      final data = result['sellers']['data'] as List;
      final order = List<SellerModel>.from(data.map((e)=>SellerModel.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, List<JobPostItem>>> getAllJobs(Uri uri) async {
    try {
      final result = await remoteDataSource.getAllJobs(uri);
      final data = result['job_posts']['data'] as List;
      final order = List<JobPostItem>.from(data.map((e)=>JobPostItem.fromMap(e))).toList();
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, JobPostModel>> jobPostDetail(Uri uri) async {
    try {
      final result = await remoteDataSource.jobPostDetail(uri);
      final order = JobPostModel.fromMap(result);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, FilterModel>> getFilterData(Uri uri) async {
    try {
      final result = await remoteDataSource.getFilterData(uri);
      final order = FilterModel.fromMap(result);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, String>> addImages(Uri uri,ServiceItem body) async{
    try {
      final result = await remoteDataSource.addImages(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, ServiceEditInfo>> addPackage(Uri uri, ServiceItem body) async{
    try {
      final result = await remoteDataSource.addPackage(uri,body);
      final order = ServiceEditInfo.fromMap(result);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, ServiceEditInfo>> addUpdate(Uri uri, ServiceItem body) async{
    try {
      final result = await remoteDataSource.addUpdate(uri,body);
      final order = ServiceEditInfo.fromMap(result);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, ServiceEditInfo>> createEditInfo(Uri uri) async{
    try {
      final result = await remoteDataSource.createEditInfo(uri);
      final order = ServiceEditInfo.fromMap(result);
      return Right(order);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, String>> deleteImage(Uri uri) async{
    try {
      final result = await remoteDataSource.deleteImage(uri);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, String>> reqToPublish(Uri uri) async{
    try {
      final result = await remoteDataSource.reqToPublish(uri);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<Failure, String>> addSeoInfo(Uri uri, ServiceItem body) async{
    try {
      final result = await remoteDataSource.addSeoInfo(uri,body);
      return Right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }
}
