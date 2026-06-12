import 'package:flutter/material.dart';
import 'package:leavemanagementsystem/models/leave_request.dart';
import 'package:leavemanagementsystem/screens/check_leave_reports.dart';
import 'package:leavemanagementsystem/screens/dashboard_screen.dart';
import 'package:leavemanagementsystem/screens/edit_leaveapplication.dart';
import 'package:leavemanagementsystem/screens/leave_balance_screen.dart';
import 'package:leavemanagementsystem/screens/leave_details.dart';
import 'package:leavemanagementsystem/screens/leaveapplication_form.dart';
import 'package:leavemanagementsystem/screens/login_screen.dart';
import 'package:leavemanagementsystem/screens/notification_screen.dart';
import 'package:leavemanagementsystem/screens/profile.dart';
import 'package:leavemanagementsystem/screens/view_leave_history.dart';


class RouteManager {
  static const String loginPage = '/login';
  static const String dashboard = '/dashboard';
  static const String applicationForm = '/applyLeave';
  static const String leaveHistory = '/leaveHistory';
  static const String reports = '/reports';
  static const String profile = '/profile';
  static const String leaveDetails = '/leaveDetails';
  static const String editLeave = '/editLeave';
  static const String notifications = '/notificationScreen';
  static const String LeaveBalance = '/leaveBalance';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginPage:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const LeaveDashboardScreen());

      case applicationForm:
        return MaterialPageRoute(builder: (_) => const LeaveApplicationForm());

      case leaveHistory:
        return MaterialPageRoute(builder: (_) => const ViewLeaveHistoryScreen());

      case reports:
        return MaterialPageRoute(builder: (_) => const ReportScreen());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());

      
      case notifications:
        return MaterialPageRoute(
          builder: (context) => NotificationScreen(),
        );

      case LeaveBalance:
        return MaterialPageRoute(
          builder: (context) => const LeaveBalanceScreen(),
        );


      case leaveDetails:
        if (settings.arguments is Map<String, dynamic> &&
            (settings.arguments as Map).containsKey('leaveRequest')) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => LeaveDetailsScreen(leaveRequest: args['leaveRequest']),
          );
        }
        return _errorRoute('Leave Details argument missing');

      case editLeave:
        if (settings.arguments is Map<String, dynamic> &&
            (settings.arguments as Map).containsKey('leaveRequest')) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (_) => EditLeaveApplicationScreen(request: args['leaveRequest']),
          );
        }
        return _errorRoute('Edit Leave argument missing');

      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
