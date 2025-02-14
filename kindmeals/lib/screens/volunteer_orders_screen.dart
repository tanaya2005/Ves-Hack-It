import 'package:flutter/material.dart';
import 'package:kindmeals/screens/volunteer_orderDetail_screen.dart';

class VolunteerOrdersScreen extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<VolunteerOrdersScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, dynamic>> liveOrders = [];
  List<Map<String, dynamic>> previousOrders = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Sample data for demonstration
    liveOrders = [
      {
        'orderNo': '#11250',
        'status': 'Pickup Pending',
        'statusColor': Colors.orange,
      },
      {
        'orderNo': '#11252',
        'status': 'Pickup Rescheduled',
        'statusColor': Colors.blue,
      },
      {
        'orderNo': '#11253',
        'status': 'Delivery Pending',
        'statusColor': Colors.orange,
      },
    ];

    previousOrders = [
      {
        'orderNo': '#11251',
        'status': 'Pickup Failed',
        'statusColor': Colors.red,
      },
      {
        'orderNo': '#11251',
        'status': 'Delivery Failed',
        'statusColor': Colors.red,
      },
      {
        'orderNo': '#11253',
        'status': 'Delivered',
        'statusColor': Colors.green,
      },
      {
        'orderNo': '#11252',
        'status': 'Delivery Rescheduled',
        'statusColor': Colors.blue,
      },
    ];
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.green,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicator: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(25),
                ),
                tabs: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Live Orders'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text('Previous Orders'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Live Orders Tab
                  _buildOrdersList(liveOrders),

                  // Previous Orders Tab
                  _buildOrdersList(previousOrders),
                ],
              ),
            ),
          ],
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
                  Navigator.pushReplacementNamed(
                      context, '/volunteerOrdersPage');
                },
              ),
              _bottomNavButton(
                context,
                icon: Icons.person,
                label: "Account",
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, '/volunteerprofilescreen');
                },
              ),
            ],
          ),
        ));
  }

  Widget _bottomNavButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.green),
        label: Text(label, style: const TextStyle(color: Colors.green)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          side: const BorderSide(color: Colors.green),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OrderDetailPage(orderNo: order['orderNo']),
              ),
            );
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order No.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        order['orderNo'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: order['statusColor'].withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          order['status'],
                          style: TextStyle(
                            color: order['statusColor'],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty_orders.png', // You'll need to add this asset
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            'No Orders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'There are no orders to display',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
