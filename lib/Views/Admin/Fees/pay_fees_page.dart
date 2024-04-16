import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nishas_yoga/Widget/Loading_Widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Schema/FOP.dart';
import '../../../Schema/FeesCollection.dart';
import '../../../Schema/User.dart';
import '../../../Schema/FeeType.dart';

class PayFeesPage extends StatefulWidget {
  final User user;

  const PayFeesPage({Key? key, required this.user}) : super(key: key);

  @override
  _PayFeesPageState createState() => _PayFeesPageState();
}

class _PayFeesPageState extends State<PayFeesPage> {
  bool isLoading = true; // Initialize loading state as true
  List<User> userData = []; // Initialize as an empty list
  List<FeeType> feeTypeData = []; // Initialize as an empty list
  List<Fop> FOPData = []; // Initialize as an empty list
  String? errorMessage;
  List<User> searchedUsers = [];
  TextEditingController searchController = TextEditingController();
  TextEditingController searchNameController = TextEditingController();
  FeeType? selectedFeeType;
  User? selectedUser;
  Fop? selectedFOP;
  DateTime selectedDate = DateTime.now();
  late DateTime NewDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _showErrorDialog(dynamic error) {
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

  Future<void> _collectPayment() async {
    try {
      // Show loading indicator if needed
      setState(() {
        isLoading = true;
      });
      // Create an instance of FeesCollection and populate its fields
      final feesCollection = FeesCollection(
        clientID: widget.user.clientId.toString(),
        feeTypeID: selectedFeeType!.feeTypeId.toString(),
        cDate: selectedDate.toIso8601String(),
        coupleID: selectedUser?.clientId.toString(),
        promoCode: null.toString(),
        form: selectedFOP!.formId.toString(),
        passOnID: null.toString(),
        passOnApprovalID: null.toString(),
        receivedByID: null.toString(),
        membershipChange: null.toString(),
        changeDate: null.toString(),
        newDate: NewDate.toIso8601String(),
        approvalID: null.toString(),
        view: '1', // Assuming View is of type String
      );

      // Convert FeesCollection instance to JSON format
      final Map<String, dynamic> formData = feesCollection.toJson();

      // Print the body before making the request
      print(formData);

      // Make the HTTP request to submit payment
      final response = await http.post(
        Uri.parse('https://app.nishasyoga.com/FeesCollection.php'),
        body: formData,
      );

      // Check the status code of the response
      if (response.statusCode == 200) {
        // Request was successful, show success dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Payment submitted successfully.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.of(context).pop(); // Navigate back one page
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        print("Data submitted successfully");
        print("Response body: ${response.body}");
      } else {
        // Request failed with an error status code, show error dialog
        _showErrorDialog(
            'Failed to submit payment. Status code: ${response.statusCode}');
        print("Failed to submit payment. Status code: ${response.statusCode}");
      }
    } catch (error) {
      // Show error dialog if request fails
      _showErrorDialog(error);
      print("Error occurred during HTTP request: $error");
    } finally {
      // Hide loading indicator
      setState(() {
        isLoading = false;
      });
    }
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

  Future<void> fetchFeesDataFromServer() async {
    final url = Uri.parse('https://app.nishasyoga.com/feesType.php');

    try {
      setState(() {
        isLoading = true;
      });
      print('Fetching data from server...'); // Debug statement
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List<dynamic>) {
          // If fee types are found, update the feeTypeData list
          setState(() {
            feeTypeData =
                responseData.map((data) => FeeType.fromJson(data)).toList();
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
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Fetch operation complete.'); // Debug statement
    }
  }

  Future<void> fetchFOPFromServer() async {
    final url = Uri.parse('https://app.nishasyoga.com/fop.php');

    try {
      setState(() {
        isLoading = true;
      });
      print('Fetching data from server...'); // Debug statement
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is List<dynamic>) {
          // If fee types are found, update the feeTypeData list
          setState(() {
            FOPData = responseData.map((data) => Fop.fromJson(data)).toList();
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
    } finally {
      setState(() {
        isLoading = false;
      });
      print('Fetch operation complete.'); // Debug statement
    }
  }

  Future<void> _refreshData() async {
    // Implement your logic to refresh data here
    fetchClientDataFromServer();
  }

  Widget _buildCoupleFeeDropdown() {
    if (selectedFeeType != null &&
        (selectedFeeType!.feeTypeId == "5" ||
            selectedFeeType!.feeTypeId == "6")) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Your Couple"),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedUser == null)
                  TextField(
                    controller: searchNameController,
                    onChanged: (value) {
                      setState(() {
                        // Update filtered list based on search query
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                    ),
                  ),
                if (searchNameController.text.isNotEmpty)
                  SizedBox(
                    height: 200, // Adjust the height as needed
                    child: ListView(
                      children: userData
                          .where((user) =>
                              user.clientId != widget.user.clientId &&
                              (searchNameController.text.isEmpty ||
                                  '${user.firstName} ${user.lastName}'
                                      .toLowerCase()
                                      .contains(searchNameController.text
                                          .toLowerCase())))
                          .map((user) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedUser = user; // Update selected user
                              searchNameController.clear();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              '${user.clientId} ${user.firstName} ${user.lastName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                if (selectedUser !=
                    null) // Render selected user if it's not null
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedUser = null; // Clear selected user
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Selected User: ${selectedUser!.clientId} ${selectedUser!.firstName} ${selectedUser!.lastName}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const SizedBox
          .shrink(); // Return an empty SizedBox if not applicable
    }
  }

  String _addDaysToDate(DateTime date, FeeType feesType) {
    // Add the specified number of days to the input date
    DateTime newDate = date.add(Duration(days: int.parse(feesType.days)));
    // Format the new date in the "dd-MMM-yyyy" format
    setState(() {
      NewDate = newDate;
    });
    return DateFormat('dd-MMM-yyyy').format(newDate);
  }

  void _filterUsers(String query) {
    setState(() {
      searchedUsers = userData.where((user) {
        // Filter the user list based on the search query
        String clientId = user.clientId.toString();
        String mobile = user.mobile.toString();
        return user.firstName.toLowerCase().contains(query.toLowerCase()) ||
            user.lastName.toLowerCase().contains(query.toLowerCase()) ||
            clientId.toLowerCase().contains(query.toLowerCase()) ||
            mobile.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchClientDataFromServer();
    fetchFeesDataFromServer();
    fetchFOPFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "User Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? const LoadingWidget() // Display loading widget if data is still loading
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildInfoRow(
                        icon: Icons.person,
                        label: 'Client ID',
                        value: widget.user.clientId.toString(),
                      ),
                      _buildInfoRow(
                        icon: Icons.person,
                        label: 'First Name',
                        value: widget.user.firstName,
                      ),
                      _buildInfoRow(
                        icon: Icons.person,
                        label: 'Last Name',
                        value: widget.user.lastName,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _selectDate(context),
                            icon: const Icon(Icons.calendar_today),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => _selectDate(context),
                            child: Text(
                              'Collection Date: ${DateFormat('dd-MMM-yyyy').format(selectedDate)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text("Select Fee Type"),
                      Container(
                        width: double.infinity,
                        // Make the dropdown button occupy full width
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          // Add border decoration
                          borderRadius:
                              BorderRadius.circular(8), // Add border radius
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        // Add horizontal padding
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        // Add vertical margin
                        child: DropdownButton<FeeType>(
                          value: selectedFeeType, // Change the value type here
                          onChanged: (newValue) {
                            if (mounted) {
                              setState(() {
                                selectedFeeType = newValue;
                                selectedFOP = null;
                                selectedUser = null;
                              });
                            }
                          },
                          items: feeTypeData.map((feeType) {
                            return DropdownMenuItem<FeeType>(
                              // Update DropdownMenuItem type
                              value: feeType,
                              child: Text(feeType.feesName),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _buildCoupleFeeDropdown(),
                      Text(
                        "Net Payable: ${selectedFeeType != null ? selectedFeeType!.amount : '0'}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Text("Select Payment Type"),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButton<Fop>(
                          value: selectedFOP,
                          onChanged: (newValue) {
                            if (mounted) {
                              setState(() {
                                selectedFOP = newValue;
                              });
                            }
                          },
                          items: FOPData.where((fop) =>
                              (selectedFeeType?.feesName == 'Free Members' &&
                                  fop.formName == 'FOC') ||
                              (selectedFeeType?.feesName != 'Free Members' &&
                                  fop.view == '1' &&
                                  fop.formName != 'FOC')).map((fop) {
                            return DropdownMenuItem<Fop>(
                              value: fop,
                              child: Text(fop.formName),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        children: [
                          selectedDate != null && selectedFeeType != null
                              ? Text(
                                  "Next Payment Date: ${_addDaysToDate(selectedDate, selectedFeeType!)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                )
                              : const Text("Next Payment Date: Not available"),
                          // Other widgets...
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                _collectPayment();
                              },
                              child: const Text(
                                "Collect Payment",
                                style: TextStyle(color: Colors.white),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInfoRow(
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.black54,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $value',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
