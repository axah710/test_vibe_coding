import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/transactions/presentation/bloc/transaction_bloc.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/data/datasources/transaction_local_data_source.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSource(sl()),
  );

  // Repositories
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl()),
  );

  // Blocs
  sl.registerFactory(() => AuthBloc());
  sl.registerFactory(() => TransactionBloc(sl()));

  // Use cases
  // sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repositories
  // sl.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(sl()),
  // );

  // Data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(),
  // );
}
