import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leavemanagementsystem/models/leave_request.dart';

class LeaveDetailsScreen extends StatelessWidget {
  final LeaveRequest leaveRequest;
  const LeaveDetailsScreen({super.key, required this.leaveRequest});

  Future<void> _openFile(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not open file';
    }
  }

  @override
  Widget build(BuildContext context) {
    final lr = leaveRequest;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _rowLabelValue('Employee', lr.employeeName),
                const SizedBox(height: 8),
                _rowLabelValue('Leave Type', lr.leaveType),
                const SizedBox(height: 8),
                _rowLabelValue('Reason', lr.reason),
                const SizedBox(height: 8),
                _rowLabelValue('Start Date', lr.startDate.toLocal().toString().split(' ')[0]),
                const SizedBox(height: 8),
                _rowLabelValue('End Date', lr.endDate.toLocal().toString().split(' ')[0]),
                const SizedBox(height: 8),
                _rowLabelValue('Days', '${lr.endDate.difference(lr.startDate).inDays + 1}'),
                const SizedBox(height: 8),
                _rowLabelValue('Status', lr.status),
                const SizedBox(height: 16),
                if (lr.filePath != null && lr.filePath!.isNotEmpty) ...[
                  Text('Attachment:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(child: Text(lr.filePath!.split('?').first.split('/').last)),
                      TextButton.icon(
                        onPressed: () => _openFile(lr.filePath!),
                        icon: const Icon(Icons.download),
                        label: const Text('Open'),
                      )
                    ],
                  )
                ] else
                  const Text('No attachment provided.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowLabelValue(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
