import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:kindmeals/screens/item_detail_screen.dart';

class LiveDonationRequestsScreen extends StatefulWidget {
  const LiveDonationRequestsScreen({super.key});

  @override
  _LiveDonationRequestsScreenState createState() =>
      _LiveDonationRequestsScreenState();
}

class _LiveDonationRequestsScreenState
    extends State<LiveDonationRequestsScreen> {
  List<Map<String, dynamic>> _donationRequests = [];
  Position? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((_) {
      _fetchDonationRequests();
    });
  }

  Future<void> _fetchDonationRequests() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.0.100:3000/api/donations'), // Update with your server's IP
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _donationRequests = data.map((item) {
          return {
            'foodName': item['foodName'] ?? 'Unknown Food',
            'quantity': '${item['quantity'] ?? 0} kg',
            'expirationDate': item['expirationDate'] ?? 'Unknown',
            'image': item['imageUrl'] != null
                ? 'http://192.168.0.100:3000${item['imageUrl']}' // Construct the full image URL
                : '',
            'location': item['location'] ?? '',
            'donorName': item['donorName'] ?? '',
            'donorVerification': item['donorVerification'] ?? 'Unverified',
            'latitude': item['latitude']?.toString() ?? '0.0',
            'longitude': item['longitude']?.toString() ?? '0.0',
          };
        }).toList();
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load donations: ${response.statusCode}';
      });
    }
  } catch (e) {
    setState(() {
      _errorMessage = 'Error fetching donations: $e';
    });
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
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
          _errorMessage =
              'Location permissions are permanently denied. Please enable them from settings.';
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
  }

  double _calculateDistance(
      double startLat, double startLon, double endLat, double endLon) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }

  void _viewItem(Map<String, dynamic> request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(
            request:
                request.map((key, value) => MapEntry(key, value.toString()))),
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
                _fetchDonationRequests();
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
                    await _fetchDonationRequests();
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                Text(
                                    'Expiration Date: ${request['expirationDate']}'),
                                const SizedBox(height: 16),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () => _viewItem(request),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      minimumSize:
                                          const Size(double.infinity, 60),
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
