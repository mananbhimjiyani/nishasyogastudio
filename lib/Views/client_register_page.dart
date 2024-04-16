import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import '../Schema/Batch.dart';
import '../Widget/internet_check.dart';
import '../Widget/Loading_Widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emergencyContactController =
      TextEditingController();
  final TextEditingController emergencyNameController = TextEditingController();
  final TextEditingController emergencyAddressController =
      TextEditingController();
  final TextEditingController emergencyRelationshipController =
      TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController pinOrZipController = TextEditingController();
  final TextEditingController stateOrProvinceController =
      TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController occupationController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController spouseController = TextEditingController();
  final TextEditingController spouseOccupationController =
      TextEditingController();
  final TextEditingController officeAddressController = TextEditingController();

  final TextEditingController emailIdController = TextEditingController();

  // File? _image;
  Country selectedCountry = CountryPickerUtils.getCountryByIsoCode('IN');
  List<Batch> batches = [];
  Batch? selectedBatch;
  String? errorTextMobileNumber;
  String? errorTextPhoneNumber;
  bool isLoading = false;
  bool isInternetConnected = false;

  @override
  void initState() {
    super.initState();
    // fetchBatches();
    checkInternetConnection((bool isConnected) {
      setState(() {
        isInternetConnected = isConnected;
      });
    });
  }

  // Future<void> fetchBatches() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final response =
  //         await http.get(Uri.parse('https://app.nishasyoga.com/batches.php'));
  //
  //     print(response.body);
  //
  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = json.decode(response.body);
  //       setState(() {
  //         batches = data.map((batch) {
  //           return Batch(
  //             BatchID: batch['BatchID'],
  //             CompanyID: batch['CompanyID'],
  //             BatchStartTime: batch['BatchStartTime'],
  //             BatchEndTime: batch['BatchEndTime'],
  //             workingDays: batch['WorkingDays'],
  //             view: batch['View'],
  //             timeStamp: batch['TimeStamp'],
  //           );
  //         }).toList();
  //       });
  //     } else {}
  //   } catch (error) {
  //     setState(() {
  //       isInternetConnected = false;
  //     });
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // Future<void> _getImage() async {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Select Image Source'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 _pickImage(ImageSource.gallery);
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.brown,
  //               ),
  //               child: const Text(
  //                 'Pick from Gallery',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context); // Close the dialog
  //                 _pickImage(ImageSource.camera);
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.brown,
  //               ),
  //               child: const Text(
  //                 'Capture from Camera',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  //
  // Future<void> _pickImage(ImageSource source) async {
  //   final pickedFile = await ImagePicker().pickImage(source: source);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _image = File(pickedFile.path);
  //     }
  //   });
  // }

  bool _areFieldsEmpty() {
    return firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emergencyContactController.text.isEmpty ||
        emergencyAddressController.text.isEmpty ||
        emergencyNameController.text.isEmpty ||
        emergencyRelationshipController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        address1Controller.text.isEmpty ||
        address2Controller.text.isEmpty ||
        cityController.text.isEmpty ||
        pinOrZipController.text.isEmpty ||
        stateOrProvinceController.text.isEmpty ||
        websiteController.text.isEmpty ||
        emailIdController.text.isEmpty;
  }

  Future<void> _submitForm() async {
    if (_areFieldsEmpty()) {
      _showErrorDialog('Please fill all compulsory fields.');
    }
    try {
      setState(() {
        isLoading = true;
      });
      print('Submitting form...');
      final uri = Uri.parse('https://app.nishasyoga.com/register.php');
      final request = http.MultipartRequest('POST', uri);

      request.fields['FirstName'] = firstNameController.text;
      request.fields['LastName'] = lastNameController.text;
      request.fields['Phone'] = phoneController.text;
      request.fields['Mobile'] = mobileController.text;
      request.fields['EmergencyContact'] = emergencyContactController.text;
      request.fields['EName'] = emergencyNameController.text;
      request.fields['EAddress'] = emergencyAddressController.text;
      request.fields['ERelationship'] = emergencyRelationshipController.text;
      request.fields['BirthDate'] = birthDateController.text;
      request.fields['Address1'] = address1Controller.text;
      request.fields['Address2'] = address2Controller.text;
      request.fields['City'] = cityController.text;
      request.fields['PinOrZip'] = pinOrZipController.text;
      request.fields['StateOrProvince'] = stateOrProvinceController.text;
      request.fields['Height'] = heightController.text;
      request.fields['Weight'] = weightController.text;
      request.fields['Country'] = "India";
      request.fields['Spouse'] = spouseController.text;
      request.fields['SOccupation'] = spouseOccupationController.text;
      request.fields['Occupation'] = occupationController.text;
      request.fields['CompanyName'] = companyNameController.text;
      request.fields['OfficeAddress'] = officeAddressController.text;
      request.fields['Website'] = websiteController.text;
      request.fields['EmailID'] = emailIdController.text;
      request.fields['UserTypeID'] = "3";
      request.fields['Username'] = phoneController.text;
      request.fields['Password'] = firstNameController.text;
      request.fields['Active'] = "1";

      // if (_image != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath(
      //       'Photo',
      //       _image!.path,
      //       filename:
      //           '${firstNameController.text}-${lastNameController.text}.jpg',
      //     ),
      //   );
      // }

      final response = await http.Response.fromStream(await request.send());
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        String responseBody = response.body;

        try {
          int startIndex = responseBody.indexOf('{');
          int endIndex = responseBody.lastIndexOf('}');

          if (startIndex != -1 && endIndex != -1 && startIndex <= endIndex) {
            responseBody = responseBody.substring(startIndex, endIndex + 1);
          }

          final Map<String, dynamic> data = jsonDecode(responseBody);

          if (data['success'] == true) {
            // Handle successful submission

            print('Form submitted successfully!');
            firstNameController.clear();
            lastNameController.clear();
            phoneController.clear();
            emergencyContactController.clear();
            emergencyAddressController.clear();
            emergencyNameController.clear();
            emergencyRelationshipController.clear();
            birthDateController.clear();
            address1Controller.clear();
            address2Controller.clear();
            cityController.clear();
            pinOrZipController.clear();
            stateOrProvinceController.clear();
            websiteController.clear();
            emailIdController.clear();
            weightController.clear();
            heightController.clear();
            spouseController.clear();
            spouseOccupationController.clear();
            companyNameController.clear();
            officeAddressController.clear();
            Navigator.pop(context);
            _showErrorDialog('Form submitted successfully!');
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
      print('Error in _submitForm: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
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
    if (validateMobileNumber(mobileController.text) != null) {
      // Display an error message or handle validation failure
      _showErrorDialog('Invalid form data. Please check your input.');
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading && isInternetConnected
            ? const LoadingWidget()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: mobileController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        counterText: '',
                        border: const OutlineInputBorder(),
                        errorText: validateMobileNumber(mobileController.text),
                      ),
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
                      controller: phoneController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        counterText: '',
                        border: const OutlineInputBorder(),
                        errorText: validateMobileNumber(phoneController.text),
                      ),
                      onChanged: (value) {
                        setState(() {
                          errorTextPhoneNumber = validateMobileNumber(value);
                        });
                      },
                    ),

                    const SizedBox(height: 20),
                    TextField(
                      controller: emailIdController,
                      decoration: const InputDecoration(
                        labelText: 'Email ID',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emergencyContactController,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Emergency Contact Number',
                        counterText: '',
                        border: const OutlineInputBorder(),
                        errorText: validateMobileNumber(
                            emergencyContactController.text),
                      ),
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
                      controller: emergencyNameController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Person Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emergencyAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Address Line',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: emergencyRelationshipController,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Relationship',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      controller: birthDateController,
                      decoration: const InputDecoration(
                        labelText: 'Birth Date',
                        border: OutlineInputBorder(),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          // Format the selected date and update the controller
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          birthDateController.text = formattedDate;
                        }
                      },
                    ),
                    // const SizedBox(height: 20),
                    // const Text(
                    //   "Capture your Image",
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    // IconButton(
                    //   icon: const Icon(Icons.camera),
                    //   onPressed: _getImage,
                    //   tooltip: 'Capture Picture',
                    // ),
                    // if (_image != null)
                    //   Image.file(
                    //     _image!,
                    //     height: 200,
                    //     width: 200,
                    //     fit: BoxFit.cover,
                    //   ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: address1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Address Line 1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: address2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Address Line 2',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: pinOrZipController,
                      decoration: const InputDecoration(
                        labelText: 'Pin Or Zip Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: stateOrProvinceController,
                      decoration: const InputDecoration(
                        labelText: 'State or Province',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      // Set keyboard type to numeric
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly // Allow only digits
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Weight',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: heightController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Allows decimal numbers
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        // Allows digits and decimal point
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Height',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: occupationController,
                      decoration: const InputDecoration(
                        labelText: 'Occupation',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: companyNameController,
                      decoration: const InputDecoration(
                        labelText: 'Company Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: officeAddressController,
                      decoration: const InputDecoration(
                        labelText: 'Office Address',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: websiteController,
                      decoration: const InputDecoration(
                        labelText: 'Website',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: spouseController,
                      decoration: const InputDecoration(
                        labelText: 'Spouse',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: spouseOccupationController,
                      decoration: const InputDecoration(
                        labelText: 'Spouse Occupation',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    // const SizedBox(height: 20),
                    // DropdownButtonFormField<int>(
                    //   value: selectedBatch?.BatchID,
                    //   // Set the selected value to the batchID
                    //   decoration: const InputDecoration(
                    //     labelText: 'Batch Timings',
                    //     border: OutlineInputBorder(),
                    //   ),
                    //   items: batches.map<DropdownMenuItem<int>>((Batch batch) {
                    //     return DropdownMenuItem<int>(
                    //       value: batch.BatchID,
                    //       child: Row(
                    //         children: [
                    //           Text(
                    //               '${batch.BatchStartTime} - ${batch.BatchEndTime}'),
                    //         ],
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (int? newValue) {
                    //     if (newValue != null) {
                    //       setState(() {
                    //         selectedBatch = batches.firstWhere(
                    //             (batch) => batch.BatchID == newValue);
                    //       });
                    //     }
                    //   },
                    // ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
    String? validateEmail(String value) {
      String pattern =
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // Regular expression for email validation
      RegExp regExp = RegExp(pattern);
      if (!regExp.hasMatch(value)) {
        return 'Enter a valid email';
      }
      return null;
    }
  }
}
