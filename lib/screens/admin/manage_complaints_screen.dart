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
  String searchQuery = "";

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
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search complaints...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
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
                final allComplaints = snapshot.data!.docs;
                
                // Filter by search query
                final filteredComplaints = allComplaints.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final title = (data['title'] ?? '').toString().toLowerCase();
                  final description = (data['description'] ?? '').toString().toLowerCase();
                  return title.contains(searchQuery) || description.contains(searchQuery);
                }).toList();

                if (filteredComplaints.isEmpty) {
                  return const Center(child: Text("No complaints found"));
                }

                return ListView.builder(
                  itemCount: filteredComplaints.length,
                  itemBuilder: (context, index) {
                    final data = filteredComplaints[index].data() as Map<String, dynamic>;

                    print("Selected Area: $selectedArea");
                    print("Firestore Area: ${data['area']}");

                    print(data['imageUrl']);
                    return Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data['imageUrl'] != null)
                            Image.network(
                              data['imageUrl'],
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                          ListTile(
                            title: Text(
                              data['title'] ?? 'No title',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['description'] ?? 'No description'),
                                Text("Area: ${data['area'] ?? ''}"),
                              ],
                            ),
                          ),
                        ],
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
