import 'package:flutter/material.dart';
import 'package:patientrecordsystem/views/pDisplayView.dart';
import 'package:patientrecordsystem/views/pEditView.dart';
import 'package:patientrecordsystem/views/pListView.dart';
import 'package:patientrecordsystem/views/pRegisterView.dart';

class RoutePaths {
  static Route generateRoute(RouteSettings settings){
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => pListView());
      case '/registration':
        return MaterialPageRoute(builder: (_) => pRegisterView());
      case '/display':
        return MaterialPageRoute(builder: (_) => pDisplayView(hospitalid: settings.arguments as int));
      case '/edit':
        return MaterialPageRoute(builder: (_) => pEditView(hospitalid: settings.arguments as int));
      default:
        return routeError();
    }
  }

  static Route<dynamic> routeError() {
    return MaterialPageRoute(builder: (_){
      return Scaffold(
        appBar: AppBar(
          title: Text('ERROR'),
        ),
        body: Center(
          child: Text('Something went wrong'),
        ),
      );
    });
  }
}