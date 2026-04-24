import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TouristPlaceScreen extends StatefulWidget {
  const TouristPlaceScreen({super.key});

  @override
  State<TouristPlaceScreen> createState() => _TouristPlaceScreenState();
}

class _TouristPlaceScreenState extends State<TouristPlaceScreen> {
  String selectedArea = "All";
  String searchQuery = "";

  final List<String> areas = ["All", "Colaba", "Bandra", "Juhu", "Dadar", "Andheri", "Kurla"];

  final List<Map<String, String>> touristPlaces = [
    {
      "name": "Gateway of India",
      "area": "Colaba",
      "image": "https://live.staticflickr.com/7229/7060979299_c58c20e52c_b.jpg",
      "location": "https://maps.google.com/?q=Gateway+of+India"
    },
    {
      "name": "Bandra Bandstand",
      "area": "Bandra",
      "image": "https://staticimg.publishstory.co/thumb/67782453.cms?imgsize=1448328&width=616&resizemode=4",
      "location": "https://maps.google.com/?q=Bandra+Bandstand"
    },
    {
      "name": "Juhu Beach",
      "area": "Juhu",
      "image": "https://www.theleela.com/prod/content/assets/2023-08/Marine-Drive-beach.jpg?VersionId=LJl9Q3uxds2gwzSYe697ZVqbL_JVVFYb",
      "location": "https://maps.google.com/?q=Juhu+Beach"
    },
  ];

  Future<void> openMap(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter places based on selected area and search query
    final filteredPlaces = touristPlaces.where((place) {
      final matchesArea = selectedArea == "All" || place['area'] == selectedArea;
      final matchesSearch = searchQuery.isEmpty ||
          place['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
          place['area']!.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesArea && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Tourist Places")),
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
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search tourist places...",
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
          // 🔥 FILTERED TOURIST PLACES LIST
          Expanded(
            child: filteredPlaces.isEmpty
                ? const Center(child: Text("No tourist places found"))
                : ListView.builder(
                    itemCount: filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = filteredPlaces[index];

                      return GestureDetector(
                        onTap: () {
                          openMap(place['location']!);
                        },
                        child: Card(
                          margin: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                place['image']!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              ListTile(
                                title: Text(place['name']!),
                                subtitle: Text("Area: ${place['area']}"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}