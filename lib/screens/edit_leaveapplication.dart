import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:leavemanagementsystem/models/leave_request.dart';
import 'package:leavemanagementsystem/viewmodels/leave_application_viewmodel.dart';
import 'package:provider/provider.dart';

class EditLeaveApplicationScreen extends StatefulWidget {
  final LeaveRequest request;

  const EditLeaveApplicationScreen({
    super.key,
    required this.request,
  });

  @override
  State<EditLeaveApplicationScreen> createState() =>
      _EditLeaveApplicationScreenState();
}

class _EditLeaveApplicationScreenState
    extends State<EditLeaveApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateFormat = DateFormat("yyyy-MM-dd");

  late String _selectedLeaveType;
  late String _selectedReason;
  late DateTime _startDate;
  late DateTime _endDate;

  final List<String> leaveTypes = [
    "Sick Leave",
    "Annual Leave",
    "Maternity Leave",
    "Paternity Leave",
    "Study Leave",
  ];

  final List<String> reasons = [
    "Medical",
    "Vacation",
    "Family Emergency",
    "Studies",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _selectedLeaveType = widget.request.leaveType;
    _selectedReason = widget.request.reason;
    _startDate = widget.request.startDate;
    _endDate = widget.request.endDate;
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _updateLeave() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedRequest = LeaveRequest(
      id: widget.request.id,
      employeeId: widget.request.employeeId,
      employeeName: widget.request.employeeName,
      leaveType: _selectedLeaveType,
      reason: _selectedReason,
      startDate: _startDate,
      endDate: _endDate,
      filePath: widget.request.filePath,
      status: "Pending", // Reverts to pending when edited
    );

    try {
      await Provider.of<LeaveRequestViewModel>(context, listen: false)
          .updateLeaveRequest(updatedRequest);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Leave request updated successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating leave: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LeaveRequestViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Edit Leave Application"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Leave Type
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLeaveType,
                      items: leaveTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedLeaveType = value!),
                      decoration: const InputDecoration(
                        labelText: "Leave Type",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Reason
                    DropdownButtonFormField<String>(
                      initialValue: _selectedReason,
                      items: reasons
                          .map((r) => DropdownMenuItem(
                                value: r,
                                child: Text(r),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _selectedReason = value!),
                      decoration: const InputDecoration(
                        labelText: "Reason",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Start and End Dates
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.date_range),
                            label: Text(
                              "Start: ${_dateFormat.format(_startDate)}",
                            ),
                            onPressed: () => _pickDate(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.date_range),
                            label: Text(
                              "End: ${_dateFormat.format(_endDate)}",
                            ),
                            onPressed: () => _pickDate(isStart: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save),
                          label: const Text("Update"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: _updateLeave,
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cancel),
                          label: const Text("Cancel"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
