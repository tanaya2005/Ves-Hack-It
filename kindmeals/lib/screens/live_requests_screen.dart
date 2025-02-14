import 'dart:async';
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
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getCurrentLocation();
    await _fetchDonationRequests();

    // Set up periodic refresh every minute
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        _fetchDonationRequests();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  String _getReadableDistance(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} m';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} km';
    }
  }

  String _getLocationDisplay(
      Map<String, dynamic> request, double? calculatedDistance) {
    String display = request['location'] ?? 'Location not specified';
    if (calculatedDistance != null &&
        double.tryParse(request['latitude'] ?? '') != null &&
        double.tryParse(request['longitude'] ?? '') != null) {
      display += ' • ${_getReadableDistance(calculatedDistance)}';
    }
    return display;
  }

  Future<void> _fetchDonationRequests() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.7.180:3000/api/donations'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _donationRequests = data.map((item) {
            return {
              'id': item['_id'] ?? '',
              'foodName': item['foodName'] ?? 'Unknown Food',
              'quantity': '${item['quantity'] ?? 0} ',
              'expiryDateTime': item['expiryDateTime'] ?? 'Unknown',
              'description': item['description'] ?? 'No description provided',
              'image': item['imageUrl'] != null
                  ? 'http://192.168.7.180:3000${item['imageUrl']}'
                  : '',
              'location': item['location'] ?? '',
              'donorName': item['donorName'] ?? '',
              'donorVerification': item['donorVerification'] ?? 'Unverified',
              'latitude': item['latitude']?.toString() ?? '0.0',
              'longitude': item['longitude']?.toString() ?? '0.0',
              'status': item['status'] ?? 'available',
              'acceptedBy': item['acceptedBy'],
              'needsVolunteer': item['needsVolunteer'] ?? false,
            };
          }).toList();
          _sortByDistance();
        });
      } else {
        setState(() {
          _errorMessage =
              'Failed to load donations: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e, stackTrace) {
      print('Error fetching donations: $e\n$stackTrace');
      setState(() {
        _errorMessage = 'Error fetching donations: ${e.toString()}';
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
    } catch (e, stackTrace) {
      print('Error getting location: $e\n$stackTrace');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: ${e.toString()}';
      });
    }
  }

  void _sortByDistance() {
    if (_currentPosition != null) {
      _donationRequests.sort((a, b) {
        double distanceA = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          double.tryParse(a['latitude'] ?? '0.0') ?? 0.0,
          double.tryParse(a['longitude'] ?? '0.0') ?? 0.0,
        );
        double distanceB = _calculateDistance(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          double.tryParse(b['latitude'] ?? '0.0') ?? 0.0,
          double.tryParse(b['longitude'] ?? '0.0') ?? 0.0,
        );
        return distanceA.compareTo(distanceB);
      });
    }
  }

  double _calculateDistance(
      double startLat, double startLon, double endLat, double endLon) {
    return Geolocator.distanceBetween(startLat, startLon, endLat, endLon);
  }

  List<Map<String, dynamic>> get _availableDonations {
    return _donationRequests
        .where((request) => request['status'] == 'available')
        .toList();
  }

  Future<void> _handleDonationAccepted(String donationId) async {
    try {
      // Remove the donation from the local list
      setState(() {
        _donationRequests.removeWhere((request) => request['id'] == donationId);
      });

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Donation successfully accepted!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh the list to get updated data
      await _fetchDonationRequests();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _viewItem(Map<String, dynamic> request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(
          request: Map<String, String>.from(request.map(
            (key, value) => MapEntry(key, value.toString()),
          )),
          onDonationAccepted: _handleDonationAccepted,
        ),
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
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                _getCurrentLocation();
                _fetchDonationRequests();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationCard(Map<String, dynamic> request, double? distance) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 16),
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
            Text(
              request['foodName']!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Quantity: ${request['quantity']}'),
            const SizedBox(height: 8),
            Text('Expiry Date: ${request['expiryDateTime']}'),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _getLocationDisplay(request, distance),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Donor: ${request['donorName']}'),
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
                  child: _availableDonations.isEmpty
                      ? const Center(
                          child: Text(
                            'No available donations at the moment',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: _availableDonations.map((request) {
                              double? distance = _currentPosition != null
                                  ? _calculateDistance(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                      double.tryParse(
                                              request['latitude'] ?? '0.0') ??
                                          0.0,
                                      double.tryParse(
                                              request['longitude'] ?? '0.0') ??
                                          0.0,
                                    )
                                  : null;
                              return _buildDonationCard(request, distance);
                            }).toList(),
                          ),
                        ),
                ),
    );
  }
}
