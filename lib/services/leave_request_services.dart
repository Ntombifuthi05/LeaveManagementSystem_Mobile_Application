import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leave_request.dart';

class LeaveRequestService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionName = 'LeaveRequests';

  // 🔹 Submit a new leave request
  Future<void> submitLeaveRequest(LeaveRequest request) async {
    await _db.collection(collectionName).add(request.toMap());
  }

  // 🔹 Get all leave requests for a specific employee (by user.uid)
  Future<List<LeaveRequest>> getLeaveRequestsByUser(String uid) async {
    try {
      final snapshot = await _db
          .collection(collectionName)
          .where('employeeId', isEqualTo: uid)
          .orderBy('startDate', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => LeaveRequest.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('❌ Error fetching leave requests: $e');
      return [];
    }
  }

  // 🔹 Update an existing leave request (e.g. cancel or edit)
  Future<void> updateLeaveRequest(String id, Map<String, dynamic> data) async {
    await _db.collection(collectionName).doc(id).update(data);
  }

  // 🔹 Delete or cancel a leave request
  Future<void> cancelLeaveRequest(String id) async {
    await _db.collection(collectionName).doc(id).update({'status': 'Cancelled'});
  }
}
