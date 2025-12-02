import 'package:Vairoo/src/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> fetchHomeData();
}
