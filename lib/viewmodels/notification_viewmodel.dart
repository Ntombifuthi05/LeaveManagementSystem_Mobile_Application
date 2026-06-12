import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leavemanagementsystem/models/notification.dart';

class NotificationViewModel extends ChangeNotifier {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? _employeeId;
  bool isLoading = false;

  // call once at start
  Future<void> init() async {
    isLoading = true;
    notifyListeners();

    final user = _auth.currentUser;
    if (user == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    // Find matching Employees doc by email (your Employees doc id is E001 etc)
    try {
      final qs = await _db
          .collection('Employees')
          .where('email', isEqualTo: user.email)
          .limit(1)
          .get();

      if (qs.docs.isNotEmpty) {
        _employeeId = qs.docs.first.id;
      } else {
        // fallback: maybe Employee doc id equals uid — try that
        final alt = await _db.collection('Employees').doc(user.uid).get();
        if (alt.exists) _employeeId = alt.id;
      }
    } catch (e) {
      // ignore for now
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // stream of notifications for this employee
  Stream<List<AppNotification>> streamNotifications() {
    if (_employeeId == null) {
      // empty stream until init resolves
      return const Stream<List<AppNotification>>.empty();
    }

   return _db
      .collection('Notifications')
      .where('employeeId', isEqualTo: _employeeId)
      .snapshots()
      .map((snap) {
        final list = snap.docs
            .map((doc) => AppNotification.fromFirestore(doc))
            .toList();

        // ✅ Local sort instead of Firestore orderBy
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return list;
      });
  }

  Future<void> markAsRead(String notificationId) async {
    await _db.collection('Notifications').doc(notificationId).update({'isRead': true});
  }
  
}
