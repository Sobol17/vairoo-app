import 'package:Vairoo/src/features/paywall/data/datasources/paywall_remote_data_source.dart';
import 'package:Vairoo/src/features/paywall/domain/entities/checkout_link.dart';
import 'package:Vairoo/src/features/paywall/domain/repositories/paywall_repository.dart';

class PaywallRepositoryImpl implements PaywallRepository {
  PaywallRepositoryImpl({required PaywallRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final PaywallRemoteDataSource _remoteDataSource;

  @override
  Future<CheckoutLink> createCheckoutLink() {
    return _remoteDataSource.createCheckoutLink();
  }
}
