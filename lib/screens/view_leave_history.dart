import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/leave_request.dart';
import '../screens/edit_leaveapplication.dart';
import '../screens/leave_details.dart';
import '../viewmodels/leave_application_viewmodel.dart';

class ViewLeaveHistoryScreen extends StatefulWidget {
  const ViewLeaveHistoryScreen({super.key});

  @override
  State<ViewLeaveHistoryScreen> createState() => _ViewLeaveHistoryScreenState();
}

class _ViewLeaveHistoryScreenState extends State<ViewLeaveHistoryScreen> {
  int _calculateLeaveDays(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }

  Future<void> _confirmCancel(BuildContext context, LeaveRequest request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Cancel Leave Request"),
        content: const Text("Are you sure you want to cancel this request?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("No"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Yes, Cancel"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await Provider.of<LeaveRequestViewModel>(context, listen: false)
          .deleteLeaveRequest(request.id!);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Leave request cancelled")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the viewmodel (don't listen here, only use it to obtain the stream like your old app)
    final leaveVM = Provider.of<LeaveRequestViewModel>(context, listen: false);

    // --- MATCHING LOGIC: obtain the stream first and store in a local variable ---
    final Stream<List<LeaveRequest>> leaveStream = leaveVM.getUserLeaveRequests();

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Leave History"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: StreamBuilder<List<LeaveRequest>>(
        stream: leaveStream,
        builder: (context, snapshot) {
          // Waiting/loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error handling
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // Empty state
          final requests = snapshot.data ?? [];
          if (requests.isEmpty) {
            return const Center(
              child: Text("No leave requests found"),
            );
          }

          // Data state
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final leave = requests[index];
              final days = _calculateLeaveDays(leave.startDate, leave.endDate);

              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    Icons.event_note,
                    color: leave.status == "Approved"
                        ? Colors.green
                        : leave.status == "Rejected"
                            ? Colors.red
                            : Colors.orange,
                  ),
                  title: Text("${leave.leaveType} • ${days.toString()} days"),
                  subtitle: Text(
                    "From ${leave.startDate.toLocal().toString().split(' ')[0]} "
                    "to ${leave.endDate.toLocal().toString().split(' ')[0]}\n"
                    "Status: ${leave.status}",
                  ),
                  isThreeLine: true,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaveDetailsScreen(
                        leaveRequest: leave,
                      ),
                    ),
                  ),
                  trailing: leave.status == "Pending"
                      ? PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "Edit") {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditLeaveApplicationScreen(request: leave),
                                ),
                              );
                            } else if (value == "Cancel") {
                              _confirmCancel(context, leave);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                                value: "Edit", child: Text("Edit")),
                            const PopupMenuItem(
                                value: "Cancel", child: Text("Cancel")),
                          ],
                        )
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
