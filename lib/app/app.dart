import 'package:health_managment_system/data/data_sources/remote/clients/clients_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/users/users_remote_datasource_imp.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/data/repositories/diagnoses/diagnoses_repo_imp.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/data/repositories/users/users_repo_imp.dart';
import 'package:health_managment_system/domain/usecases/create_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/create_health_program_usecase.dart';
import 'package:health_managment_system/domain/usecases/delete_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/delete_health_program_usecase.dart';
import 'package:health_managment_system/domain/usecases/enroll_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_all_clients_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_all_diagnoses_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_all_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_client_usecase.dart';
import 'package:health_managment_system/domain/usecases/get_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/login_use_usecase.dart';
import 'package:health_managment_system/domain/usecases/search_clients_usecase.dart';
import 'package:health_managment_system/domain/usecases/search_health_programs_usecase.dart';
import 'package:health_managment_system/domain/usecases/sign_up_usecase.dart';
import 'package:health_managment_system/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:health_managment_system/ui/views/home_view/home_view.dart';
import 'package:health_managment_system/ui/views/startup_view/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:health_managment_system/ui/views/health_program/health_program_view.dart';
import 'package:health_managment_system/ui/views/health_programs/health_programs_view.dart';
import 'package:health_managment_system/ui/views/register_client/register_client_view.dart';
import 'package:health_managment_system/ui/views/settings/settings_view.dart';
import 'package:health_managment_system/ui/views/clients/clients_view.dart';
import 'package:health_managment_system/ui/views/login/login_view.dart';
import 'package:health_managment_system/ui/views/signup/signup_view.dart';
import 'package:health_managment_system/ui/views/client/client_view.dart';
import 'package:health_managment_system/ui/views/create_health_program/create_health_program_view.dart';
import 'package:health_managment_system/ui/views/enroll_client/enroll_client_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: HealthProgramView),
    MaterialRoute(page: HealthProgramsView),
    MaterialRoute(page: RegisterClientView),
    MaterialRoute(page: SettingsView),
    MaterialRoute(page: ClientsView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignupView),
    MaterialRoute(page: ClientView),
    MaterialRoute(page: CreateHealthProgramView),
    MaterialRoute(page: EnrollClientView),
// @stacked-route
  ],
  dependencies: [
    // @stacked-service
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // data sources
    LazySingleton(classType: UsersRemoteDataSourceImpl),
    LazySingleton(classType: HealthProgramsRemoteDataSourceImpl),
    LazySingleton(classType: DiagnosesRemoteDataSourceImpl),
    LazySingleton(classType: ClientsRemoteDataSourceImpl),
    // repositories
    LazySingleton(classType: UsersRepositoryImpl),
    LazySingleton(classType: HealthProgramsRepositoryImpl),
    LazySingleton(classType: DiagnosesRepositoryImpl),
    LazySingleton(classType: ClientsRepositoryImpl),
    // usecases
    LazySingleton(classType: CreateClientUseCase),
    LazySingleton(classType: CreateHealthProgramUseCase),
    LazySingleton(classType: DeleteClientUseCase),
    LazySingleton(classType: DeleteHealthProgramUseCase),
    LazySingleton(classType: EnrollClientUseCase),
    LazySingleton(classType: GetAllClientsUseCase),
    LazySingleton(classType: GetAllDiagnosesUseCase),
    LazySingleton(classType: GetAllHealthProgramsUseCase),
    LazySingleton(classType: GetClientUseCase),
    LazySingleton(classType: GetHealthProgramUseCase),
    LazySingleton(classType: LoginUseCase),
    LazySingleton(classType: SearchClientsUseCase),
    LazySingleton(classType: SearchHealthProgramsUseCase),
    LazySingleton(classType: SignupUseCase),
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
