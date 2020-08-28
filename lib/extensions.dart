import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_mobile_app/services/authorized_client.dart';

extension AuthorizedClientExtension on BuildContext {
  AuthorizedClient get client => RepositoryProvider.of<AuthorizedClient>(this);
  RepositoryProvider<AuthorizedClient> clientProvider(Widget widget) =>
      RepositoryProvider<AuthorizedClient>(
          create: (context) => client, child: widget);
}
