import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:leavemanagementsystem/services/employee_services.dart';
import 'package:leavemanagementsystem/viewmodels/notification_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/employee.dart';
import '../routes/route_manager.dart';
import '../widgets/menu_drawer.dart';

class LeaveDashboardScreen extends StatefulWidget {
  const LeaveDashboardScreen({super.key});

  @override
  State<LeaveDashboardScreen> createState() => _LeaveDashboardScreenState();
}

class _LeaveDashboardScreenState extends State<LeaveDashboardScreen> {
  final EmployeeService _employeeService = EmployeeService();
  final user = FirebaseAuth.instance.currentUser;

  Employee? _employee;
  bool _loading = true;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _fetchEmployee();
    Future.microtask(() async {
    final notifVM = Provider.of<NotificationViewModel>(context, listen: false);
    await notifVM.init();
  });
  }

  Future<void> _fetchEmployee() async {
    if (user == null) return;
    final emp = await _employeeService.getEmployeeById(user!.uid);
    setState(() {
      _employee = emp;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Welcome, ${_employee?.name ?? "Employee"}'),
      ),
      drawer: const MenuDrawer(),

      body: Column(
        children: [
          // 🔹 Top Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[300]!, Colors.blue[700]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Image.asset("assets/images/Logo_LMS.png", height: 50),
                const SizedBox(height: 8),
                const Text(
                  "LEAVE MANAGEMENT SYSTEM",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // 🔹 Calendar Section
          Container(
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  "Calendar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),

                // TableCalendar(
                //   firstDay: DateTime.utc(2020, 1, 1),
                //   lastDay: DateTime.utc(2030, 12, 31),
                //   focusedDay: _focusedDay,
                //   selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                //   onDaySelected: (selectedDay, focusedDay) {
                //     setState(() {
                //       _selectedDay = selectedDay;
                //       _focusedDay = focusedDay;
                //     });
                //   },
                //   headerVisible: false,
                //   calendarStyle: const CalendarStyle(
                //     todayDecoration:
                //         BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                //     selectedDecoration:
                //         BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                //   ),
                // ),
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },

                  // ✅ Show the month header
                  headerVisible: true,

                  // ✅ Customize header style
                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    leftChevronIcon: Icon(
                      Icons.chevron_left,
                      color: Colors.blue,
                    ),
                    rightChevronIcon: Icon(
                      Icons.chevron_right,
                      color: Colors.blue,
                    ),
                  ),

                  // ✅ Improve calendar style
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    weekendTextStyle: TextStyle(color: Colors.redAccent),
                  ),

                  // ✅ Allow user to swipe between months
                  pageAnimationEnabled: true,
                  pageJumpingEnabled: true,
                  availableGestures:
                      AvailableGestures.all, // Swipe or tap to navigate months
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue[100],
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calculate),
            label: "Balance",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notification",
          ),
          // BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.pushNamed(context, RouteManager.LeaveBalance);
              break;
            case 2:
              Navigator.pushNamed(context, RouteManager.notifications);
              break;
            // case 3:
            //   //Navigator.pushNamed(context, RouteManager.profile);
            //   break;
          }
        },
      ),
    );
  }
}
