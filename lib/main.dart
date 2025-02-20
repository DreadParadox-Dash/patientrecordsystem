import 'package:flutter/material.dart';
import 'package:patientrecordsystem/backend/functions.dart';
import 'package:patientrecordsystem/routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => Functions(),
    child: MaterialApp(
      title: 'Patient Registration',
      initialRoute: '/',
      onGenerateRoute: RoutePaths.generateRoute,
    ),
  );
}

