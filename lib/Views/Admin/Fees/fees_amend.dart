import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nishas_yoga/Views/Admin/Fees/fees_amend_options.dart';
import 'package:nishas_yoga/Widget/Loading_Widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../Schema/FeesCollection.dart';

class FeesAmendPage extends StatefulWidget {
  const FeesAmendPage({super.key});

  @override
  _FeesAmendPageState createState() => _FeesAmendPageState();
}

class _FeesAmendPageState extends State<FeesAmendPage> {
  bool isLoading = true; // Initialize loading state as true
  List<FeesCollection> feesData = []; // Initialize as an empty list
  String? errorMessage;
  int mostRecentIndex = 0;

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

  // void updateApprovalStatus(FeesCollection feesCollection) async {
  //   final url = Uri.parse(
  //       'http://app.nishasyoga.com/FeesCollection.php'); // Change this to the URL of your PHP script
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final String ApprovalID = 1.toString();
  //     final String ClientID = feesCollection.clientID.toString();
  //     final Map<String, String> body = {
  //       'ApprovalID': ApprovalID,
  //       'ClientID': ClientID,
  //       'WannaUpdateNigga': 'Yes'
  //     };
  //     final response = await http.put(url, body: json.encode(body));
  //
  //     if (response.statusCode == 200) {
  //       print('Record updated successfully');
  //       // You can show a success message or perform any other actions here
  //     } else {
  //       print('Failed to update record. Error: ${response.body}');
  //       // Handle error scenario here
  //     }
  //   } catch (e) {
  //     print('Exception occurred: $e');
  //     // Handle exception scenario here
  //   }
  // }

  Future<void> fetchDataFromServer() async {
    final url = Uri.parse('https://app.nishasyoga.com/Fees.php');

    try {
      setState(() {
        isLoading = true;
      });
      final response = await http.get(url);
      print(response.body);

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        if (responseData is Map<String, dynamic> &&
            responseData.containsKey('message') &&
            responseData['message'] == 'No Fee Collections found') {
          // Handle case where no fee collections are found
        } else if (responseData is List<dynamic>) {
          // If fee collections are found, update the feesData list
          setState(() {
            feesData = responseData
                .map((data) => FeesCollection.fromJson(data))
                .toList();
            mostRecentIndex = 0; // Assuming the first entry is the most recent
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
    }
  }

  Future<void> _refreshData() async {
    // Implement your logic to refresh data here
    fetchDataFromServer();
  }

  String formatDate(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fees Amend Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? const LoadingWidget()
          : feesData.isEmpty
              ? Center(
                  child: Text(
                    errorMessage ?? 'No Fees is supposed to be collected',
                    style: const TextStyle(fontSize: 16),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: ListView.builder(
                    itemCount: feesData.length,
                    itemBuilder: (context, index) {
                      final isRecent = index == mostRecentIndex;
                      final isDuplicate = index < mostRecentIndex &&
                          feesData.indexWhere((item) =>
                                  item.clientID == feesData[index].clientID &&
                                  feesData.indexOf(item) < mostRecentIndex) !=
                              -1;

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 3,
                          child: ExpansionTile(
                            title: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                '${feesData[index].clientID} ${feesData[index].clientFirstName} ${feesData[index].clientLastName}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobile: ${feesData[index].clientMobile}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Fee Type: ${feesData[index].feesName}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isRecent || !isDuplicate
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                  if (feesData[index].coupleFirstName != null &&
                                      feesData[index].coupleLastName != null)
                                    Text(
                                      'Couple Name: ${feesData[index].coupleFirstName} ${feesData[index].coupleLastName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  if (feesData[index].promoCode != null)
                                    Text(
                                      'Promo Code: ${feesData[index].promoCode}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  Text(
                                    'Form of Payment: ${feesData[index].formName}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  if (feesData[index].passOnFirstName != null &&
                                      feesData[index].passOnLastName != null)
                                    Text(
                                      'Pass On Name: ${feesData[index].passOnFirstName} ${feesData[index].passOnLastName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  if (feesData[index].passOnApprovalFirstName !=
                                          null &&
                                      feesData[index].passOnApprovalLastName !=
                                          null)
                                    Text(
                                      'Pass On Approval Name: ${feesData[index].passOnApprovalFirstName} ${feesData[index].passOnApprovalLastName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  if (feesData[index].receivedByFirstName !=
                                          null &&
                                      feesData[index].receivedByLastName !=
                                          null)
                                    Text(
                                      'Received By Name: ${feesData[index].receivedByFirstName} ${feesData[index].receivedByLastName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  if (feesData[index].membershipChange != null)
                                    Text(
                                      'Membership Change: ${feesData[index].membershipChange}',
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
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: isRecent
                                          ? () {
                                              // Handle edit action
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      FeesAmendOptions(
                                                    feesData: feesData[index],
                                                  ),
                                                ),
                                              );
                                            }
                                          : null, // Disable if not recent
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: isRecent
                                          ? () {
                                              // Handle view action
                                            }
                                          : null, // Disable if not recent
                                      icon: const Icon(
                                        Icons.info,
                                        color: Colors.black,
                                      ),
                                    ),
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
    );
  }
//                 RefreshIndicator(
//                     onRefresh: _refreshData,
//                     child: ListView.builder(
//                       itemCount: feesData.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Card(
//                             elevation: 3,
//                               children: <Widget>[
//                                 Padding(
//                                   padding: const EdgeInsets.all(16.0),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.edit,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                       IconButton(
//                                         onPressed: () {},
//                                         icon: const Icon(
//                                           Icons.info,
//                                           color: Colors.black,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ));
//   }
// }
}
