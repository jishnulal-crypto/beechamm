import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecy/App/routes/app_routes.dart';
import 'package:projecy/App/screens/loginscreen/repository/loginscreen_repository.dart';
import 'package:projecy/App/screens/loginscreen/view/loginscreen.dart';
import 'package:projecy/App/screens/loginscreen/bloc/loginscreen_bloc.dart';
import 'package:projecy/App/screens/personeldetails/view/personeldetails.dart';
import 'package:projecy/App/screens/personeldetails/bloc/personeldetails_bloc.dart';
import 'package:projecy/App/screens/personellist/view/personellist.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class RouteNavigator {
  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.loginscreen:
        (BuildContext context) => MultiBlocProvider(
          providers: [
            BlocProvider<LoginscreenBloc>(
              create: (context) => LoginscreenBloc(authRepository: AuthRepository()),
            ),
            BlocProvider<PasswordVisibilityBloc>(
              create: (context) => PasswordVisibilityBloc(),
            ),
            BlocProvider<RememberMeBloc>(
              create: (context) => RememberMeBloc(pref: SharedPreferences.getInstance()),
            ),
            // Add more BLoCs here if needed
          ],
          child: const Loginscreen(),
        ),
    Routes.personeldetails:
        (BuildContext context) => BlocProvider(
          create: (context) => PersonneldetailsBloc(),
          child: const PersonnelDetails(),
        ),
    Routes.personellist:
        (BuildContext context) => BlocProvider(
          create: (context) => PersonnelListBloc(),
          child: const PersonnelListScreen(),
        ),
  };
}
