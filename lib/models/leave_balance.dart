import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveBalance {
  final String id;
  final String employeeId;
  final String employeeName; // <-- NEW: Added from Firestore field
  final String leaveType;
  final int daysLeft;
  final DateTime lastUpdated; // <-- NEW: Added from Firestore field

  LeaveBalance({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.daysLeft,
    required this.lastUpdated,
  });

  factory LeaveBalance.fromFirestore(Map<String, dynamic> data, String id) {
    // Check if data is null or empty before accessing keys
    if (data == null || data.isEmpty) {
        throw StateError('Cannot create LeaveBalance from empty data');
    }

    // Safely extract the Timestamp and convert it to DateTime
    final Timestamp? lastUpdatedTimestamp = data['lastUpdated'] as Timestamp?;
    final DateTime parsedLastUpdated = lastUpdatedTimestamp?.toDate() ?? DateTime.now();

    return LeaveBalance(
      id: id,
      employeeId: data['employeeId'] ?? '',
      employeeName: data['employeeName'] ?? 'N/A', // Map employeeName
      leaveType: data['leaveType'] ?? '',
      daysLeft: (data['daysLeft'] as num?)?.toInt() ?? 0, // Firestore numbers are often num, convert to int
      lastUpdated: parsedLastUpdated,
      
      // Removed: entitledDays, usedDays, balanceDays, year 
      // because they are not in the Firestore document.
    );
  }
}