import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LeaveRequest {
  final String id;
  final String employeeId;
  final String employeeName;
  final String leaveType;
  final String reason;
  final DateTime startDate;
  final DateTime endDate;
  final String? filePath;
  final String status;
  //final int daysRequested;
  final Timestamp? createdAt;

  LeaveRequest({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.reason,
    required this.startDate,
    required this.endDate,
    this.filePath,
    required this.status,
    //required this.daysRequested
     this.createdAt,
  });

  factory LeaveRequest.fromFirestore(Map<String, dynamic> data, String id) {
    return LeaveRequest(
      id: id,
      employeeId: data['employeeId'] ?? '',
      employeeName: data['employeeName'] ?? '',
      leaveType: data['leaveType'] ?? '',
      reason: data['reason'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      filePath: data['filePath'],
      status: data['status'] ?? 'Pending',
      //daysRequested: data['daysRequested'],
       createdAt: data['createdAt'],
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'leaveType': leaveType,
      'reason': reason,
      'startDate': startDate,
      'endDate': endDate,
      'filePath': filePath,
      'status': status,
      //'daysRequested': daysRequested,

    };
  }

   String get startDateFormatted => DateFormat('dd MMM yyyy').format(startDate);
  String get endDateFormatted => DateFormat('dd MMM yyyy').format(endDate);
  String get createdAtFormatted =>
      createdAt != null ? DateFormat('MMMM dd, yyyy').format(createdAt!.toDate()) : '';
}
