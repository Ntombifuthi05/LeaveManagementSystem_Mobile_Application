import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../viewmodels/report_viewmodel.dart';
import '../models/leave_request.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? selectedLeaveType;
  DateTime? startDate;
  DateTime? endDate;

  final leaveTypes = ['Annual', 'Sick', 'Maternity', 'Study'];

  // 1. Initial Data Fetch: Using context.read (or Provider.of(context, listen: false))
  @override
  void initState() {
    super.initState();
    // Fetch initial reports for the logged-in user on load
    context.read<ReportViewModel>().fetchReports();
  }

  // Helper function for input decoration
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  // --- PDF GENERATION LOGIC ---

  Future<void> _generatePdf(List<LeaveRequest> reports) async {
    final pdf = pw.Document();

    // Prepare table data
    final headers = ['Type', 'Start Date', 'End Date', 'Days', 'Status'];
    final data = reports.map((leave) {
      // Calculate the number of days (inclusive of start and end date)
      final int days = leave.endDate.difference(leave.startDate).inDays + 1;

      return [
        leave.leaveType,
        DateFormat('yyyy-MM-dd').format(leave.startDate),
        DateFormat('yyyy-MM-dd').format(leave.endDate),
        days.toString(),
        leave.status,
      ];
    }).toList();

    // Add document pages
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Leave Report for User',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: headers,
                data: data,
                border: pw.TableBorder.all(width: 0.5),
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.teal),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
          );
        },
      ),
    );

    // Use Printing package to save/share the PDF
    await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'leave_report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf');
  }

  // --- WIDGET BUILDER ---

  @override
  Widget build(BuildContext context) {
    final reportVM = Provider.of<ReportViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Leave Reports"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          // PDF Download Button
          if (reportVM.reportResults.isNotEmpty && !reportVM.isLoading)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: () => _generatePdf(reportVM.reportResults),
              tooltip: 'Download PDF',
            ),
        ],
      ),
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    "Filter Leave Report",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Leave type dropdown
                  DropdownButtonFormField<String>(
                    value: selectedLeaveType,
                    hint: const Text("Select Leave Type"),
                    decoration: _inputDecoration("Leave Type"),
                    items: leaveTypes
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedLeaveType = val),
                  ),
                  const SizedBox(height: 12),

                  // Date range row (Start Date)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: startDate ??
                                  DateTime.now()
                                      .subtract(const Duration(days: 30)),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => startDate = picked);
                            }
                          },
                          icon: const Icon(Icons.date_range),
                          label: Text(
                            startDate == null
                                ? "Start Date"
                                : DateFormat('yyyy-MM-dd').format(startDate!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Date range row (End Date)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: endDate ?? DateTime.now(),
                              firstDate:
                                  startDate ?? DateTime(2020), // Enforce end date >= start date
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() => endDate = picked);
                            }
                          },
                          icon: const Icon(Icons.event),
                          label: Text(
                            endDate == null
                                ? "End Date"
                                : DateFormat('yyyy-MM-dd').format(endDate!),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Generate button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: reportVM.isLoading
                          ? null
                          : () {
                              // Fetch reports using the filters.
                              reportVM.fetchReports(
                                leaveType: selectedLeaveType,
                                startDate: startDate,
                                endDate: endDate,
                              );
                            },
                      child: Text(
                        reportVM.isLoading ? "Loading..." : "Generate Report",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Clear Filters Button (New addition for better UX)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        selectedLeaveType = null;
                        startDate = null;
                        endDate = null;
                      });
                      reportVM.fetchReports(); // Refetch all reports
                    },
                    child: const Text(
                      "Clear Filters",
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Results Display
            if (reportVM.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (reportVM.reportResults.isEmpty)
              const Text(
                  "No leave reports match the selected filters or were found for this user.")
            else
              // Implement Professional Table
              _buildReportTable(reportVM.reportResults),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTable(List<LeaveRequest> reports) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Allows horizontal scrolling
        child: DataTable(
          headingRowColor:
              MaterialStateColor.resolveWith((states) => Colors.teal.shade50),
          columns: const [
            DataColumn(
                label: Text('Type',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Start Date',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('End Date',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(
                label: Text('Days',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                numeric: true),
            DataColumn(
                label: Text('Status',
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: reports.map((leave) {
            final color = leave.status == "Approved"
                ? Colors.green
                : leave.status == "Rejected"
                    ? Colors.red
                    : Colors.orange;

            // Calculate days (inclusive)
            final days = (leave.endDate.difference(leave.startDate).inDays + 1);

            return DataRow(
              cells: [
                DataCell(Text(leave.leaveType)),
                DataCell(
                    Text(DateFormat('yyyy-MM-dd').format(leave.startDate))),
                DataCell(Text(DateFormat('yyyy-MM-dd').format(leave.endDate))),
                DataCell(Text(days.toString())),
                DataCell(
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      leave.status,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}