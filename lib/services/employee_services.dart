import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee.dart';

class EmployeeService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  final String collectionName = 'Employees';

  // 🔹 Get employee by Firebase UID (current user)
  Future<Employee?> getEmployeeById(String id) async {
    final doc = await _db.collection('Employees').doc(id).get();
    if (!doc.exists) return null;
    return Employee.FromFirestore(doc.data()!, doc.id);
  }

  // 🔹 Stream employee details for real-time updates
  Stream<Employee?> streamEmployee(String id) {
    return _db.collection(collectionName).doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Employee.FromFirestore(doc.data()!, doc.id);
    });
  }

  // 🔹 Get all employees (for managers/supervisors if needed)
  Future<List<Employee>> getAllEmployees() async {
    final querySnapshot = await _db.collection(collectionName).get();
    return querySnapshot.docs
        .map((doc) => Employee.FromFirestore(doc.data(), doc.id))
        .toList();
  }
}
