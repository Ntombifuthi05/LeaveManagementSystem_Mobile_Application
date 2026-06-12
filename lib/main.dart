import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:leavemanagementsystem/firebase_options.dart';
import 'package:leavemanagementsystem/routes/route_manager.dart';
import 'package:leavemanagementsystem/viewmodels/leave_application_viewmodel.dart';
import 'package:leavemanagementsystem/viewmodels/leavebalance_viewmodel.dart';
import 'package:leavemanagementsystem/viewmodels/notification_viewmodel.dart';
import 'package:leavemanagementsystem/viewmodels/report_viewmodel.dart';
import 'package:provider/provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeaveRequestViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        ChangeNotifierProvider(create: (_) => ReportViewModel()),
        ChangeNotifierProvider(create: (_) => LeaveBalanceViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Leave Management System',
  theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
  onGenerateRoute: RouteManager.generateRoute,
  initialRoute: RouteManager.loginPage,
);
  }
}
