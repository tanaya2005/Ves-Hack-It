import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class NGO {
  final String name;
  final String description;
  final String address;
  final double distance;
  final String category;
  final String contact;

  NGO({
    required this.name,
    required this.description,
    required this.address,
    required this.distance,
    required this.category,
    required this.contact,
  });
}

class NearbyNGOsScreen extends StatefulWidget {
  const NearbyNGOsScreen({super.key});

  @override
  State<NearbyNGOsScreen> createState() => _NearbyNGOsScreenState();
}

class _NearbyNGOsScreenState extends State<NearbyNGOsScreen> {
  bool _isLoading = true;
  String _error = '';
  List<NGO> _ngos = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Education',
    'Healthcare',
    'Environment',
    'Social Welfare',
    'Animal Welfare'
  ];

  @override
  void initState() {
    super.initState();
    _loadNearbyNGOs();
  }

  Future<void> _loadNearbyNGOs() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition();

      // TODO: Replace with actual API call to fetch NGOs
      // Simulated API response
      await Future.delayed(const Duration(seconds: 2));
      _ngos = [
        NGO(
          name: 'Education For All',
          description: 'Providing quality education to underprivileged children',
          address: '123 Main St, City',
          distance: 1.2,
          category: 'Education',
          contact: '+1234567890',
        ),
        NGO(
          name: 'Green Earth Initiative',
          description: 'Working towards environmental conservation',
          address: '456 Park Ave, City',
          distance: 2.5,
          category: 'Environment',
          contact: '+1234567891',
        ),
        // Add more sample NGOs here
      ];

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error loading NGOs: ${e.toString()}';
      });
    }
  }

  List<NGO> _getFilteredNGOs() {
    return _ngos.where((ngo) {
      bool matchesSearch = ngo.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          ngo.description.toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchesCategory = _selectedCategory == 'All' || ngo.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby NGOs'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search NGOs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              items: _categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text(_error, style: const TextStyle(color: Colors.red)))
                    : _buildNGOList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadNearbyNGOs,
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildNGOList() {
    final filteredNGOs = _getFilteredNGOs();
    
    if (filteredNGOs.isEmpty) {
      return const Center(child: Text('No NGOs found'));
    }

    return ListView.builder(
      itemCount: filteredNGOs.length,
      itemBuilder: (context, index) {
        final ngo = filteredNGOs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              ngo.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(ngo.description),
                const SizedBox(height: 4),
                Text(
                  'Address: ${ngo.address}',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Distance: ${ngo.distance.toStringAsFixed(1)} km',
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'Category: ${ngo.category}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // TODO: Implement phone call functionality
                // You can use url_launcher package to make phone calls
              },
            ),
            onTap: () {
              // TODO: Navigate to NGO detail screen
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}