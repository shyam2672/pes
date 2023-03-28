import 'package:flutter/material.dart';
import 'package:pes_admin/router.dart';

void main() {
  runApp(PehchaanAdminApp(
    router: AppRouter(),
  ));
}

class PehchaanAdminApp extends StatelessWidget {
  final AppRouter? router;
  const PehchaanAdminApp({Key? key, this.router}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pehchaan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: router!.generateRoute,
    );
  }
}
