import 'package:flutter/material.dart';
import 'package:leavemanagementsystem/models/leave_balance.dart';
import 'package:leavemanagementsystem/viewmodels/leave_application_viewmodel.dart'; // Assuming this holds LeaveRequestViewModel
import 'package:leavemanagementsystem/viewmodels/leavebalance_viewmodel.dart';
import 'package:provider/provider.dart';

class LeaveBalanceScreen extends StatelessWidget {
  const LeaveBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We now use the LeaveBalanceViewModel to fetch balances
    final leaveBalanceVM = Provider.of<LeaveBalanceViewModel>(context, listen: false);

    // REMOVED: const Map<String, int> leaveEntitlements = {...};
    // The total entitlements and remaining days are now fetched from Firestore.

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Balance Summary"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      // CHANGE: Use StreamBuilder to listen to LeaveBalance records
      body: StreamBuilder<List<LeaveBalance>>(
        stream: leaveBalanceVM.getUserLeaveBalances(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
             return Center(child: Text("Error fetching data: ${snapshot.error}"));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No leave balances found in the database."));
          }

          final leaveBalances = snapshot.data!;

          // Process the balances into DataRows
          final List<DataRow> rows = [];
          for (var balance in leaveBalances) {
            final remaining = balance.daysLeft; // daysLeft is the final balance from Firestore
            final type = balance.leaveType;
            
            rows.add(
              DataRow(cells: [
                DataCell(Text(type)),
                DataCell(Text(
                  remaining.toString(),
                  style: TextStyle(
                    // Determine color based on remaining days
                    color: remaining > 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ]),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        "Leave Balance Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.teal.shade100,
                        ),
                        border: TableBorder.all(color: Colors.grey.shade300),
                        columns: const [
                          DataColumn(
                            label: Text(
                              "Leave Type",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Days Left",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            numeric: true,
                          ),
                        ],
                        rows: rows,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}