import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Orders",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Wednesday, 12 July 2023",
                  style: TextStyle(color: Color(0xFFB3B3B3), fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Order Filters
            Row(
              children: [
                _buildFilterButton("All", true),
                _buildFilterButton("On Process", false),
                _buildFilterButton("Completed", false),
              ],
            ),
            SizedBox(height: 20),
            // Order Cards
            Expanded(
              child: ListView(
                children: [
                  _buildOrderCard("Ariel Hikmat", "Ready", 87.34),
                  _buildOrderCard("Denis Freeman", "In Progress", 57.87),
                  // Add more orders as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isActive) {
    return Padding(
      padding: EdgeInsets.only(right: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Color(0xFFFFD700) : Color(0xFF333333),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: () {},
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String name, String status, double total) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(status,
              style: TextStyle(color: Color(0xFFFFD700), fontSize: 16)),
          SizedBox(height: 8),
          Text("\$$total", style: TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }
}
