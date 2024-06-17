import 'package:flutter/material.dart';

class OrderStatus {
  final String status;
  final DateTime dateTime;

  OrderStatus({required this.status, required this.dateTime});
}

class OrderStatusScreen extends StatelessWidget {
  final List<OrderStatus> orderStatuses = [
    OrderStatus(
        status: "Order Received",
        dateTime: DateTime.now().subtract(const Duration(days: 3))),
    OrderStatus(
        status: "Processing",
        dateTime: DateTime.now().subtract(const Duration(days: 2))),
    OrderStatus(
        status: "Shipped",
        dateTime: DateTime.now().subtract(const Duration(days: 1))),
    OrderStatus(status: "Out for Delivery", dateTime: DateTime.now()),
  ];

  OrderStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Status"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: orderStatuses.map((status) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(status.status),
                subtitle: Text('Date: ${status.dateTime.toLocal()}'),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
