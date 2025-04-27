// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../data/data_sources/remote/clients/clients_remote_datasource_imp.dart';
import '../data/data_sources/remote/diagnoses/diagnoses_remote_datasource_imp.dart';
import '../data/data_sources/remote/health_programs/health_programs_remote_datasource_imp.dart';
import '../data/data_sources/remote/users/users_remote_datasource_imp.dart';
import '../data/repositories/clients/clients_repo_imp.dart';
import '../data/repositories/diagnoses/diagnoses_repo_imp.dart';
import '../data/repositories/health_programs/health_progams_repo_imp.dart';
import '../data/repositories/users/users_repo_imp.dart';
import '../domain/usecases/create_client_usecase.dart';
import '../domain/usecases/create_health_program_usecase.dart';
import '../domain/usecases/delete_client_usecase.dart';
import '../domain/usecases/delete_health_program_usecase.dart';
import '../domain/usecases/enroll_client_usecase.dart';
import '../domain/usecases/get_all_clients_usecase.dart';
import '../domain/usecases/get_all_diagnoses_usecase.dart';
import '../domain/usecases/get_all_health_programs_usecase.dart';
import '../domain/usecases/get_client_usecase.dart';
import '../domain/usecases/get_health_programs_usecase.dart';
import '../domain/usecases/login_use_usecase.dart';
import '../domain/usecases/search_clients_usecase.dart';
import '../domain/usecases/search_health_programs_usecase.dart';
import '../domain/usecases/sign_up_usecase.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => UsersRemoteDataSourceImpl());
  locator.registerLazySingleton(() => HealthProgramsRemoteDataSourceImpl());
  locator.registerLazySingleton(() => DiagnosesRemoteDataSourceImpl());
  locator.registerLazySingleton(() => ClientsRemoteDataSourceImpl());
  locator.registerLazySingleton(() => UsersRepositoryImpl());
  locator.registerLazySingleton(() => HealthProgramsRepositoryImpl());
  locator.registerLazySingleton(() => DiagnosesRepositoryImpl());
  locator.registerLazySingleton(() => ClientsRepositoryImpl());
  locator.registerLazySingleton(() => CreateClientUseCase());
  locator.registerLazySingleton(() => CreateHealthProgramUseCase());
  locator.registerLazySingleton(() => DeleteClientUseCase());
  locator.registerLazySingleton(() => DeleteHealthProgramUseCase());
  locator.registerLazySingleton(() => EnrollClientUseCase());
  locator.registerLazySingleton(() => GetAllClientsUseCase());
  locator.registerLazySingleton(() => GetAllDiagnosesUseCase());
  locator.registerLazySingleton(() => GetAllHealthProgramsUseCase());
  locator.registerLazySingleton(() => GetClientUseCase());
  locator.registerLazySingleton(() => GetHealthProgramUseCase());
  locator.registerLazySingleton(() => LoginUseCase());
  locator.registerLazySingleton(() => SearchClientsUseCase());
  locator.registerLazySingleton(() => SearchHealthProgramsUseCase());
  locator.registerLazySingleton(() => SignupUseCase());
}
