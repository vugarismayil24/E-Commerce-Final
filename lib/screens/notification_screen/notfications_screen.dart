import 'package:e_com_app/screens/home_screen/home_screen.dart';
import 'package:e_com_app/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';

class NotificationItem {
  final String text;
  final String date;
  final Color color;

  NotificationItem(
      {required this.text, required this.date, required this.color});
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<NotificationItem> notifications = [
    NotificationItem(
        text:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
        date: "Lun, 03/04/2023",
        color: Colors.redAccent),
    NotificationItem(
        text:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
        date: "Lun, 03/04/2022",
        color: Colors.greenAccent),
    NotificationItem(
        text:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
        date: "Lun, 03/04/2025",
        color: Colors.yellowAccent),
    NotificationItem(
        text:
            "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
        date: "Lun, 03/04/2022",
        color: Colors.blueAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BottomNavigationBarWidget()));
            // Geri düğmesine basıldığında yapılacaklar
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                notifications.clear();
              });
            },
            child: Text(
              'Supprime tous',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification dismissed'),
                ),
              );
            },
            background: Container(color: Colors.red),
            child: NotificationCard(
              notification: notifications[index],
            ),
          );
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: notification.color,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.text,
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            Text(
              notification.date,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
