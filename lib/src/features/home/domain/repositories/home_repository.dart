import 'package:ai_note/src/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  Future<HomeData> fetchHomeData();
}
