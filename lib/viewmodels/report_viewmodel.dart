import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/leave_request.dart'; // Ensure this path is correct

class ReportViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;
  List<LeaveRequest> reportResults = [];

  Future<void> fetchReports({
    String? leaveType,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      debugPrint("⚠️ No logged-in user found.");
      reportResults = [];
      notifyListeners();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // 1. Fetch only current user's leave requests from Firestore
      final snapshot = await _firestore
          .collection('LeaveRequests')
          .where('employeeEmail', isEqualTo: currentUser.email)
          .orderBy('startDate', descending: true)
          .get();

      // 2. Convert to model list
      List<LeaveRequest> all = snapshot.docs
          .map((doc) =>
              LeaveRequest.fromFirestore(doc.data(), doc.id))
          .toList();

      // 3. Client-side filtering
      if (leaveType != null && leaveType.isNotEmpty) {
        all = all.where((r) => r.leaveType == leaveType).toList();
      }

      if (startDate != null && endDate != null) {
        // Normalize dates for comparison (start of day)
        final DateTime filterStart =
            DateTime(startDate.year, startDate.month, startDate.day);
        final DateTime filterEnd =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

        all = all.where((r) {
          final start = r.startDate;
          final end = r.endDate;
          
          // Check for overlap: request is included if it doesn't end before the filter starts 
          // AND doesn't start after the filter ends.
          return !(end.isBefore(filterStart) || start.isAfter(filterEnd));
        }).toList();
      }

      reportResults = all;
    } catch (e) {
      debugPrint("❌ Error fetching report: $e");
      // Optionally show a snackbar or alert to the user here
      reportResults = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}