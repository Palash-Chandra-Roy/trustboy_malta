import 'package:dartz/dartz.dart';
import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/home/job_post.dart';
import '../../data/models/home/my_application_model.dart';
import '../../data/models/job/job_create_info.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';

abstract class JobPostRepository {
  Future<Either<Failure, JobPostModel>> getJobPostList(Uri uri);

  Future<Either<Failure, JobPostModel>> getJobReqList(Uri uri);

  Future<Either<Failure, List<ApplicationModel>>> getMyJobPostList(Uri uri);

  Future<Either<Failure, JobCreateInfo>> jobPostCreateInfo(Uri uri);

  Future<Either<dynamic, JobCreateInfo>> addJobPost(Uri uri,JobPostItem body);

  Future<Either<dynamic, String>> updateJobPost(Uri uri,JobPostItem body);

  Future<Either<dynamic, String>> deleteJobPost(Uri uri);

  Future<Either<dynamic, String>> hiredApplicant(Uri uri);

  Future<Either<Failure, JobCreateInfo>> editJobPost(Uri uri);

  // Future<Either<Failure, MyApplicationModel>> getMyJobPostDetail(Uri uri);

  // Future<Either<Failure, JobPostItem>> getJobDetails(Uri uri);

  Future<Either<Failure, String>> applyJob(Uri uri, JobPostItem body);

  // Future<Either<Failure, JobPostModel>> searchJobs(Uri uri);
}

class JobPostRepositoryImpl implements JobPostRepository {
  final RemoteDataSources remoteDataSource;

  const JobPostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> applyJob(Uri uri, JobPostItem body) async {
    try {
      final result = await remoteDataSource.applyJobPost(uri, body);
      return right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch (e) {
      return Left(InvalidAuthData(e.errors));
    }
  }

  // @override
  // Future<Either<Failure, JobPostItem>> getJobDetails(Uri uri) async {
  //   try {
  //     final result = await remoteDataSource.getJobDetails(uri);
  //     final data = JobPostItem.fromMap(result['job_post']);
  //     return right(data);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }

  @override
  Future<Either<Failure, JobPostModel>> getJobPostList(Uri uri) async {
    try {
      final result = await remoteDataSource.getJobPostList(uri);
      final posts = JobPostModel.fromMap(result);
      return right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }
  @override
  Future<Either<Failure, JobPostModel>> getJobReqList(Uri uri) async {
    try {
      final result = await remoteDataSource.getJobReqList(uri);
      final posts = JobPostModel.fromMap(result);
      return right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

 @override
  Future<Either<Failure, List<ApplicationModel>>> getMyJobPostList(
      Uri uri) async {
    try {
      final result = await remoteDataSource.getMyJobPostList(uri);
      final data = result['job_requests'] as List;
      final posts = List<ApplicationModel>.from(data.map((p) => ApplicationModel.fromMap(p))).toList();
      return right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, JobCreateInfo>> jobPostCreateInfo(
      Uri uri) async {
    try {
      final result = await remoteDataSource.jobPostCreateInfo(uri);
      final posts = JobCreateInfo.fromMap(result);
      return right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<Failure, JobCreateInfo>> editJobPost(
      Uri uri) async {
    try {
      final result = await remoteDataSource.editJobPost(uri);
      final posts = JobCreateInfo.fromMap(result);
      return right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  @override
  Future<Either<dynamic, JobCreateInfo>> addJobPost(
      Uri uri,JobPostItem body) async {
    try {
      final result = await remoteDataSource.addJobPost(uri,body);
      final posts = JobCreateInfo.fromMap(result);
      return right(posts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    } on InvalidAuthData catch(e){
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> updateJobPost(
      Uri uri,JobPostItem body) async {
    try {
      final result = await remoteDataSource.updateJobPost(uri,body);
      return right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }on InvalidAuthData catch(e){
      return Left(InvalidAuthData(e.errors));
    }
  }
  @override
  Future<Either<dynamic, String>> deleteJobPost(
      Uri uri) async {
    try {
      final result = await remoteDataSource.deleteJobPost(uri);
      return right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }on InvalidAuthData catch(e){
      return Left(InvalidAuthData(e.errors));
    }
  }

  @override
  Future<Either<dynamic, String>> hiredApplicant(Uri uri) async {
    try {
      final result = await remoteDataSource.hiredApplicant(uri);
      return right(result['message']);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }on InvalidAuthData catch(e){
      return Left(InvalidAuthData(e.errors));
    }
  }

  // @override
  // Future<Either<Failure, MyApplicationModel>> getMyJobPostDetail(
  //     Uri uri) async {
  //   try {
  //     final result = await remoteDataSource.getMyJobPostDetail(uri);
  //     final data = MyApplicationModel.fromMap(result['job_request']);
  //     return right(data);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }

  // @override
  // Future<Either<Failure, JobPostModel>> searchJobs(Uri uri) async {
  //   try {
  //     final result = await remoteDataSource.searchJobs(uri);
  //     final data = JobPostModel.fromMap(result);
  //     return right(data);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }
}
