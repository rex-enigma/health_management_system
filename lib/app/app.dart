import 'package:health_managment_system/data/data_sources/remote/clients/clients_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/users/users_remote_datasource_imp.dart';
import 'package:health_managment_system/data/repositories/clients/clients_repo_imp.dart';
import 'package:health_managment_system/data/repositories/diagnoses/diagnoses_repo_imp.dart';
import 'package:health_managment_system/data/repositories/health_programs/health_progams_repo_imp.dart';
import 'package:health_managment_system/data/repositories/users/users_repo_imp.dart';
import 'package:health_managment_system/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:health_managment_system/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:health_managment_system/ui/views/home/home_view.dart';
import 'package:health_managment_system/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
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
