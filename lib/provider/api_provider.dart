import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i_chef_application/functions/api_service.dart';

final chefApiServiceProvider = Provider<ChefApiService>((ref) {
  return ChefApiService();
});
