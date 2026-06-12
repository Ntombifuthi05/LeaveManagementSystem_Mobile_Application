import 'package:flutter/material.dart';
import 'package:leavemanagementsystem/services/auth_services.dart';
import '../routes/route_manager.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              "Menu",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outline),
            title: const Text("Apply for Leave"),
            onTap: () => Navigator.pushNamed(context, RouteManager.applicationForm),
          ),
          // ListTile(
          //   leading: const Icon(Icons.bar_chart),
          //   title: const Text("Check Leave Reports"),
          //   onTap: () => Navigator.pushNamed(context, RouteManager.reports),
          // ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("View Leave History"),
            onTap: () => Navigator.pushNamed(context, RouteManager.leaveHistory),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              await authService.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteManager.loginPage, (route) => false);
              }
            },
          ),
        ],
      ),
    );
  }
}
