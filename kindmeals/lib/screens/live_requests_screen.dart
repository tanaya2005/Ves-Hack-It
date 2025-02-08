import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kindmeals/screens/item_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveDonationRequestsScreen extends StatefulWidget {
  const LiveDonationRequestsScreen({super.key});

  @override
  _LiveDonationRequestsScreenState createState() =>
      _LiveDonationRequestsScreenState();
}

class _LiveDonationRequestsScreenState extends State<LiveDonationRequestsScreen> {
  final List<Map<String, String>> _donationRequests = [
    {
      'foodName': 'Vegetables',
      'quantity': '5 kg',
      'expirationDate': '10/02/2025 18:00',
      'description': 'Fresh vegetables for donation',
      'image': 'https://i.ytimg.com/vi/fx3mg1ow3HA/maxresdefault.jpg',
      'location': 'New York, USA',
      'donorName': 'John Doe',
      'donorVerification': 'Verified',
      'latitude': '40.7128',
      'longitude': '-74.0060',
    },
    {
      'foodName': 'Fruits',
      'quantity': '3 kg',
      'expirationDate': '10/02/2025 19:00',
      'description': 'Fresh fruits for donation',
      'image': 'https://example.com/fruits.jpg',
      'location': 'Los Angeles, USA',
      'donorName': 'Jane Smith',
      'donorVerification': 'Unverified',
      'latitude': '34.0522',
      'longitude': '-118.2437',
    },
  ];

  Position? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse && permission != LocationPermission.always) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _sortByDistance();
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
      setState(() {
        _isLoading = false;
      });
    }
  }

  double _calculateDistance(double startLat, double startLon, double endLat, double endLon) {
    double distance = Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
    return distance; // Returns the distance in meters
  }

  void _viewItem(Map<String, String> request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(request: request),
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
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            request['image']!,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Food Name: ${request['foodName']}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.green, size: 18),
                                  Text(
                                    '${distance.toStringAsFixed(0)} m away',
                                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Quantity: ${request['quantity']}'),
                          const SizedBox(height: 8),
                          Text('Expiration Date: ${request['expirationDate']}'),
                          const SizedBox(height: 8),
                          Text('Description: ${request['description']}'),
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
    );
  }
}