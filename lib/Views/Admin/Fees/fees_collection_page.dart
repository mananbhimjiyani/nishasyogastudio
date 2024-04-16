import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nishas_yoga/Views/Admin/Fees/pay_fees_page.dart';
import 'package:nishas_yoga/Widget/Loading_Widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Schema/User.dart';

class FeesCollectionPage extends StatefulWidget {
  const FeesCollectionPage({super.key});

  @override
  _FeesCollectionPageState createState() => _FeesCollectionPageState();
}

class _FeesCollectionPageState extends State<FeesCollectionPage> {
  bool isLoading = true; // Initialize loading state as true
  List<User> userData = []; // Initialize as an empty list
  String? errorMessage;
  List<User> searchedUsers = [];
  TextEditingController searchController = TextEditingController();

  void _showErrorDialog(dynamic error) {
    print('Caught error type: ${error.runtimeType}');
    String errorMessage = 'An error occurred. Please try again.';

    if (error is String) {
      // Check if the error message indicates no fee collections found
      if (error.contains('No Fee Collections found')) {
        errorMessage = 'No Fees is supposed to be collected';
      } else {
        errorMessage = error;
      }
    } else if (error is FormatException) {
      errorMessage = 'Invalid data format. Please check your input.';
    } else if (error is TimeoutException) {
      errorMessage = 'Request timed out. Please try again later.';
    } else if (error is SocketException) {
      errorMessage = 'Network error. Please check your internet connection.';
    } else if (error is http.ClientException) {
      errorMessage = 'HTTP client error. Please try again.';
    } else if (error is http.Response) {
      // Handle HTTP response errors
      errorMessage = 'Failed to load data. Status code: ${error.statusCode}';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchClientDataFromServer() async {
    final url = Uri.parse('https://app.nishasyoga.com/register.php');

    try {
      setState(() {
        isLoading = true;
      });
      print('Fetching data from server...'); // Debug statement
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message') &&
            responseData['message'] == 'No User found') {
          // Handle case where no users are found
          print('No users found.'); // Debug statement
        } else if (responseData['success'] == true) {
          // If users are found, update the userData list
          final List<dynamic> userDataList = responseData['data'];
          setState(() {
            userData =
                userDataList.map((data) => _parseUserData(data)).toList();
          });
        } else {
          // Handle unexpected response format
          _showErrorDialog('Unexpected response format');
        }
      } else {
        // Handle HTTP errors
        _showErrorDialog(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors
      _showErrorDialog('Error fetching data: $error');
      print(error);
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Fetch operation complete.'); // Debug statement
    }
  }

  User _parseUserData(dynamic data) {
    try {
      return User.fromJson(data);
    } catch (error) {
      // Check if the error is of type String
      if (error is String) {
        // Handle string errors (e.g., invalid JSON format)
        print('Error parsing JSON: $error');
      } else {
        // Extract the problematic key causing the error
        final key = _extractProblematicKey(data);
        print('Error parsing JSON. Key causing the error: $key');
      }
      // Return null instead of an empty string
      rethrow;
    }
  }

  String _extractProblematicKey(dynamic data) {
    // Iterate through each key in the data
    for (final key in data.keys) {
      try {
        // Try parsing the value corresponding to the key
        final value = data[key];
        // Attempt to create a User object from the value
        User.fromJson(value);
      } catch (error) {
        // If parsing fails, return the key causing the error
        print('Error parsing JSON. Key causing the error: $key');
        return key;
      }
    }
    // If no problematic key is found, return an empty string
    return '';
  }

  Future<void> _refreshData() async {
    // Implement your logic to refresh data here
    fetchClientDataFromServer();
  }

  void _filterUsers(String query) {
    setState(() {
      searchedUsers = userData.where((user) {
        // Filter the user list based on the search query
        String ClientId = user.clientId.toString();
        String Mobile = user.mobile.toString();
        return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase()) ||
            ClientId.toLowerCase().contains(query.toLowerCase()) ||
            Mobile.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _collectFees(BuildContext context, int index) {
    // Get the selected user
    User selectedUser = searchedUsers[index];

    // Navigate to PayFeesPage and pass the selected user's details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayFeesPage(
          user: selectedUser,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchClientDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Fees Collection",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: isLoading
                ? const LoadingWidget()
                : searchedUsers.isEmpty
                    ? Center(
                        child: Text(
                          errorMessage ?? 'Type in the text box',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refreshData,
                        child: ListView.builder(
                          itemCount: searchedUsers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 3,
                                child: ExpansionTile(
                                  title: ListTile(
                                    contentPadding: const EdgeInsets.all(16),
                                    title: Text(
                                      '${searchedUsers[index].clientId} ${searchedUsers[index].firstName} ${searchedUsers[index].lastName}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Mobile: ${searchedUsers[index].mobile}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              _collectFees(context, index);
                                            },
                                            child: const Text(
                                              "Collect Fees",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
