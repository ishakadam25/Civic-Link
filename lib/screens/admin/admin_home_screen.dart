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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddAnnouncementScreen(),
                  ),
                );
              },
              child: const Text("Add Announcement"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ManageComplaintsScreen(),
                  ),
                );
              },
              child: const Text("Manage Complaints"),
            ),
          ],
        ),
      ),
    );
  }
}
