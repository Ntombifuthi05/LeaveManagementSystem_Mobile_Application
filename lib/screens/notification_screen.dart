import 'package:flutter/material.dart';
import 'package:leavemanagementsystem/models/notification.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notification_viewmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    // ensure init called (if not already)
    Future.microtask(() =>
        Provider.of<NotificationViewModel>(context, listen: false).init());
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NotificationViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: vm.isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<AppNotification>>(
              stream: vm.streamNotifications(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final items = snapshot.data ?? [];
                if (items.isEmpty) {
                  return const Center(child: Text('No notifications yet.'));
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final n = items[index];
                    return Card(
                      color: n.isRead ? Colors.white : Colors.blue.shade50,
                      child: ListTile(
                        title: Text(n.title,
                            style: TextStyle(
                                fontWeight:
                                    n.isRead ? FontWeight.normal : FontWeight.bold)),
                        subtitle: Text(n.message),
                        trailing: Text(
                          n.status,
                          style: TextStyle(
                              color: n.status == 'Approved'
                                  ? Colors.green
                                  : n.status == 'Rejected'
                                      ? Colors.red
                                      : Colors.orange),
                        ),
                        onTap: () async {
                          if (!n.isRead) {
                            await vm.markAsRead(n.id);
                          }
                          // Optionally navigate to leave details screen:
                          // Navigator.pushNamed(context, '/leaveDetails', arguments: n.leaveRequestId);
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
