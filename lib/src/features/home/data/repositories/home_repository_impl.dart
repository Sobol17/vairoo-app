import 'package:Vairoo/src/features/home/data/datasources/home_remote_data_source.dart';
import 'package:Vairoo/src/features/home/domain/entities/home_data.dart';
import 'package:Vairoo/src/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeData> fetchHomeData() {
    return _remoteDataSource.fetchHome();
  }
}
