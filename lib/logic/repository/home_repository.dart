import 'package:dartz/dartz.dart';

import '../../data/data_provider/remote_data_source.dart';
import '../../data/models/home/home_model.dart';
import '../../presentation/errors/exception.dart';
import '../../presentation/errors/failure.dart';



abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> getHomeData(Uri uri);

  // Future<Either<Failure, List<InfluencerModel>>> getInfluencerList(String langCode);
}

class HomeRepositoryImpl implements HomeRepository {
  final RemoteDataSources remoteDataSource;

  const HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, HomeModel>> getHomeData(Uri uri) async {
    try {
      final result = await remoteDataSource.getHomeData(uri);
      final data = HomeModel.fromMap(result);
      return Right(data);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, e.statusCode));
    }
  }

  // @override
  // Future<Either<Failure, List<InfluencerModel>>> getInfluencerList(
  //     String langCode) async {
  //   try {
  //     final result = await remoteDataSource.getInfluencerList(langCode);
  //     final influencer = result['influencers']['data'] as List;
  //     final data = List<InfluencerModel>.from(
  //         influencer.map((e) => InfluencerModel.fromMap(e))).toList();
  //     return Right(data);
  //   } on ServerException catch (e) {
  //     return Left(ServerFailure(e.message, e.statusCode));
  //   }
  // }
}
