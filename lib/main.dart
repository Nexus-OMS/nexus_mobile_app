import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:nexus_mobile_app/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:nexus_mobile_app/bloc/organization_bloc/organization_bloc.dart';
import 'package:nexus_mobile_app/bloc/repositories/authentication_repository.dart';
import 'package:nexus_mobile_app/bloc/repositories/organization_repository.dart';
import 'package:nexus_mobile_app/services/authorized_client.dart';
import 'package:nexus_mobile_app/ui/app.dart';
import 'package:nexus_mobile_app/ui/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(NexusApp());
}

class NexusApp extends StatefulWidget {
  @override
  _NexusAppState createState() => _NexusAppState();
}

class _NexusAppState extends State<NexusApp> {
  AuthorizedClient client;
  @override
  void initState() {
    super.initState();
    client = AuthorizedClient(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Nexus',
        theme: NexusTheme.light(context),
        darkTheme: NexusTheme.dark(context),
        home: RepositoryProvider<AuthorizedClient>(
          create: (context) => client,
          child: MultiBlocProvider(providers: [
            BlocProvider(create: (context) {
              final _authRepository = AuthenticationRepository(client);
              return AuthenticationBloc(_authRepository, client.authError);
            }),
            BlocProvider(create: (context) {
              final _orgRepository = OrganizationRepository(client);
              return OrganizationBloc(repository: _orgRepository);
            }),
          ], child: App()),
        ));
  }
}
