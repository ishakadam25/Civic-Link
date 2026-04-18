import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageComplaintsScreen extends StatefulWidget {
  const ManageComplaintsScreen({super.key});

  @override
  State<ManageComplaintsScreen> createState() => _ManageComplaintsScreenState();
}

class _ManageComplaintsScreenState extends State<ManageComplaintsScreen> {
  String selectedArea = "All";
  DateTime? selectedDate;

  final List<String> areas = ["All", "Dadar", "Andheri", "Bandra", "Kurla"];

  Query _getFilteredQuery() {
    Query query = FirebaseFirestore.instance.collection('complaints');
    if (selectedArea != "All") {
      query = query.where('area', isEqualTo: selectedArea);
    }
    if (selectedDate != null) {
      // Assuming 'date' is stored as Timestamp in Firestore
      final start = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
      );

      final end = start.add(const Duration(days: 1));

      query = query
          .where('timestamp', isGreaterThanOrEqualTo: start)
          .where('timestamp', isLessThan: end);
      // Note: For exact date filtering, you may need to adjust based on your Firestore schema
    }
    return query.orderBy('timestamp', descending: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Complaints")),
      body: Column(
        children: [
          // 🔽 FILTER UI
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedArea,
                  items: areas.map((area) {
                    return DropdownMenuItem<String>(
                      value: area,
                      child: Text(area),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedArea = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null) {
                      setState(() {
                        selectedDate = picked;
                      });
                    }
                  },
                  child: const Text("Select Date"),
                ),
              ],
            ),
          ),
          // 🔥 FILTERED COMPLAINTS LIST
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getFilteredQuery().snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("No complaints found"));
                }
                final complaints = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: complaints.length,
                  itemBuilder: (context, index) {
                    final data =
                        complaints[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text(data['title'] ?? 'No title'),
                        subtitle: Text(data['description'] ?? 'No description'),
                        // Add more fields like date, status, etc., as needed
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
