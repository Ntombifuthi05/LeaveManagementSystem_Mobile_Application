class Employee {
  final String employeeId;
  final String name;
  final String email;
  final String role;
  final String department;
  final String? managerId;

  Employee({required this.employeeId, required this.name, required this.email, required this.role, required this.department, this.managerId});

  factory Employee.FromFirestore(Map<String, dynamic> data, String documentId){
  return Employee(
    employeeId: documentId,
    name: data['name'] ?? '',
    email: data['email'] ?? '',
    role: data['role'] ?? 'Employee',
    department: data['department'] ?? '',
    managerId: data['managerID'],
  );
}

Map<String, dynamic> toFirestore(){
  return {
    'name': name,
    'email': email,
    'role': role,
    'department': department,
    'managerId': managerId,
  };
}
}