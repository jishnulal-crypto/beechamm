import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecy/App/routes/app_routes.dart';
import 'package:projecy/App/screens/loginscreen/view/loginscreen.dart';
import 'package:projecy/App/screens/loginscreen/bloc/loginscreen_bloc.dart';
import 'package:projecy/App/screens/personeldetails/view/personeldetails.dart';
import 'package:projecy/App/screens/personeldetails/bloc/personeldetails_bloc.dart';
import 'package:projecy/App/screens/personellist/view/personellist.dart';
import 'package:projecy/App/screens/personellist/bloc/personellist_bloc.dart';
abstract class RouteNavigator {
  static final Map<String, Widget Function(BuildContext)> routes = {
    Routes.loginscreen: (BuildContext context) => BlocProvider(
      create: (context) => LoginscreenBloc(),
      child: const Loginscreen(),
    ),
    Routes.personeldetails: (BuildContext context) => BlocProvider(
      create: (context) => PersonneldetailsBloc(),
      child: const PersonnelDetails(),
    ),
    Routes.personellist: (BuildContext context) => BlocProvider(
      create: (context) => PersonnelListBloc(),
      child: const PersonnelListScreen(),
    ),
  };
}
