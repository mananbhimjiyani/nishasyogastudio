import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nishas_yoga/Schema/FeesCollection.dart';
import 'package:http/http.dart' as http;

class FeesAmendOptions extends StatefulWidget {
  final FeesCollection feesData;

  const FeesAmendOptions({required this.feesData, super.key});

  @override
  _FeesAmendOptionsState createState() => _FeesAmendOptionsState();
}

class _FeesAmendOptionsState extends State<FeesAmendOptions> {
  late DateTime
      _selectedDate; // Define a DateTime variable to store the selected date

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.tryParse(widget.feesData.newDate!) ?? DateTime.now(); // Initialize selectedDate with the feesData.newDate or current date
  }

  Future<void> _showExtendDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Extend'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Current Renewal Date: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    _formatDate(DateTime.parse(widget.feesData.newDate!)),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: _selectedDate,
                              lastDate: DateTime(DateTime.now().year + 5),
                            );
                            if (picked != null && picked != _selectedDate) {
                              setState(() {
                                _selectedDate =
                                    picked; // Update the selected date
                              });
                            }
                          },
                          child: Row(
                            children: [
                              Text(
                                'Select New Date',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                ),
                              ),
                              const Icon(Icons.calendar_today),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'New Date: ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    _formatDate(_selectedDate),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateFeesCollection();
              },
              child: const Text('Okay'),
            ),
          ],
        );
      },
    );
  }

  // Method to send PUT request to update fees collection
  Future<void> _updateFeesCollection() async {
    final url = Uri.parse(
        'https://app.nishasyoga.com/extend_fees_collection.php'); // Replace with your API endpoint
    final Map<String, dynamic> body = {
      'newDate': _formatDate(_selectedDate),
      'FeeCollectionID': widget.feesData.feeCollectionID,
      'ChangeDate': DateTime.now().toIso8601String(),
      // Add other parameters as needed
    };

    try {
      final response = await http.put(url, body: json.encode(body));
      if (response.statusCode == 200) {
        // PUT request successful
        print('Fees collection updated successfully');
      } else {
        // Error handling
        print(
            'Failed to update fees collection. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Exception handling
      print('Error updating fees collection: $error');
    }
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return '${date.year}-${date.month}-${date.day}';
    } else {
      return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fees Amend Options',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Extend'),
            onTap: () {
              // Handle onTap for Fees Collection
              _showExtendDialog(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.forward),
            title: const Text('Pass On'),
            onTap: () {
              // Handle onTap for Fees Approval
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.pause),
            title: const Text('Pause'),
            onTap: () {
              // Handle onTap for Amends
            },
          ),
        ],
      ),
      // ElevatedButton(
      //   onPressed: () {},
      //   child: const Text(
      //     'Extend Date',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
      // ElevatedButton(
      //   onPressed: () {},
      //   child:
      //   const Text('Pass On', style: TextStyle(color: Colors.white)),
      // ),
      // ElevatedButton(
      //   onPressed: () {},
      //   child: const Text('Pause Membership',
      //       style: TextStyle(color: Colors.white)),
      // ),
    );
  }
}
