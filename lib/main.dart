import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/authentication_repository.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/providers/AttendanceProvider.dart';
import 'package:nexus_mobile_app/providers/AttendanceTypeProvider.dart';
import 'package:nexus_mobile_app/providers/EventProvider.dart';
import 'package:nexus_mobile_app/providers/EventTypeProvider.dart';
import 'package:nexus_mobile_app/providers/LevelProvider.dart';
import 'package:nexus_mobile_app/providers/TermProvider.dart';
import 'package:nexus_mobile_app/providers/UserProvider.dart';
import 'package:nexus_mobile_app/ui/app.dart';
import 'package:nexus_mobile_app/ui/theme.dart';
import 'package:provider/provider.dart';

void main() => runApp(new NexusApp());

class NexusApp extends StatelessWidget {
  NexusApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            final AuthenticationRepository _authRepository =
                AuthenticationRepository();
            return AuthenticationBloc(repository: _authRepository);
          }),
          BlocProvider(create: (context) {
            final OrganizationRepository _orgRepository =
                OrganizationRepository();
            return OrganizationBloc(repository: _orgRepository);
          }),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider<AttendanceProvider>(
              create: (_) => AttendanceProvider(),
            ),
            ChangeNotifierProvider<AttendanceTypeProvider>(
              create: (_) => AttendanceTypeProvider(),
            ),
            ChangeNotifierProvider<EventProvider>(
              create: (_) => EventProvider(),
            ),
            ChangeNotifierProvider<EventTypeProvider>(
              create: (_) => EventTypeProvider(),
            ),
            ChangeNotifierProvider<UserProvider>(
              create: (_) => UserProvider(),
            ),
            ChangeNotifierProvider<TermProvider>(
              create: (_) => TermProvider(),
            ),
            ChangeNotifierProvider<LevelProvider>(
              create: (_) => LevelProvider(),
            )
          ],
          child: new MaterialApp(
              title: 'Nexus',
              theme: NexusTheme.light(context),
              darkTheme: NexusTheme.dark(context),
              home: App()),
        ));
  }
}
