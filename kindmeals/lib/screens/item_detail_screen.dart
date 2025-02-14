import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'api_service.dart';

class ItemDetailScreen extends StatefulWidget {
  final Map<String, String> request;
  final Function(String) onDonationAccepted;

  const ItemDetailScreen({
    super.key,
    required this.request,
    required this.onDonationAccepted,
  });

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  Position? _currentPosition;
  bool _isLoading = true;
  bool _isDonorLoading = true;
  String? _errorMessage;
  Map<String, dynamic>? _donorProfile;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _fetchDonorProfile();
  }

  Future<void> _fetchDonorProfile() async {
    try {
      final donorEmail = widget.request['donorEmail'];
      if (donorEmail != null) {
        final profile = await ApiService.getDonorProfile(donorEmail);
        setState(() {
          _donorProfile = profile;
          _isDonorLoading = false;
        });
      } else {
        setState(() {
          _isDonorLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isDonorLoading = false;
        _errorMessage = 'Error fetching donor profile: $e';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Location services are disabled.';
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
          _errorMessage = 'Location permissions are permanently denied.';
        });
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error getting location: $e';
      });
    }
  }

  Future<void> _acceptDonation(bool needsVolunteer) async {
    try {
      final donationId = widget.request['id'];
      if (donationId != null) {
        await ApiService.acceptDonation(donationId, needsVolunteer);

        // Remove donation from live requests
        widget.onDonationAccepted(donationId);

        // if (mounted) {
        //   _showDonationAcceptedDialog();
        // }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting donation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openMap() async {
    if (_currentPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to get current location')),
      );
      return;
    }

    final donorLat = double.parse(widget.request['latitude']!);
    final donorLng = double.parse(widget.request['longitude']!);
    final currentLat = _currentPosition!.latitude;
    final currentLng = _currentPosition!.longitude;

    final url = 'https://www.google.com/maps/dir/?api=1'
        '&origin=$currentLat,$currentLng'
        '&destination=$donorLat,$donorLng'
        '&travelmode=driving';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open map')),
        );
      }
    }
  }

  void _showVolunteerConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want a volunteer?'),
          content:
              const Text('Would you like a volunteer to help with pickup?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
                _acceptDonation(false)
                    .then((_) => _showSelfPickupConfirmation());
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                _acceptDonation(true).then((_) => _searchForVolunteer());
              },
            ),
          ],
        );
      },
    );
  }

  void _searchForVolunteer() {
    // Simulate volunteer search with a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Searching for volunteers...'),
            ],
          ),
        );
      },
    );

    // Simulate volunteer search delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Close loading dialog
      _showNoVolunteerDialog();
    });
  }

  void _showNoVolunteerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Volunteers Available'),
          content: const Text(
              'No volunteers are currently available. Would you like to pick up the donation yourself?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Yes, I\'ll Pick Up'),
              onPressed: () {
                Navigator.pop(context);
                _showSelfPickupConfirmation();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSelfPickupConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Self-Pickup'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'You will need to pick up the donation from the donor\'s location.',
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text('View Route on Google Maps'),
                onPressed: () {
                  Navigator.pop(context);
                  _openMap();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Confirm Pickup'),
              onPressed: () {
                Navigator.pop(context);

                // Now show the final donation accepted dialog
                _showDonationAcceptedDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDonationAcceptedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('DONATION ACCEPTED SUCCESSFULLY'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Thank you for accepting this donation!',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('OK'),
              onPressed: () {
                final donationId = widget.request['id'];
                if (donationId != null) {
                  widget.onDonationAccepted(
                      donationId); // Remove only after confirmation
                }
                Navigator.of(context)
                  ..pop() // Close dialog
                  ..pop(); // Close item detail screen
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDonorInfo() {
    if (_isDonorLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_donorProfile == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Donor information not available'),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donor Information',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
                Icons.person, 'Name', _donorProfile!['name'] ?? 'N/A'),
            _buildInfoRow(Icons.business, 'Organization',
                _donorProfile!['organization'] ?? 'N/A'),
            _buildInfoRow(Icons.location_on, 'Location',
                _donorProfile!['location'] ?? 'N/A'),
            _buildInfoRow(Icons.info, 'About',
                _donorProfile!['about'] ?? 'Dedicated to making a difference.'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.request['image'] ??
                    'https://i.ytimg.com/vi/fx3mg1ow3HA/maxresdefault.jpg',
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 250,
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
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.request['foodName'] ?? 'N/A',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(Icons.scale, 'Quantity',
                          widget.request['quantity'] ?? 'N/A'),
                      _buildInfoRow(Icons.access_time, 'Expiry Date',
                          widget.request['expiryDateTime'] ?? 'N/A'),
                      _buildInfoRow(Icons.description, 'Description',
                          widget.request['description'] ?? 'N/A'),
                      _buildInfoRow(Icons.location_on, 'Location',
                          widget.request['location'] ?? 'N/A'),
                      _buildInfoRow(Icons.person, 'Donor Name',
                          widget.request['donorName'] ?? 'N/A'),
                    ]),
              ),
            ),
            const SizedBox(height: 16),
            _buildDonorInfo(),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _openMap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.directions),
                    label: Text(
                      _isLoading ? 'Getting Location...' : 'Check Location',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showVolunteerConfirmationDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.handshake),
                    label: const Text(
                      'Accept Donation',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
