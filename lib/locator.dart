import 'package:eshop/core/domain/abstractions/auth.abstraction.dart';
import 'package:eshop/core/domain/abstractions/product.abstraction.dart';
import 'package:eshop/core/domain/abstractions/transaction.abstraction.dart';
import 'package:eshop/core/domain/abstractions/user.abstraction.dart';
import 'package:eshop/core/infrastructure/services/auth.service.dart';
import 'package:eshop/core/infrastructure/services/product.service.dart';
import 'package:eshop/core/infrastructure/services/transaction.service.dart';
import 'package:eshop/core/infrastructure/services/user.service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<IAuthService>(() => AuthService());
  locator.registerLazySingleton<IUserService>(() => UserService());
  locator.registerLazySingleton<IProductService>(() => ProductService());
  locator
      .registerLazySingleton<ITransactionService>(() => TransactionService());
}
