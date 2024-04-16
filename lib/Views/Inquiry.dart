import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../Widget/Loading_Widget.dart';

import '../Schema/Inquiry.dart';
import '../Schema/Batch.dart';
import '../Schema/BatchType.dart';
import '../Schema/Studio.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../Widget/internet_check.dart';

class InquiryPage extends StatefulWidget {
  const InquiryPage({super.key});

  @override
  _InquiryPageState createState() => _InquiryPageState();
}

class _InquiryPageState extends State<InquiryPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController yogaDurationController = TextEditingController();
  final TextEditingController yogaLeftDurationController =
      TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController referenceController = TextEditingController();

  bool isLoading = false;
  bool isInternetConnected = false;
  List<Batch> batches = [];
  List<BatchType> batchTypes = [];
  List<Studio> studios = [];
  Batch? selectedBatch;
  BatchType? selectedBatchType;
  Studio? selectedStudio;
  bool contacted = false;

  String selectedGender = '';
  String practicingYoga = '';
  String pain = '';
  String illness = '';
  String? errorTextMobileNumber;
  List<String> selectedIllnesses = [];
  List<String> selectedPain = [];
  List<Batch> batchDetails = [];
  List<BatchType> batchTypeDetails = [];
  List<Studio> studioDetails = [];

  List<String> illnessOptions = [
    'Diabetes',
    'Thyroid',
    'Body Pain',
    'BP',
    'Migraine / Sciatica / Vertigo',
    'Other',
    'None',
  ];
  List<String> painOptions = [
    'Knee Pain',
    'Back Pain',
    'Shoulder Pain',
    'Other',
    'None',
  ];

  bool isNoneSelectedIllness = false;
  bool isNoneSelectedPain = false;

  @override
  void initState() {
    super.initState();
    fetchBatches();
    fetchBatchType();
    fetchStudios();
    checkInternetConnection((bool isConnected) {
      setState(() {
        isInternetConnected = isConnected;
      });
    });
  }

  Future<void> fetchBatches() async {
    try {
      setState(() {
        isLoading = true;
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
      print(error);
      setState(() {
        isInternetConnected = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchBatchType() async {
    try {
      setState(() {
        isLoading = true;
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
        isLoading = false;
      });
    }
  }

  Future<void> fetchStudios() async {
    try {
      setState(() {
        isLoading = true;
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
              // Add more fields if needed
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
        isLoading = false;
      });
    }
  }

  Future<void> submitForm() async {
    try {
      final inquiry = Inquiry(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        mobileNumber: mobileNumberController.text,
        age: ageController.text,
        selectedGender: selectedGender,
        reason: reasonController.text,
        practicingYoga: practicingYoga,
        pain: selectedPain,
        illness: selectedIllnesses,
        yogaDuration:
            practicingYoga == 'Yes' ? yogaDurationController.text : '',
        yogaLeftDuration:
            practicingYoga == 'Yes' ? yogaLeftDurationController.text : '',
        profession: professionController.text,
        reference: referenceController.text,
        BTypeID: selectedBatchType!.BTypeID.toString(),
        BatchID: selectedBatch!.BatchID.toString(),
        StudioID: selectedStudio!.StudioID.toString(),
        Contacted: contacted.toString(),
      );
      print(selectedBatch!.BatchID.toString());

      final Map<String, dynamic> formData =
          inquiry.toJson(); // Convert Inquiry instance to JSON
      print(formData);

      final response = await http.post(
        Uri.parse('https://app.nishasyoga.com/Inquiry.php'),
        body: formData,
      );
      print(formData);
      print(response.body);

      if (response.statusCode == 200) {
        String responseBody = response.body;

        try {
          // Remove non-JSON characters from the beginning and end of the response
          int startIndex = responseBody.indexOf('{');
          int endIndex = responseBody.lastIndexOf('}');

          if (startIndex != -1 && endIndex != -1 && startIndex <= endIndex) {
            responseBody = responseBody.substring(startIndex, endIndex + 1);
          }

          final Map<String, dynamic> data = jsonDecode(responseBody);

          if (data['success'] == true) {
            _showErrorDialog('Form submitted successfully!', () {
              // Clear the form after successful submission
              firstNameController.clear();
              lastNameController.clear();
              mobileNumberController.clear();
              ageController.clear();
              yogaDurationController.clear();
              yogaLeftDurationController.clear();
              reasonController.clear();
              reasonController.clear();
              professionController.clear();
              referenceController.clear();
              setState(() {
                selectedGender = '';
                practicingYoga = '';
              });
              // Navigate back to the previous screen
              Navigator.pop(context);
            });
          } else {
            _showErrorDialog('Failed to submit form: ${data['message']}');
          }
        } catch (e) {
          _showErrorDialog('Error decoding response: $e');
        }
      } else {
        _showErrorDialog('Error submitting form: ${response.reasonPhrase}');
      }
    } catch (error) {
      _showErrorDialog('Unexpected error: $error');
      print('$error');
    }
  }

  void _showErrorDialog(dynamic error, [VoidCallback? callback]) {
    String errorMessage = 'An error occurred. Please try again.';

    if (error is String) {
      errorMessage = error;
    } else if (error is FormatException) {
      errorMessage = 'Invalid data format. Please check your input.';
    } else if (error is TimeoutException) {
      errorMessage = 'Request timed out. Please try again later.';
    } else if (error is SocketException) {
      errorMessage = 'Network error. Please check your internet connection.';
    } else if (error is http.ClientException) {
      errorMessage = 'HTTP client error. Please try again.';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dialog Box'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (callback != null) {
                  callback();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  String? validateMobileNumber(String value) {
    if (value.length != 10 && value.isNotEmpty) {
      return 'Mobile number must have at least 10 digits';
    }
    return null;
  }

  bool validateForm() {
    if (validateMobileNumber(mobileNumberController.text) != null) {
      _showErrorDialog('All fields are important.');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inquiry',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: isLoading
          ? const LoadingWidget()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Please enter your data for submitting your Inquiry Form",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter,
                      ],
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Gender",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: ageController,
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: mobileNumberController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        counterText: '',
                        border: const OutlineInputBorder(),
                        errorText:
                            validateMobileNumber(mobileNumberController.text),
                      ),
                      style: const TextStyle(color: Colors.black),
                      onChanged: (value) {
                        // Trigger validation on each change
                        setState(() {
                          // Update the error text based on the validation result
                          // This will cause the error message to update as the user types
                          errorTextMobileNumber = validateMobileNumber(value);
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason For Joining?',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MultiSelectFormField(
                          autovalidate: AutovalidateMode.disabled,
                          chipBackGroundColor: Colors.white,
                          chipLabelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          dialogTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          checkBoxActiveColor: Colors.blue,
                          checkBoxCheckColor: Colors.white,
                          dialogShapeBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          title: const Text("Select Pain in the body"),
                          dataSource: const [
                            {"display": "Knee Pain", "value": "Knee Pain"},
                            {"display": "Back Pain", "value": "Back Pain"},
                            {
                              "display": "Shoulder Pain",
                              "value": "Shoulder Pain"
                            },
                            {"display": "Other", "value": "Other"},
                            {"display": "None", "value": "None"},
                          ],
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          hintWidget: const Text('Please choose one or more'),
                          initialValue: const [],
                          // Initialize with an empty list
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              // Filter out the "Other" option if it's selected
                              selectedPain = value
                                  .where((element) => element != 'Other')
                                  .cast<String>()
                                  .toList();
                              // Handle the "Other" option separately
                              if (value.contains('Other')) {
                                // Show a dialog to input the custom illness
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String customPain =
                                        ''; // Define customIllness variable
                                    return AlertDialog(
                                      title: const Text('Please Specify Other'),
                                      content: TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Other Illness',
                                        ),
                                        onChanged: (newValue) {
                                          // Update the custom illness text when the text changes
                                          setState(() {
                                            customPain = newValue;
                                          });
                                        },
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            // Add the custom illness to the selected illnesses list and close the dialog
                                            setState(() {
                                              selectedPain.add(customPain);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: selectedPain.map((illness) {
                            return Chip(
                              label: Text(illness),
                              onDeleted: () {
                                setState(() {
                                  selectedPain.remove(illness);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MultiSelectFormField(
                          autovalidate: AutovalidateMode.disabled,
                          chipBackGroundColor: Colors.white,
                          chipLabelStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          dialogTextStyle:
                              const TextStyle(fontWeight: FontWeight.bold),
                          checkBoxActiveColor: Colors.blue,
                          checkBoxCheckColor: Colors.white,
                          dialogShapeBorder: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0))),
                          title: const Text("Select Illness"),
                          dataSource: const [
                            {"display": "Diabetes", "value": "Diabetes"},
                            {"display": "Thyroid", "value": "Thyroid"},
                            {"display": "BP", "value": "BP"},
                            {"display": "Migraine", "value": "Migraine"},
                            {"display": "Sciatica", "value": "Sciatica"},
                            {"display": "Vertigo", "value": "Vertigo"},
                            {"display": "Other", "value": "Other"},
                            {"display": "None", "value": "None"},
                          ],
                          textField: 'display',
                          valueField: 'value',
                          okButtonLabel: 'OK',
                          cancelButtonLabel: 'CANCEL',
                          hintWidget: const Text('Please choose one or more'),
                          initialValue: const [],
                          // Initialize with an empty list
                          onSaved: (value) {
                            if (value == null) return;
                            setState(() {
                              // Filter out the "Other" option if it's selected
                              selectedIllnesses = value
                                  .where((element) => element != 'Other')
                                  .cast<String>()
                                  .toList();
                              // Handle the "Other" option separately
                              if (value.contains('Other')) {
                                // Show a dialog to input the custom illness
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    String customIllness =
                                        ''; // Define customIllness variable
                                    return AlertDialog(
                                      title: const Text('Please Specify Other'),
                                      content: TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Enter Other Illness',
                                        ),
                                        onChanged: (newValue) {
                                          // Update the custom illness text when the text changes
                                          setState(() {
                                            customIllness = newValue;
                                          });
                                        },
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedIllnesses =
                                                  List<String>.from(value);
                                              selectedIllnesses
                                                  .add(customIllness);
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: selectedIllnesses.map((illness) {
                            if (illness == 'Other') {
                              return Chip(
                                label: const Text("Other Illness"),
                                // Assuming customIllness is a variable storing the custom illness
                                onDeleted: () {
                                  setState(() {
                                    selectedIllnesses.remove(illness);
                                  });
                                },
                              );
                            } else {
                              return Chip(
                                label: Text(illness),
                                onDeleted: () {
                                  setState(() {
                                    selectedIllnesses.remove(illness);
                                  });
                                },
                              );
                            }
                          }).toList(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Have you been practicing yoga lately?",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    RadioListTile<String>(
                      title: const Text('Yes'),
                      value: 'Yes',
                      groupValue: practicingYoga,
                      onChanged: (value) {
                        setState(() {
                          practicingYoga = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('No'),
                      value: 'No',
                      groupValue: practicingYoga,
                      onChanged: (value) {
                        setState(() {
                          practicingYoga = value!;
                        });
                      },
                    ),
                    if (practicingYoga == 'Yes')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: yogaDurationController,
                            decoration: const InputDecoration(
                              labelText: 'How long have you been practicing?',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: yogaLeftDurationController,
                            decoration: const InputDecoration(
                              labelText: 'Since when did you stop doing yoga?',
                              border: OutlineInputBorder(),
                            ),
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: professionController,
                      decoration: const InputDecoration(
                        labelText: 'What is your profession?',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: referenceController,
                      decoration: const InputDecoration(
                        labelText: 'Reference',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 20),
                    // Dropdown for studio details
                    DropdownButtonFormField<int>(
                      value: selectedStudio?.StudioID,
                      // Set the selected value to the batchID
                      decoration: const InputDecoration(
                        labelText: 'Studios',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          studios.map<DropdownMenuItem<int>>((Studio studio) {
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
                            selectedBatchType = null;
                            selectedBatch = null;
                          }
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    // Dropdown for studio details
                    DropdownButtonFormField<int>(
                      value: selectedBatchType?.BTypeID,
                      // Set the selected value to the batchID
                      decoration: const InputDecoration(
                        labelText: 'Batch Type',
                        border: OutlineInputBorder(),
                      ),
                      items: batchTypes
                          .where((batchType) =>
                              selectedStudio != null &&
                              batchType.StudioID != null &&
                              batchType.StudioID.split(',').contains(selectedStudio!
                                  .StudioID
                                  .toString())) // Check if selectedStudio's ID is in the list of StudioIDs
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
                            print('Selected BatchType: ${selectedBatchType?.BTypeID}');
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    // Dropdown for batch details
                    DropdownButtonFormField<int>(
                      value: selectedBatch?.BatchID,
                      decoration: const InputDecoration(
                        labelText: 'Batch Timings',
                        border: OutlineInputBorder(),
                      ),
                      items: batches
                          .where((batch) =>
                              selectedBatchType != null &&
                              batch.BatchID != null &&
                              selectedBatchType!.BatchID.split(',').contains(batch
                                      .BatchID
                                  .toString())) // Check if BatchID is in the list of BatchIDs
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
                            selectedBatch = batches.firstWhere(
                                    (batch) => batch.BatchID == newValue);
                            print('Selected Batch Object: $selectedBatch');
                            print('Selected Batch: ${selectedBatch?.BatchID}');
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (validateForm()) {
                          submitForm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
