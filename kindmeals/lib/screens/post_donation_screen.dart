import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class PostDonationScreen extends StatefulWidget {
  const PostDonationScreen({super.key});

  @override
  _PostDonationScreenState createState() => _PostDonationScreenState();
}

class _PostDonationScreenState extends State<PostDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _foodNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  XFile? _image;
  bool _isVeg = false;
  bool _isNonVeg = false;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  @override
  void dispose() {
    _quantityController.dispose();
    _expiryDateController.dispose();
    _descriptionController.dispose();
    _foodNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _submitDonation() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        var dio = Dio();

        // Create form data
        var formData = FormData();

        // Add text fields
        formData.fields.addAll([
          MapEntry('foodName', _foodNameController.text),
          MapEntry('quantity', _quantityController.text),
          MapEntry('description', _descriptionController.text),
          MapEntry('expiryDate', _expiryDateController.text),
          MapEntry('isVeg', _isVeg.toString()),
          MapEntry('isNonVeg', _isNonVeg.toString()),
          MapEntry('location', _locationController.text), // Use lowercase 'location'
        ]);

        // Add image if selected
        formData.files.add(MapEntry(
          'image',
          await MultipartFile.fromFile(_image!.path, filename: 'donation_image.jpg'),
        ));

        // Add latitude and longitude if available
        Position? position = await _getCurrentLocation();
        if (position != null) {
          formData.fields.addAll([
            MapEntry('latitude', position.latitude.toString()),
            MapEntry('longitude', position.longitude.toString()),
          ]);
        }

        // Send request
        var response = await dio.post(
          'http://192.168.0.100:3000/api/donations', // Update with your IP
          data: formData,
          options: Options(
            headers: {
              'Accept': 'application/json',
            },
          ),
        );

        if (response.statusCode == 201) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Donation posted successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset form
          _formKey.currentState?.reset();
          setState(() {
            _image = null;
            _isVeg = false;
            _isNonVeg = false;
            _foodNameController.clear();
            _quantityController.clear();
            _descriptionController.clear();
            _expiryDateController.clear();
            _locationController.clear();
            _selectedTime = null;
          });
        } else {
          if (!mounted) return;
          throw Exception('Failed to post donation. Status: ${response.statusCode}');
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _selectDateAndTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (pickedDate != null) {
      await _selectTime();
      if (_selectedTime != null) {
        setState(() {
          _expiryDateController.text =
              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} ${_selectedTime!.format(context)}';
        });
      }
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get the current location
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _fetchLocation() async {
    try {
      Position? position = await _getCurrentLocation();
      if (position != null) {
        setState(() {
          _locationController.text = 'Lat: ${position.latitude}, Long: ${position.longitude}';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to fetch location. Please enable location services and grant permissions.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Donation'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: _isLoading ? null : _pickImage,
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: _image == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          size: 50, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text('Tap to add photo',
                                          style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    File(_image!.path),
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Veg'),
                              value: _isVeg,
                              onChanged: _isLoading
                                  ? null
                                  : (bool? value) {
                                      setState(() {
                                        _isVeg = value ?? false;
                                        if (_isVeg) _isNonVeg = false;
                                      });
                                    },
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Non-Veg'),
                              value: _isNonVeg,
                              onChanged: _isLoading
                                  ? null
                                  : (bool? value) {
                                      setState(() {
                                        _isNonVeg = value ?? false;
                                        if (_isNonVeg) _isVeg = false;
                                      });
                                    },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _foodNameController,
                        decoration: InputDecoration(
                          labelText: 'Food Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        enabled: !_isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the food name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _quantityController,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        enabled: !_isLoading,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the quantity';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        enabled: !_isLoading,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _expiryDateController,
                        decoration: InputDecoration(
                          labelText: 'Expiry Date and Time',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        enabled: !_isLoading,
                        readOnly: true,
                        onTap: _isLoading ? null : _selectDateAndTime,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the expiry date';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        enabled: !_isLoading,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fetch your location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _fetchLocation,
                        child: const Text('Fetch Location'),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitDonation,
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Post Donation'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}