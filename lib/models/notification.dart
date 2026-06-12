import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String employeeId; // target E001
  final String title;
  final String message;
  final String leaveRequestId;
  final String status;
  final DateTime createdAt;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.employeeId,
    required this.title,
    required this.message,
    required this.leaveRequestId,
    required this.status,
    required this.createdAt,
    required this.isRead,
  });

  factory AppNotification.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppNotification(
      id: doc.id,
      employeeId: data['employeeId'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      leaveRequestId: data['leaveRequestId'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] != null && data['createdAt'] is Timestamp)
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      isRead: data['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'employeeId': employeeId,
      'title': title,
      'message': message,
      'leaveRequestId': leaveRequestId,
      'status': status,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': isRead,
    };
  }
}
