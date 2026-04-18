import 'package:flutter/material.dart';
import 'add_announcement_screen.dart';
import 'manage_complaints_screen.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            _buildAdminCard("Announcements", Icons.campaign, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddAnnouncementScreen(),
                ),
              );
            }),

            const SizedBox(height: 20),

            _buildAdminCard("Manage Complaints", Icons.report, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ManageComplaintsScreen(),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: Icon(icon, size: 30),
          title: Text(title, style: const TextStyle(fontSize: 18)),
          trailing: const Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
