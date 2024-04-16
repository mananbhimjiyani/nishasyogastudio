import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nishas_yoga/Widget/Loading_Widget.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Schema/Inquiry.dart';
import '../../Schema/BatchType.dart';
import '../../Schema/Studio.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../Schema/Batch.dart';

class InquiryView extends StatefulWidget {
  const InquiryView({super.key});

  @override
  _InquiryViewState createState() => _InquiryViewState();
}

class _InquiryViewState extends State<InquiryView> {
  final TextEditingController firstNameController = TextEditingController();
  List<Inquiry> inquiries = [];
  List<Batch> batches = [];
  List<Studio> studios = [];
  List<BatchType> batchTypes = [];
  Batch? selectedBatch;
  BatchType? selectedBatchType;
  Studio? selectedStudio;
  DateTime? selectedDate;
  bool _isLoading = false;
  int _expandedTileIndex = -1;
  bool isInternetConnected = false;

  Future<DateTime?> _selectDate(
      BuildContext context, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    return picked;
  }

  Future<void> submitDemo(
      Inquiry inquiry,
      DateTime selectedDate,
      int selectedBatchID,
      int selectedBatchTypeID,
      int selectedStudioID) async {
    try {
      // Show loading indicator
      setState(() {
        _isLoading = true;
      });
      setState(() {
        selectedBatchID = int.tryParse(inquiry.BatchID)!;
        selectedStudioID = int.tryParse(inquiry.StudioID)!;
        selectedBatchTypeID == int.tryParse(inquiry.BTypeID)!;
      });
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'InquiryID': inquiry.InquiryID,
        'Date': selectedDate.toIso8601String(),
        'BatchID': selectedBatchID,
        'BTypeID': selectedBatchTypeID,
        'StudioID': selectedStudioID,
      };

      print(requestBody);

      // Send POST request to the server
      final response = await http.post(
        Uri.parse('https://app.nishasyoga.com/demo.php'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response JSON if needed

        // Show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demo submitted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Handle the error response
        throw Exception('Failed to submit demo: ${response.reasonPhrase}');
      }
    } catch (error) {
      // Handle the error
      print('Error submitting demo: $error');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit demo. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Hide the loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to fetch inquiries from the server
  Future<void> fetchInquiries() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://app.nishasyoga.com/Inquiry.php'),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['inquiries'];
        setState(() {
          // Convert each JSON object in the 'inquiries' array to an Inquiry object
          inquiries = data.map((json) => Inquiry.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to fetch inquiries');
      }
    } catch (error) {
      print('Error fetching inquiries: $error');
      // Handle error (e.g., show error message to user)
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchStudios() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response =
          await http.get(Uri.parse('https://app.nishasyoga.com/studio.php'));

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          studios = data.map((studio) {
            return Studio(
              StudioID: studio['StudioID'],
              StudioName: studio['StudioName'],
              Location: studio['Location'],
            );
          }).toList();
        });
      } else {
        // Handle error response
        // For example, you can show an error message
        // _showErrorDialog('Failed to fetch studio details: ${response.reasonPhrase}');
      }
    } catch (error) {
      setState(() {
        isInternetConnected = false;
      });
      // Handle exception
      // For example, you can show an error message
      // _showErrorDialog('Error fetching studio details: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchBatchType() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response =
          await http.get(Uri.parse('https://app.nishasyoga.com/batchType.php'));
      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          batchTypes = data.map((batchType) {
            return BatchType(
              BTypeID: batchType['BTypeID'],
              BName: batchType['BName'],
              Desc: batchType['Desc'],
              BatchID: batchType['BatchID'],
              StudioID: batchType['StudioID'],
              View: batchType['View'],
              stamp: batchType['stamp'],
            );
          }).toList();
        });
      } else {}
    } catch (error) {
      print(error);
      setState(() {
        isInternetConnected = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> fetchBatches() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response =
          await http.get(Uri.parse('https://app.nishasyoga.com/batches.php'));

      print(response.body);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          batches = data.map((batch) {
            return Batch(
              BatchID: batch['BatchID'],
              CompanyID: batch['CompanyID'],
              BatchStartTime: batch['BatchStartTime'],
              BatchEndTime: batch['BatchEndTime'],
              workingDays: batch['WorkingDays'],
              view: batch['View'],
              timeStamp: batch['TimeStamp'],
            );
          }).toList();
        });
      } else {}
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("There is and error fetching batches."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now(); // Initialize selectedDate with current date
    fetchBatches();
    fetchBatchType();
    fetchStudios();
    fetchInquiries(); // Fetch inquiries when the widget is initialized
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inquiries',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : RefreshIndicator(
              onRefresh: () async {
                await fetchInquiries();
              },
              child: ListView.builder(
                itemCount: inquiries.length,
                itemBuilder: (context, index) {
                  final inquiry = inquiries[index];
                  return Column(
                    children: [
                      if (index == 0 ||
                          !isSameDay(inquiry.TimeStamp,
                              inquiries[index - 1].TimeStamp))
                        Padding(
                          padding: const EdgeInsets.fromLTRB(200.0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.yMMMMEEEEd()
                                    .format(inquiry.TimeStamp!),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      Card(
                        color: null,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        child: ExpansionTile(
                          // Set initiallyExpanded to check if this tile's index matches the _expandedTileIndex
                          initiallyExpanded: _expandedTileIndex == index,
                          // Use a callback to update _expandedTileIndex when the tile is tapped
                          onExpansionChanged: (isExpanded) {
                            setState(() {
                              _expandedTileIndex = isExpanded ? index : -1;
                            });
                          },
                          title: Row(
                            children: [
                              Text('${inquiry.firstName} ${inquiry.lastName}'),
                            ],
                          ),
                          subtitle: Text(inquiry.mobileNumber),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Age:  ${inquiry.age}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Gender:   ${inquiry.selectedGender}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Reason:   ${inquiry.reason}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Practicing Yoga:   ${inquiry.practicingYoga}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Pain:  ${inquiry.pain.join(", ")}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Illness:   ${inquiry.illness.join(", ")}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Yoga Duration:   ${inquiry.yogaDuration}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Yoga Left Duration:  ${inquiry.yogaLeftDuration}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Profession: ${inquiry.profession}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Reference:   ${inquiry.reference}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Interested Batch: ${inquiry.BatchStartTime} - ${inquiry.BatchEndTime}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Interested Batch: ${inquiry.BName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      'Interested Studio:   ${inquiry.StudioName}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 10),
                                    // Add some spacing before the button
                                    // Call button
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.call),
                                          onPressed: () {
                                            FlutterPhoneDirectCaller.callNumber(
                                                inquiry.mobileNumber);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.message_outlined),
                                          onPressed: () {
                                            _launchWhatsApp(inquiry);
                                          },
                                        ),
                                        Visibility(
                                          visible: inquiry.Contacted == "0",
                                          // Show IconButton if Contacted is "0"
                                          child: IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              _showAlertDialog(
                                                  context, inquiry);
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ], // Replace with your desired trailing widget
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  void _showAlertDialog(BuildContext context, Inquiry inquiry) async {
    String selectedDateString =
        DateFormat('EEE, dd MMM yyyy').format(selectedDate!);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Demo Registration'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // TextButton(
                      //   onPressed: () async {
                      //     final DateTime? newDate =
                      //         await _selectDate(context, selectedDate);
                      //     setState(() {
                      //       // Update the selected date
                      //       selectedDate = newDate ?? selectedDate;
                      //     });
                      //   },
                      //   child: Text(
                      //     selectedDate != null
                      //         ? 'Date: ${DateFormat.yMMMd().format(selectedDate!)}'
                      //         : 'Date',
                      //     style: const TextStyle(fontSize: 20),
                      //   ),
                      // ),
                      Text(
                        selectedDateString, // Display selected date here
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        onPressed: () async {
                          final DateTime? newDate =
                              await _selectDate(context, selectedDate);
                          setState(() {
                            // Update the selected date and the displayed text
                            selectedDate = newDate ?? selectedDate;
                            selectedDateString = DateFormat('EEE, dd MMM yyyy')
                                .format(selectedDate!);
                          });
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                  DropdownButtonFormField<int>(
                    value: int.tryParse(inquiry.StudioID),
                    // Set the selected value to the batchID
                    decoration: const InputDecoration(
                      labelText: 'Studios',
                      border: OutlineInputBorder(),
                    ),
                    items: studios.map<DropdownMenuItem<int>>((Studio studio) {
                      return DropdownMenuItem<int>(
                        value: studio.StudioID,
                        child: Row(
                          children: [
                            Text(studio.StudioName),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStudio = studios.firstWhere(
                              (studio) => studio.StudioID == newValue);
                          print('Selected Studio: ${selectedStudio?.StudioID}');
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  // Dropdown for studio details
                  DropdownButtonFormField<int>(
                    value: int.tryParse(inquiry.BTypeID),
                    // Set the selected value to the batchID
                    decoration: const InputDecoration(
                      labelText: 'Batch Type',
                      border: OutlineInputBorder(),
                    ),
                    // items: batchTypes
                    //     .where((batchType) =>
                    // selectedStudio != null &&
                    //     batchType.StudioID != null &&
                    //     batchType.StudioID.split(',').contains(selectedStudio!
                    //         .StudioID
                    //         .toString())) // Check if selectedStudio's ID is in the list of StudioIDs
                    //     .map<DropdownMenuItem<int>>((BatchType batchType) {
                    items: batchTypes
                        .where((batchType) =>
                            selectedStudio ==
                                null || // Include all batch types when selectedStudio is null
                            (batchType.StudioID != null &&
                                batchType.StudioID.split(',').contains(
                                    selectedStudio!.StudioID
                                        .toString()))) // Check if selectedStudio's ID is in the list of StudioIDs
                        .map<DropdownMenuItem<int>>((BatchType batchType) {
                      return DropdownMenuItem<int>(
                        value: batchType.BTypeID,
                        child: Row(
                          children: [
                            Text(batchType.BName),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedBatchType = batchTypes.firstWhere(
                              (batchType) => batchType.BTypeID == newValue);
                          print(
                              'Selected BatchType: ${selectedBatchType?.BTypeID}');
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  // Dropdown for batch details
                  DropdownButtonFormField<int>(
                    value: int.tryParse(inquiry.BatchID),
                    decoration: const InputDecoration(
                      labelText: 'Batch Timings',
                      border: OutlineInputBorder(),
                    ),
                    // items: batches
                    //     .where((batch) =>
                    // selectedBatchType != null &&
                    //     batch.BatchID != null &&
                    //     selectedBatchType!.BatchID.split(',').contains(batch
                    //         .BatchID
                    //         .toString())) // Check if BatchID is in the list of BatchIDs
                    //     .map<DropdownMenuItem<int>>((Batch batch) {
                    items: batches
                        .where((batch) =>
                            selectedBatchType ==
                                null || // Include all batches when selectedBatchType is null
                            (batch.BatchID != null &&
                                selectedBatchType!.BatchID.split(',').contains(
                                    batch.BatchID
                                        .toString()))) // Check if BatchID is in the list of BatchIDs
                        .map<DropdownMenuItem<int>>((Batch batch) {
                      return DropdownMenuItem<int>(
                        value: batch.BatchID,
                        child: Row(
                          children: [
                            Text(
                                '${batch.BatchStartTime} - ${batch.BatchEndTime}'),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedBatch = batches
                              .firstWhere((batch) => batch.BatchID == newValue);
                          print('Selected Batch Object: $selectedBatch');
                          print('Selected Batch: ${selectedBatch?.BatchID}');
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Assign the selected values directly
                    selectedBatch ??= batches.firstWhere((batch) =>
                        batch.BatchID == int.tryParse(inquiry.BatchID));
                    selectedBatchType ??= batchTypes.firstWhere((batchType) =>
                        batchType.BTypeID == int.tryParse(inquiry.BTypeID));
                    selectedStudio ??= studios.firstWhere((studio) =>
                        studio.StudioID == int.tryParse(inquiry.StudioID));
                    submitDemo(inquiry, selectedDate!, selectedBatch!.BatchID,
                        selectedBatchType!.BTypeID, selectedStudio!.StudioID);
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> requestPermissions() async {
    // Request phone call permission
    PermissionStatus phoneCallStatus = await Permission.phone
        .request(); // Change to Permission.contacts for contacts permission
    // Handle the result of permission request
    if (phoneCallStatus != PermissionStatus.granted) {
      // Permission not granted, show a message or handle it accordingly
      print('Phone call permission not granted.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone call permission is required to make calls.'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  bool isSameDay(DateTime? dateTime1, DateTime? dateTime2) {
    if (dateTime1 == null || dateTime2 == null) return false;
    return dateTime1.year == dateTime2.year &&
        dateTime1.month == dateTime2.month &&
        dateTime1.day == dateTime2.day;
  }

  void _launchWhatsApp(Inquiry inquiry) async {
    // Construct the message with the inquiry details
    String message = 'Hello, Yogi,\n\n';
    message += 'Thank you for reaching out to us with your inquiry!\n\n\n';
    message +=
        'Our location on Google Maps: [Google Maps](https://maps.app.goo.gl/BaWJ94mU3ShS1p7u8)\n';
    message +=
        'Follow us on Instagram: [Instagram](https://instagram.com/nishasyogastudio)\n';
    message +=
        'Follow us on Facebook: [Facebook](https://www.facebook.com/nishasyogastudio)\n';
    message +=
        'Follow us on Linkedin: [Linkedin](https://in.linkedin.com/company/nishasyogastudio)\n';
    message +=
        'Subscribe to our YouTube channel: [YouTube](https://www.youtube.com/nishasyogastudio)\n\n\n';
    message += ' Below you will find the details you provided:\n\n';
    message += 'Name: ${inquiry.firstName} ${inquiry.lastName}\n';
    message += 'Age: ${inquiry.age}\n';
    message += 'Gender: ${inquiry.selectedGender}\n';
    message += 'Reason for Inquiry: ${inquiry.reason}\n';
    message += 'Do you currently practice Yoga? ${inquiry.practicingYoga}\n';
    message += 'Pain Areas: ${inquiry.pain.join(", ")}\n';
    message += 'Illnesses: ${inquiry.illness.join(", ")}\n';
    message += 'Years Practicing Yoga: ${inquiry.yogaDuration}\n';
    message += 'Time you have left in Yoga: ${inquiry.yogaLeftDuration}\n';
    message += 'Profession: ${inquiry.profession}\n';
    message += 'How did you hear about us? ${inquiry.reference}\n\n';
    message += 'Based on your preferences, we recommend the following:\n\n';
    message +=
        'Preferred Batch Timings: ${inquiry.BatchStartTime} - ${inquiry.BatchEndTime}\n';
    message += 'Preferred Batch Type: ${inquiry.BName}\n';
    message += 'Preferred Studio: ${inquiry.StudioName}\n\n\n';
    message += 'We look forward to welcoming you to our Yoga community!\n';

    // Construct the WhatsApp chat URL
    final Uri url = Uri.parse(
        'https://wa.me/${inquiry.mobileNumber}/?text=${Uri.encodeFull(message)}');

    // Launch the URL
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

void main() {
  runApp(const MaterialApp(
    home: InquiryView(),
  ));
}
