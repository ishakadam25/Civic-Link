import 'package:flutter/material.dart';
import 'raise_complaint_screen.dart';
import 'my_complaints_screen.dart';
import 'announcements_screen.dart';
import '../admin/admin_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CivicLink Mumbai"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,

          children: [
            _buildCard(
              context,
              title: "Raise Complaint",
              icon: Icons.report_problem,
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RaiseComplaintScreen(),
                  ),
                );
              },
            ),

            _buildCard(
              context,
              title: "My Complaints",
              icon: Icons.list,
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyComplaintsScreen()),
                );
              },
            ),

            _buildCard(
              context,
              title: "Announcements",
              icon: Icons.campaign,
              color: Colors.orange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnnouncementsScreen(),
                  ),
                );
              },
            ),

            _buildCard(
              context,
              title: "Bills",
              icon: Icons.payment,
              color: Colors.green,
              onTap: () {},
            ),

            _buildCard(
              context,
              title: "Travel",
              icon: Icons.train,
              color: Colors.purple,
              onTap: () {},
            ),

            _buildCard(
              context,
              title: "Admin Panel",
              icon: Icons.admin_panel_settings,
              color: Colors.black,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminHomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),

      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
