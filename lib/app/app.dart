import 'package:health_managment_system/data/data_sources/remote/clients/clients_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/diagnoses/diagnoses_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/health_programs/health_programs_remote_datasource_imp.dart';
import 'package:health_managment_system/data/data_sources/remote/users/users_remote_datasource_imp.dart';
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
