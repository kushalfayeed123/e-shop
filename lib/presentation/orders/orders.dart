import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header
            const Row(
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
            const SizedBox(height: 20),
            // Order Filters
            Row(
              children: [
                _buildFilterButton("All", true),
                _buildFilterButton("On Process", false),
                _buildFilterButton("Completed", false),
              ],
            ),
            const SizedBox(height: 20),
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
      padding: const EdgeInsets.only(right: 8.0),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:
              isActive ? const Color(0xFFFFD700) : const Color(0xFF333333),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        onPressed: () {},
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String name, String status, double total) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(status,
              style: const TextStyle(color: Color(0xFFFFD700), fontSize: 16)),
          const SizedBox(height: 8),
          Text("\$$total",
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        ],
      ),
    );
  }
}
