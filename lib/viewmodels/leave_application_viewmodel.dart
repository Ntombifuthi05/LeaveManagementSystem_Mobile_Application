import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/leave_request.dart';

class LeaveRequestViewModel extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  bool isLoading = false;
  List<LeaveRequest> leaveRequests = [];

  /// 🔹 Fetch public holidays from Firestore
  Future<Set<DateTime>> fetchHolidays() async {
    final snapshot = await _firestore.collection('Holidays').get();
    return snapshot.docs
        .map((doc) => (doc['date'] as Timestamp).toDate())
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet();
  }

  /// 🔹 Calculate business days excluding weekends and holidays
  Future<int> calculateBusinessDays(
      DateTime start, DateTime end, Set<DateTime> holidays) async {
    int totalDays = 0;
    for (DateTime date = start;
        date.isBefore(end.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      if (date.weekday == DateTime.saturday ||
          date.weekday == DateTime.sunday ||
          holidays.contains(DateTime(date.year, date.month, date.day))) {
        continue;
      }
      totalDays++;
    }
    return totalDays;
  }

  /// 🔹 Get leave balance for employee and leave type
  Future<int> fetchLeaveBalance(String employeeId, String leaveType) async {
    final snapshot = await _firestore
        .collection('LeaveBalances')
        .where('employeeId', isEqualTo: employeeId)
        .where('leaveType', isEqualTo: leaveType)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return (snapshot.docs.first.data()['daysLeft'] as num).toInt();
    }
    return 0;
  }

  /// 🔹 SUBMIT a new leave request (with validation)
  Future<void> submitLeaveRequest(
      LeaveRequest leaveRequest, String? localFilePath) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      // 🔹 Get employee document
      final empSnapshot = await _firestore
          .collection('Employees')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (empSnapshot.docs.isEmpty) {
        throw Exception("No employee record found for ${user.email}");
      }

      final employeeDoc = empSnapshot.docs.first;
      final employeeId = employeeDoc.id;
      final employeeName = employeeDoc['name'];

      // 🔹 Fetch holidays
      final holidays = await fetchHolidays();

      // 🔹 Calculate working days excluding weekends + holidays
      final int workingDays =
          await calculateBusinessDays(leaveRequest.startDate, leaveRequest.endDate, holidays);

      // 🔹 Get balance for this leave type
      final int availableDays =
          await fetchLeaveBalance(employeeId, leaveRequest.leaveType);

      if (workingDays > availableDays) {
        throw Exception(
            "You requested $workingDays days but only have $availableDays days left for ${leaveRequest.leaveType}.");
      }

      // 🔹 Optional file upload
      String fileUrl = '';
      if (localFilePath != null && localFilePath.isNotEmpty) {
        final fileName = localFilePath.split('/').last;
        final ref =
            _storage.ref().child('leave_attachments/$employeeId/$fileName');
        final uploadTask = await ref.putFile(File(localFilePath));
        fileUrl = await uploadTask.ref.getDownloadURL();
      }

      // 🔹 Prepare data
      final data = leaveRequest.toMap();
      data['employeeId'] = employeeId;
      data['employeeName'] = employeeName;
      data['employeeEmail'] = user.email;
      data['filePath'] = fileUrl;
      data['daysRequested'] = workingDays;
      data['createdAt'] = FieldValue.serverTimestamp();

      // 🔹 Save to Firestore
      await _firestore.collection('LeaveRequests').add(data);

    } catch (e) {
      debugPrint("Error submitting leave: $e");
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Stream leave requests for logged-in user
  Stream<List<LeaveRequest>> getUserLeaveRequests() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('LeaveRequests')
        .where('employeeEmail', isEqualTo: user.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaveRequest.fromFirestore(doc.data(), doc.id))
            .toList()
          ..sort((a, b) => (b.createdAt ?? Timestamp(0, 0))
              .compareTo(a.createdAt ?? Timestamp(0, 0))));
  }

   Future<void> deleteLeaveRequest(String id) async {
    try {
      await _firestore.collection('LeaveRequests').doc(id).delete();
    } catch (e) {
      throw Exception("Error deleting leave request: $e");
    }
  }

  Future<void> updateLeaveRequest(LeaveRequest leaveRequest) async {
    isLoading = true;
    notifyListeners();
    try {
      await _firestore
          .collection('LeaveRequests')
          .doc(leaveRequest.id)
          .update(leaveRequest.toMap());
    } catch (e) {
      throw Exception("Error updating leave request: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
