import 'package:flutter/material.dart';

class SparePartsScreen extends StatefulWidget {
  const SparePartsScreen({super.key});

  @override
  State<SparePartsScreen> createState() => _SparePartsScreenState();
}

class _SparePartsScreenState extends State<SparePartsScreen> {
  final List<Map<String, String>> allParts = [
    {
      'name': 'Membrane Housing Set',
      'price': '220',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Pre-Filter (Spun Filter/Candle)',
      'price': '250',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Carbon Filter',
      'price': '400',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Sediment Filter',
      'price': '400',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'RO Membrane 80 GPD',
      'price': '1650',
      'image': 'assets/images/image1.png',
    },
    {'name': 'UF Filter', 'price': '200', 'image': 'assets/images/image1.png'},
    {
      'name': 'TDS Adjuster',
      'price': '80',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Pump (Booster Pump) 100 GPD',
      'price': '1850',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Solenoid Valve (SV)',
      'price': '480',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Float Valve Set',
      'price': '225',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'SMPS Power Supply 24V',
      'price': '950',
      'image': 'assets/images/image1.png',
    },
    {'name': 'UV Light', 'price': '100', 'image': 'assets/images/image1.png'},
    {
      'name': 'Water Tap/Toti',
      'price': '50',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Pipes (Per Meter)',
      'price': '20 Rs/Meter',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Fittings (Elbow, T, Connectors)',
      'price': '20',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'RO Cabinet',
      'price': '1500',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Copper Filter',
      'price': '550',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Antiscalant Balls',
      'price': '100',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'Auto Cut Switch',
      'price': '80',
      'image': 'assets/images/image1.png',
    },
    {
      'name': 'RO Service (Charges)',
      'price': '300',
      'image': 'assets/images/image1.png',
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredParts = allParts.where((part) {
      final nameMatch = part['name']!.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      final priceMatch = part['price']!.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      return nameMatch || priceMatch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Spare Parts & Services',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search parts or price...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: filteredParts.length,
              itemBuilder: (context, index) {
                final part = filteredParts[index];
                return GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${part['name']} selected')),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Image.asset(
                              part['image']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                part['name']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "₹${part['price']}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
