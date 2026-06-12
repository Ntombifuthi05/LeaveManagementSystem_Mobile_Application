// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:provider/provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:leavemanagementsystem/models/leave_request.dart';
// import 'package:leavemanagementsystem/viewmodels/leave_application_viewmodel.dart';

// class LeaveApplicationForm extends StatefulWidget {
//   const LeaveApplicationForm({super.key});

//   @override
//   State<LeaveApplicationForm> createState() => _LeaveApplicationFormState();
// }

// class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _dateFormat = DateFormat("yyyy-MM-dd");

//   String? _selectedLeaveType;
//   String? _selectedReason;
//   DateTime? _startDate;
//   DateTime? _endDate;
//   String? _filePath;

//   final List<String> leaveTypes = [
//     "Sick Leave",
//     "Annual Leave",
//     "Maternity Leave",
//     "Paternity Leave",
//     "Study Leave",
//   ];

//   final List<String> reasons = [
//     "Medical",
//     "Vacation",
//     "Family Emergency",
//     "Studies",
//     "Other",
//   ];

//   Future<void> _pickDate({required bool isStart}) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: isStart
//           ? (_startDate ?? DateTime.now())
//           : (_endDate ?? _startDate ?? DateTime.now()),
//       firstDate: DateTime(2024),
//       lastDate: DateTime(2030),
//     );

//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startDate = picked;
//           // Ensure the end date isn't before the start date
//           if (_endDate != null && _endDate!.isBefore(_startDate!)) {
//             _endDate = null;
//           }
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }

//   Future<void> _pickFile() async {
//     try {
//       final result = await FilePicker.platform.pickFiles();
//       if (result != null) {
//         setState(() {
//           _filePath = result.files.single.path ?? result.files.single.name;
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error picking file: $e")),
//       );
//     }
//   }

//   Future<void> _submitForm() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (_startDate == null || _endDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select both dates")),
//       );
//       return;
//     }

//     try {
//       final user = FirebaseAuth.instance.currentUser;
//       if (user == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("User not logged in")),
//         );
//         return;
//       }

//       final leaveRequest = LeaveRequest(
//         id: "", // Firestore will auto-generate
//         employeeId: user.uid,
//         employeeName: user.displayName ?? "Employee",
//         leaveType: _selectedLeaveType!,
//         reason: _selectedReason!,
//         startDate: _startDate!,
//         endDate: _endDate!,
//         filePath: _filePath ?? "",
//         status: "Pending",
//       );

//       await Provider.of<LeaveRequestViewModel>(context, listen: false)
//           .submitLeaveRequest(leaveRequest, _filePath);

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Leave application submitted successfully")),
//         );
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Error submitting leave: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<LeaveRequestViewModel>(context);
//     final user = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       appBar: AppBar(
//         title: const Text("Apply for Leave"),
//         backgroundColor: Colors.blue,
//         centerTitle: true,
//       ),
//       body: vm.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     // 🔹 Prefilled Name
//                     TextFormField(
//                       initialValue: user?.displayName ?? "Employee",
//                       enabled: false,
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.person),
//                         labelText: "Name",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 12),

//                     // 🔹 Prefilled Email
//                     TextFormField(
//                       initialValue: user?.email ?? "No email found",
//                       enabled: false,
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.email),
//                         labelText: "Email",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // 🔹 Leave Type
//                     DropdownButtonFormField<String>(
//                       initialValue: _selectedLeaveType,
//                       items: leaveTypes
//                           .map((type) => DropdownMenuItem(
//                                 value: type,
//                                 child: Text(type),
//                               ))
//                           .toList(),
//                       onChanged: (val) => setState(() => _selectedLeaveType = val),
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.work_history),
//                         labelText: "Leave Type",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (val) =>
//                           val == null ? "Please select leave type" : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // 🔹 Reason
//                     DropdownButtonFormField<String>(
//                       initialValue: _selectedReason,
//                       items: reasons
//                           .map((reason) => DropdownMenuItem(
//                                 value: reason,
//                                 child: Text(reason),
//                               ))
//                           .toList(),
//                       onChanged: (val) => setState(() => _selectedReason = val),
//                       decoration: const InputDecoration(
//                         prefixIcon: Icon(Icons.note_alt),
//                         labelText: "Reason",
//                         border: OutlineInputBorder(),
//                       ),
//                       validator: (val) =>
//                           val == null ? "Please select reason" : null,
//                     ),
//                     const SizedBox(height: 16),

//                     // 🔹 Start & End Dates
//                     Row(
//                       children: [
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             icon: const Icon(Icons.date_range),
//                             label: Text(_startDate == null
//                                 ? "Start Date"
//                                 : _dateFormat.format(_startDate!)),
//                             onPressed: () => _pickDate(isStart: true),
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: OutlinedButton.icon(
//                             icon: const Icon(Icons.date_range),
//                             label: Text(_endDate == null
//                                 ? "End Date"
//                                 : _dateFormat.format(_endDate!)),
//                             onPressed: () => _pickDate(isStart: false),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // 🔹 File Upload
//                     Row(
//                       children: [
//                         ElevatedButton.icon(
//                           onPressed: _pickFile,
//                           icon: const Icon(Icons.attach_file),
//                           label: const Text("Choose File"),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Text(
//                             _filePath != null
//                                 ? _filePath!.split('/').last
//                                 : "No file selected",
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // 🔹 Submit + Cancel
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: vm.isLoading ? null : _submitForm,
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.blue),
//                           child: const Text("Submit"),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.grey),
//                           child: const Text("Cancel"),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

//import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
//import 'dart:io';

import 'package:leavemanagementsystem/models/leave_request.dart';
import 'package:leavemanagementsystem/routes/route_manager.dart';
import 'package:leavemanagementsystem/viewmodels/leave_application_viewmodel.dart';
import 'package:provider/provider.dart';

class LeaveApplicationForm extends StatefulWidget {
  const LeaveApplicationForm({super.key});

  @override
  State<LeaveApplicationForm> createState() => _LeaveApplicationFormState();
}

class _LeaveApplicationFormState extends State<LeaveApplicationForm> {
  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();

  String? _selectedLeaveType;
  String? _selectedReason;
  DateTime? _startDate;
  DateTime? _endDate;
  //File? _selectedFile;
  String? _filePath;

  // Leave types and which require documents
  final Map<String, bool> _leaveTypeRequiresDoc = {
    'Annual Leave': false,
    'Sick Leave': true,
    'Maternity Leave': true,
    'Family Responsibility': false,
  };

  final List<String> reasons = [
    "Medical",
    "Vacation",
    "Family Emergency",
    "Studies",
    "Other",
  ];


  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _filePath = result.files.single.path ?? result.files.single.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking file: $e")));
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }


  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;
  if (_startDate == null || _endDate == null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Please select both dates")));
    return;
  }

  try {
    final vm = Provider.of<LeaveRequestViewModel>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final leaveRequest = LeaveRequest(
      id: "",
      employeeId: user.uid,
      employeeName: user.displayName ?? "Employee",
      leaveType: _selectedLeaveType!,
      reason: _selectedReason!,
      startDate: _startDate!,
      endDate: _endDate!,
      filePath: _filePath ?? "",
      status: "Pending",
    );

    await vm.submitLeaveRequest(leaveRequest, _filePath);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Leave application submitted successfully")));
      Navigator.pushNamed(context, RouteManager.dashboard);
    }
  } catch (e) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(e.toString())));
  }
}


  @override
  Widget build(BuildContext context) {
    final requiresDocument = _selectedLeaveType != null
        ? _leaveTypeRequiresDoc[_selectedLeaveType] ?? false
        : false;
     final vm = Provider.of<LeaveRequestViewModel>(context);
     final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Application Form'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 🔹 Prefilled Name
              TextFormField(
                //initialValue:  employeeName,
                initialValue: user?.displayName ?? "Employee",
                enabled: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: "Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              // 🔹 Prefilled Email
              TextFormField(
                initialValue: user?.email ?? "No email found",
                enabled: false,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Leave Type Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Leave Type',
                  border: OutlineInputBorder(),
                ),
                items: _leaveTypeRequiresDoc.keys.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLeaveType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a leave type' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                items: reasons
                    .map(
                      (reason) =>
                          DropdownMenuItem(value: reason, child: Text(reason)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedReason = val),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.note_alt),
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null ? "Please select reason" : null,
              ),

              const SizedBox(height: 16),
              // Start and End Dates
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: _startDate != null
                            ? _startDate!.toLocal().toString().split(' ')[0]
                            : '',
                      ),
                      onTap: () => _selectDate(context, true),
                      validator: (value) =>
                          _startDate == null ? 'Select start date' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(
                        text: _endDate != null
                            ? _endDate!.toLocal().toString().split(' ')[0]
                            : '',
                      ),
                      onTap: () => _selectDate(context, false),
                      validator: (value) =>
                          _endDate == null ? 'Select end date' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Reason
              // TextFormField(
              //   controller: _reasonController,
              //   maxLines: 2,
              //   decoration: const InputDecoration(
              //     labelText: 'Reason',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (value) =>
              //       value == null || value.isEmpty ? 'Reason required' : null,
              // ),
              const SizedBox(height: 16),

              // Comments (Optional)
              TextFormField(
                controller: _commentsController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Comments (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Supporting Document Section
              Opacity(
                opacity: requiresDocument ? 1 : 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Supporting Document',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: requiresDocument
                          ? _pickFile
                          : null, // disable if not required
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload File'),
                    ),
                    if (_filePath != null)
                      Text(
                        'File: ${_filePath!.split('/').last}',
                        style: const TextStyle(fontSize: 14),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              // ElevatedButton(
              //   onPressed: _submitForm,
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.indigo,
              //     padding: const EdgeInsets.symmetric(vertical: 14),
              //   ),
              //   child: const Text('Submit', style: TextStyle(fontSize: 16)),
              // ),

                Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: vm.isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text("Submit"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          child: const Text("Cancel"),
                        ),
                      ]
                ),
          
            ],
          ),
        ),
      ),
    );
  }
}
