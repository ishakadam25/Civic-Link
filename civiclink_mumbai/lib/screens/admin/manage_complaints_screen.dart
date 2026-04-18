import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageComplaintsScreen extends StatelessWidget {
  const ManageComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Complaints"),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('complaints')
            .orderBy('timestamp', descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No complaints"));
          }

          final complaints = snapshot.data!.docs;

          return ListView.builder(
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final doc = complaints[index];
              final data = doc;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      if (data['imageUrl'] != null)
                        Image.network(
                          data['imageUrl'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),

                      const SizedBox(height: 10),

                      Text(
                        data['description'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      Text("Area: ${data['area'] ?? 'N/A'}"),

                      const SizedBox(height: 10),

                      DropdownButton<String>(
                        value: data['status'] ?? 'Pending',
                        items: ['Pending', 'In Progress', 'Resolved']
                            .map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),

                        onChanged: (value) {
                          FirebaseFirestore.instance
                              .collection('complaints')
                              .doc(doc.id)
                              .update({'status': value});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}