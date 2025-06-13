import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tudu/data/repositories/auth_repository_impl.dart';
import 'package:tudu/domain/repositories/auth_repository.dart';
import 'package:tudu/domain/usecases/auth_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {


  // Use cases
  sl.registerLazySingleton(() => AuthUseCases(repository: sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(auth: sl()));

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
}