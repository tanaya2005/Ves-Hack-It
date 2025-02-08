// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kindmeals/screens/item_detail_screen.dart';

class LiveDonationRequestsScreen extends StatefulWidget {
  const LiveDonationRequestsScreen({super.key});

  @override
  _LiveDonationRequestsScreenState createState() =>
      _LiveDonationRequestsScreenState();
}

class _LiveDonationRequestsScreenState extends State<LiveDonationRequestsScreen> {
  final List<Map<String, String>> _donationRequests = [
    {
      'foodName': 'Rice',
      'quantity': '5 kg',
      'expirationDate': '10/02/2025 18:00',
      'image': 'https://www.mississippivegan.com/wp-content/uploads/2021/12/easy-baked-rice-02-1170x1463.jpg',
      'location': 'Thane, Mumbai, India',
      'donorName': 'Tanaya Jain',
      'donorVerification': 'Verified',
      'latitude': '19.223326',
      'longitude': '72.976114',
    },
    {
      'foodName': 'Lentils (Dal)',
      'quantity': '3 kg',
      'expirationDate': '10/02/2025 19:00',
      'image': 'https://example.com/lentils.jpg',
      'location': 'Mumbai, India',
      'donorName': 'Priya Sharma',
      'donorVerification': 'Unverified',
      'latitude': '19.0760',
      'longitude': '72.8777',
    },
    {
      'foodName': 'Chapati (Flatbread)',
      'quantity': '20 pieces',
      'expirationDate': '10/02/2025 20:00',
      'image': 'https://example.com/chapati.jpg',
      'location': 'Kolkata, India',
      'donorName': 'Anil Gupta',
      'donorVerification': 'Verified',
      'latitude': '22.5726',
      'longitude': '88.3639',
    },
    {
      'foodName': 'Curd (Yogurt)',
      'quantity': '2 liters',
      'expirationDate': '10/02/2025 21:00',
      'image': 'https://example.com/curd.jpg',
      'location': 'Chennai, India',
      'donorName': 'Ravi Singh',
      'donorVerification': 'Unverified',
      'latitude': '13.0827',
      'longitude': '80.2707',
    },
  ];

  Position? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location services are disabled. Please enable them.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Location permissions are denied.';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location permissions are permanently denied. Please enable them from settings.';
        });
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _sortByDistance();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: $e';
      });
    }
  }

  void _sortByDistance() {
    if (_currentPosition != null) {
      _donationRequests.sort((a, b) {
        double distanceA = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          double.parse(a['latitude']!),
          double.parse(a['longitude']!),
        );
        double distanceB = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          double.parse(b['latitude']!),
          double.parse(b['longitude']!),
        );
        return distanceA.compareTo(distanceB);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  double _calculateDistance(double startLat, double startLon, double endLat, double endLon) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }

  void _viewItem(Map<String, String> request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(request: request),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'An error occurred',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _getCurrentLocation();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Donation Requests'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            )
          : _errorMessage != null
              ? _buildErrorWidget()
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isLoading = true;
                      _errorMessage = null;
                    });
                    await _getCurrentLocation();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: _donationRequests.map((request) {
                        double distance = _currentPosition != null
                            ? _calculateDistance(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                                double.parse(request['latitude']!),
                                double.parse(request['longitude']!),
                              )
                            : 0.0;

                        return Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    request['image']!,
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        request['foodName']!,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        Text(
                                          '${(distance / 1000).toStringAsFixed(1)} km',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text('Quantity: ${request['quantity']}'),
                                const SizedBox(height: 8),
                                Text('Expiration Date: ${request['expirationDate']}'),
                                const SizedBox(height: 16),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () => _viewItem(request),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize: const Size(double.infinity, 60),
                                    ),
                                    child: const Text(
                                      'View Item',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}