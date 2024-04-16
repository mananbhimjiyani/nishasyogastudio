import 'package:flutter/material.dart';
import 'package:nishas_yoga/Views/Admin/scheduling.dart';

import '../Views/Admin/Fees/fees_page.dart';
import '../Views/login_page.dart';
import '../Views/Admin/inquiry_view.dart';

import '../Schema/User.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ClientNavBar extends StatefulWidget {
  final User user;

  // Constructor to receive the user information
  const ClientNavBar({Key? key, required this.user}) : super(key: key);

  @override
  _ClientNavBarState createState() => _ClientNavBarState();
}

class _ClientNavBarState extends State<ClientNavBar> {
  late Future<int> feesCount;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName:
                Text("${widget.user.firstName} ${widget.user.lastName}"),
            accountEmail: Text(widget.user.emailId),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  widget.user.profileUrl,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.brown,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg',
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Text(
              '₹', // Rupee symbol
              style: TextStyle(fontSize: 24.0),
            ),
            title: const Text('Fees'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FeesPage(), // Replace FeesPage with your actual page
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.help, // Changed from Icons.question_mark
              color: Colors.black,
            ),
            title: const Text('Inquiry'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const InquiryView(), // Replace InquiryView with your actual page
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.event_available),
            title: const Text('Attendance'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.spa),
            title: const Text('Asana'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.spa_outlined),
            title: const Text('Meditation'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.spa),
            title: const Text('Pranayama'),
            onTap: () {},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Reports'),
            onTap: () {},
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Scheduling'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const Scheduling(), // Replace Scheduling with your actual page
                ),
              );
            },
          ),

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              // Implement logout logic here
              Navigator.of(context).pop(); // Close the drawer
              _logout(); // Call logout function
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('authenticated'); // Remove authentication flag
      await prefs.remove('user'); // Remove user data
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(), // Navigate to login page
        ),
      );
    } catch (e) {
      // Handle error gracefully, for example:
      print('Error occurred during logout: $e');
    }
  }
}
