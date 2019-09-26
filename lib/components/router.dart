/*
 * Created by Alfonso Cejudo, Monday, July 8th 2019.
 */

import 'package:flutter/material.dart';
import 'package:fluttest/components/undefined_view.dart';
import 'package:fluttest/repository/user_repository.dart';
import 'package:fluttest/ui/home/home.dart';
//import 'package:fluttest/ui/home/home_bloc.dart';
import 'package:fluttest/ui/home/bloc/bloc.dart';
import 'package:provider/provider.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Home.route:
        return MaterialPageRoute(
          builder: (_) => ProxyProvider<UserRepository, UserBloc>(
                builder: (context, userRepository, userBloc) =>
                    UserBloc(userRepository: userRepository),
                dispose: (context, userBloc) => userBloc.dispose(),
                child: Home(),
              ),
        );

      default:
        return MaterialPageRoute(
            builder: (_) => UndefinedView(
                  routeName: settings.name,
                ));
    }
  }
}
