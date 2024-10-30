import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
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
                  "Dashboard",
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
            // Info Cards
            Row(
              children: [
                _buildInfoCard(
                    "New Orders", "16", Color(0xFF1E1E1E), Color(0xFFB3B3B3)),
                _buildInfoCard(
                    "Total Orders", "86", Color(0xFF1E1E1E), Color(0xFFB3B3B3)),
                _buildInfoCard(
                    "Waiting List", "9", Color(0xFF1E1E1E), Color(0xFFB3B3B3)),
              ],
            ),
            SizedBox(height: 20),
            // Order List and Payment sections
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildOrderList(),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildPopularDishesSection(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      String title, String value, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Order List",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          // Add more widgets to build the order list
        ],
      ),
    );
  }

  Widget _buildPopularDishesSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            "Popular Dishes",
            style: TextStyle(color: Color(0xFFFFD700), fontSize: 20),
          ),
          // Add widgets for popular dishes
        ],
      ),
    );
  }
}
