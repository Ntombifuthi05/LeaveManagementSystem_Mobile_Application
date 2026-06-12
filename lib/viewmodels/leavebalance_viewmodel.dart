import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/leave_balance.dart';

class LeaveBalanceViewModel extends ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<List<LeaveBalance>> getUserLeaveBalances() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
      .collection('LeaveBalances')
      .where('employeeName', isEqualTo: user.displayName) // Filter by the currently logged-in user's ID
      .snapshots()
      .map((snap) => snap.docs
          .map((doc) => LeaveBalance.fromFirestore(doc.data(), doc.id))
          .toList());
  }
}