import 'package:flutter/material.dart';
import 'dart:async';

class TrackDeliveryScreen extends StatefulWidget {
  const TrackDeliveryScreen({super.key});

  @override
  State<TrackDeliveryScreen> createState() => _TrackDeliveryScreenState();
}

class _TrackDeliveryScreenState extends State<TrackDeliveryScreen> {
  bool _isLoading = true;
  String _deliveryStatus = 'In Progress';
  String _estimatedTime = '25 mins';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupDeliverySimulation();
    // Simulate initial loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _setupDeliverySimulation() {
    // Simulate delivery progress updates
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      
      setState(() {
        _deliveryStatus = _getRandomStatus();
        // Update estimated time
        int currentMinutes = int.parse(_estimatedTime.split(' ')[0]);
        if (currentMinutes > 5) {
          _estimatedTime = '${currentMinutes - 1} mins';
        }
        // Update progress
        if (_progress < 1.0) {
          _progress += 0.05;
        }
      });
    });
  }

  String _getRandomStatus() {
    List<String> statuses = [
      'Picked up',
      'In transit',
      'Near destination',
      'Arriving soon',
    ];
    return statuses[DateTime.now().second % statuses.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Delivery'),
        backgroundColor: Colors.green,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildStatusCard(),
                Expanded(
                  child: Stack(
                    children: [
                      _buildCustomMap(),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: _buildDeliveryInfoCard(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCustomMap() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pickup Location',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '123 Main Street, City',
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Location',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            '456 Park Avenue, City',
                            style: TextStyle(
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDeliverySteps(),
        ],
      ),
    );
  }

  Widget _buildDeliverySteps() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStep('Order Confirmed', true),
          _buildStep('Picked up', _progress > 0.25),
          _buildStep('In Transit', _progress > 0.5),
          _buildStep('Near Destination', _progress > 0.75),
          _buildStep('Delivered', _progress >= 1.0),
        ],
      ),
    );
  }

  Widget _buildStep(String title, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: completed ? Colors.black : Colors.grey,
              fontWeight: completed ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.delivery_dining, size: 40, color: Colors.green),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status: $_deliveryStatus',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Estimated arrival in $_estimatedTime',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.grey),
                  radius: 20,
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Delivery Partner',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildActionButton(
                  icon: Icons.phone,
                  label: 'Call',
                  onPressed: () {
                    // Implement call functionality
                  },
                ),
                _buildActionButton(
                  icon: Icons.message,
                  label: 'Message',
                  onPressed: () {
                    // Implement message functionality
                  },
                ),
                _buildActionButton(
                  icon: Icons.help_outline,
                  label: 'Help',
                  onPressed: () {
                    // Implement help functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}