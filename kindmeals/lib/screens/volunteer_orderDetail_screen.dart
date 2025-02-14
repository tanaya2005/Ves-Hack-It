import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher.dart';

class OrderDetailPage extends StatelessWidget {
  final String orderNo;

  const OrderDetailPage({Key? key, required this.orderNo}) : super(key: key);

  // Function to open Google Maps with the given address
  Future<void> _openMapsWithAddress(String address) async {
    // In a real app, you might want to geocode the address to get coordinates
    // For now, we'll just encode the address for the URL
    final encodedAddress = Uri.encodeComponent(address);
    final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    
    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      print('Could not launch $mapsUrl');
    }
  }

  Widget _bottomNavButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.green),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This is mock data - in a real app, you'd fetch this based on the orderNo
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, color: Colors.black87),
            SizedBox(width: 8),
            Text('Orders', style: TextStyle(color: Colors.black87)),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Tab selector (Live Orders/Previous Orders)
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Live Orders', style: TextStyle(color: Colors.grey)),
                  Row(
                    children: [
                      Text('24/08/2023', style: TextStyle(color: Colors.grey)),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.grey, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Order No.',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 14)),
                          Text(orderNo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Pickup Pending',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Volunteer Information
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        child: Icon(Icons.person, color: Colors.green),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('John Doe',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('Volunteer',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Colors.green.withOpacity(0.1),
                        child: Icon(Icons.phone, color: Colors.green, size: 18),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Pickup Center 1
                  _buildPickupLocation(
                    title: 'Pickup Center-1',
                    location:
                        'Green Food Bank, 201/B, Green Apts, Greenville 400069',
                    items: [
                      {'name': 'Rice', 'quantity': '5kg', 'qty': 2},
                    ],
                  ),

                  SizedBox(height: 16),

                  // Pickup Center 2
                  _buildPickupLocation(
                    title: 'Pickup Center-2',
                    location:
                        'Community Kitchen, 204/C, Apts, Greenville 400069',
                    items: [
                      {'name': 'Bread', 'quantity': '500g', 'qty': 3},
                    ],
                  ),

                  SizedBox(height: 16),

                  // Delivery Location
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.green),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Delivery',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(
                              '201/D, Ananta Apts, Near Jai Bhavan, Greenville 400069',
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward, color: Colors.green),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Payment Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.monetization_on_outlined,
                              color: Colors.grey),
                          SizedBox(width: 8),
                          Text('₹ 0',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 18),
                          SizedBox(width: 4),
                          Text('Donation',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Delivery Timing
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Pickup By',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Tomorrow\n5:30 PM, Thu, 25/08/2023',
                          style: TextStyle(
                              color: Colors.red[700],
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Timer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.timer, color: Colors.red, size: 18),
                            SizedBox(width: 4),
                            Text(
                              'TIME LEFT\n1:04 Hrs',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Update Status
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Text('Update Status'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey[300]!),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: PopupMenuButton(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Select an option'),
                                Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                          itemBuilder: (context) => [
                            PopupMenuItem(child: Text('Accept Order')),
                            PopupMenuItem(child: Text('Reject Order')),
                            PopupMenuItem(child: Text('Request Reschedule')),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Confirm Pickup Button
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Confirm Pickup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Order number at bottom
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order No.',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 14)),
                      Text(orderNo,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Pickup Pending',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomNavButton(
              context,
              icon: Icons.list,
              label: "Orders",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/volunteerOrdersPage');
              },
            ),
            _bottomNavButton(
              context,
              icon: Icons.person,
              label: "Account",
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/volunteerprofilescreen');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupLocation(
      {required String title,
      required String location,
      required List<Map<String, dynamic>> items}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.store, color: Colors.green),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(
                location,
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
              SizedBox(height: 12),
              ...items
                  .map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              item['name'],
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 8),
                            Text(
                              item['quantity'],
                              style: TextStyle(color: Colors.grey),
                            ),
                            Spacer(),
                            Text(
                              'Qty: ${item['qty']}',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
        SizedBox(width: 8),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.phone, color: Colors.green, size: 18),
            ),
            SizedBox(width: 8),
              GestureDetector(
                onTap: () => _openMapsWithAddress(location),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward, color: Colors.green, size: 18),
                )
            ),
          ],
        ),
      ],
    );
  }
}
