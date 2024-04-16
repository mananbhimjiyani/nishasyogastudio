import 'package:flutter/material.dart';
import 'package:nishas_yoga/Views/Admin/Fees/fees_amend.dart';
import 'package:nishas_yoga/Views/Admin/Fees/fees_approval.dart';

import 'fees_remaineder.dart';

class FeesPage extends StatefulWidget {
  const FeesPage({super.key});

  @override
  _FeesPageState createState() => _FeesPageState();
}

class _FeesPageState extends State<FeesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          style: TextStyle(color: Colors.white),
          'Options',
        ),
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Text(
              '₹', // Rupee symbol
              style: TextStyle(fontSize: 24.0),
            ),
            title: const Text('Fees Collection'),
            onTap: () {
              // Handle onTap for Fees Collection
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                  const FeesRemainderPage(), // Replace InquiryViewPage with your actual page
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Fees Approval'),
            onTap: () {
              // Handle onTap for Fees Approval
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FeesApprovalPage(), // Replace InquiryViewPage with your actual page
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Amends'),
            onTap: () {
              // Handle onTap for Amends
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const FeesAmendPage(), // Replace InquiryViewPage with your actual page
                ),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Reports'),
            onTap: () {
              // Handle onTap for Reports
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('User Rights'),
            onTap: () {
              // Handle onTap for User Rights
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
