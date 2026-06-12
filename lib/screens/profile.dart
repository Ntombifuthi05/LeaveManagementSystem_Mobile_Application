import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leavemanagementsystem/services/auth_services.dart';
import 'package:leavemanagementsystem/services/employee_services.dart';
import '../models/employee.dart';
import '../routes/route_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final EmployeeService _employeeService = EmployeeService();

  Employee? _employee;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
  }

  Future<void> _loadEmployeeData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final emp = await _employeeService.getEmployeeById(user.uid);
        setState(() {
          _employee = emp;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading profile: $e")),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteManager.loginPage,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employee == null
              ? const Center(
                  child: Text(
                    "No profile data found.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          const CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blue,
                            child: Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _employee!.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _employee!.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const Divider(height: 30, thickness: 1.2),

                          _buildProfileField("Employee ID", _employee!.employeeId),
                          _buildProfileField("Role", _employee!.role),
                          _buildProfileField("Department", _employee!.department),

                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: const Text("Logout"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                "$title:",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black87),
              )),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : "N/A",
              style: const TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
