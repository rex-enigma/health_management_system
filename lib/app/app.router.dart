// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i14;
import 'package:flutter/material.dart';
import 'package:health_managment_system/ui/views/client/client_view.dart'
    as _i11;
import 'package:health_managment_system/ui/views/clients/clients_view.dart'
    as _i8;
import 'package:health_managment_system/ui/views/create_health_program/create_health_program_view.dart'
    as _i12;
import 'package:health_managment_system/ui/views/enroll_client/enroll_client_view.dart'
    as _i13;
import 'package:health_managment_system/ui/views/health_program/health_program_view.dart'
    as _i4;
import 'package:health_managment_system/ui/views/health_programs/health_programs_view.dart'
    as _i5;
import 'package:health_managment_system/ui/views/home_view/home_view.dart'
    as _i2;
import 'package:health_managment_system/ui/views/login/login_view.dart' as _i9;
import 'package:health_managment_system/ui/views/register_client/register_client_view.dart'
    as _i6;
import 'package:health_managment_system/ui/views/settings/settings_view.dart'
    as _i7;
import 'package:health_managment_system/ui/views/signup/signup_view.dart'
    as _i10;
import 'package:health_managment_system/ui/views/startup_view/startup_view.dart'
    as _i3;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i15;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const healthProgramView = '/health-program-view';

  static const healthProgramsView = '/health-programs-view';

  static const registerClientView = '/register-client-view';

  static const settingsView = '/settings-view';

  static const clientsView = '/clients-view';

  static const loginView = '/login-view';

  static const signupView = '/signup-view';

  static const clientView = '/client-view';

  static const createHealthProgramView = '/create-health-program-view';

  static const enrollClientView = '/enroll-client-view';

  static const all = <String>{
    homeView,
    startupView,
    healthProgramView,
    healthProgramsView,
    registerClientView,
    settingsView,
    clientsView,
    loginView,
    signupView,
    clientView,
    createHealthProgramView,
    enrollClientView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.homeView,
      page: _i2.HomeView,
    ),
    _i1.RouteDef(
      Routes.startupView,
      page: _i3.StartupView,
    ),
    _i1.RouteDef(
      Routes.healthProgramView,
      page: _i4.HealthProgramView,
    ),
    _i1.RouteDef(
      Routes.healthProgramsView,
      page: _i5.HealthProgramsView,
    ),
    _i1.RouteDef(
      Routes.registerClientView,
      page: _i6.RegisterClientView,
    ),
    _i1.RouteDef(
      Routes.settingsView,
      page: _i7.SettingsView,
    ),
    _i1.RouteDef(
      Routes.clientsView,
      page: _i8.ClientsView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i9.LoginView,
    ),
    _i1.RouteDef(
      Routes.signupView,
      page: _i10.SignupView,
    ),
    _i1.RouteDef(
      Routes.clientView,
      page: _i11.ClientView,
    ),
    _i1.RouteDef(
      Routes.createHealthProgramView,
      page: _i12.CreateHealthProgramView,
    ),
    _i1.RouteDef(
      Routes.enrollClientView,
      page: _i13.EnrollClientView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i2.HomeView(),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i3.StartupView(),
        settings: data,
      );
    },
    _i4.HealthProgramView: (data) {
      final args = data.getArgs<HealthProgramViewArguments>(nullOk: false);
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i4.HealthProgramView(key: args.key, programId: args.programId),
        settings: data,
      );
    },
    _i5.HealthProgramsView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i5.HealthProgramsView(),
        settings: data,
      );
    },
    _i6.RegisterClientView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.RegisterClientView(),
        settings: data,
      );
    },
    _i7.SettingsView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.SettingsView(),
        settings: data,
      );
    },
    _i8.ClientsView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i8.ClientsView(),
        settings: data,
      );
    },
    _i9.LoginView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.LoginView(),
        settings: data,
      );
    },
    _i10.SignupView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.SignupView(),
        settings: data,
      );
    },
    _i11.ClientView: (data) {
      final args = data.getArgs<ClientViewArguments>(nullOk: false);
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i11.ClientView(key: args.key, clientId: args.clientId),
        settings: data,
      );
    },
    _i12.CreateHealthProgramView: (data) {
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.CreateHealthProgramView(),
        settings: data,
      );
    },
    _i13.EnrollClientView: (data) {
      final args = data.getArgs<EnrollClientViewArguments>(nullOk: false);
      return _i14.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i13.EnrollClientView(key: args.key, clientId: args.clientId),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HealthProgramViewArguments {
  const HealthProgramViewArguments({
    this.key,
    required this.programId,
  });

  final _i14.Key? key;

  final int programId;

  @override
  String toString() {
    return '{"key": "$key", "programId": "$programId"}';
  }

  @override
  bool operator ==(covariant HealthProgramViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.programId == programId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ programId.hashCode;
  }
}

class ClientViewArguments {
  const ClientViewArguments({
    this.key,
    required this.clientId,
  });

  final _i14.Key? key;

  final int clientId;

  @override
  String toString() {
    return '{"key": "$key", "clientId": "$clientId"}';
  }

  @override
  bool operator ==(covariant ClientViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.clientId == clientId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ clientId.hashCode;
  }
}

class EnrollClientViewArguments {
  const EnrollClientViewArguments({
    this.key,
    required this.clientId,
  });

  final _i14.Key? key;

  final int clientId;

  @override
  String toString() {
    return '{"key": "$key", "clientId": "$clientId"}';
  }

  @override
  bool operator ==(covariant EnrollClientViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key && other.clientId == clientId;
  }

  @override
  int get hashCode {
    return key.hashCode ^ clientId.hashCode;
  }
}

extension NavigatorStateExtension on _i15.NavigationService {
  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHealthProgramView({
    _i14.Key? key,
    required int programId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.healthProgramView,
        arguments: HealthProgramViewArguments(key: key, programId: programId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHealthProgramsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.healthProgramsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToRegisterClientView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.registerClientView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToClientsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.clientsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToClientView({
    _i14.Key? key,
    required int clientId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.clientView,
        arguments: ClientViewArguments(key: key, clientId: clientId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateHealthProgramView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createHealthProgramView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToEnrollClientView({
    _i14.Key? key,
    required int clientId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.enrollClientView,
        arguments: EnrollClientViewArguments(key: key, clientId: clientId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithStartupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.startupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHealthProgramView({
    _i14.Key? key,
    required int programId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.healthProgramView,
        arguments: HealthProgramViewArguments(key: key, programId: programId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithHealthProgramsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.healthProgramsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithRegisterClientView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.registerClientView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSettingsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.settingsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithClientsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.clientsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithLoginView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.loginView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithSignupView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.signupView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithClientView({
    _i14.Key? key,
    required int clientId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.clientView,
        arguments: ClientViewArguments(key: key, clientId: clientId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithCreateHealthProgramView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return replaceWith<dynamic>(Routes.createHealthProgramView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> replaceWithEnrollClientView({
    _i14.Key? key,
    required int clientId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(Routes.enrollClientView,
        arguments: EnrollClientViewArguments(key: key, clientId: clientId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
