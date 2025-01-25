import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:file_picker/file_picker.dart';

class PeopleAddScreen extends StatefulWidget {
  const PeopleAddScreen({Key? key}) : super(key: key);

  @override
  _PeopleAddScreenState createState() => _PeopleAddScreenState();
}

class _PeopleAddScreenState extends State<PeopleAddScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _age = '';
  String _gender = 'Male';
  String _contactNumber = '';
  String _documentType = 'Aadhar Card';
  String _documentPath = '';
  String _incomeRange = 'Under 1 Lakh'; // New income range variable

  final List<String> _documentTypes = [
    'Aadhar Card',
    'PAN Card',
    'Voter ID',
    'Driving License',
    'Passport'
  ];

  final List<String> _incomeRanges = [
    'Under 1 Lakh',
    '1 to 5 Lakhs',
    '5 to 10 Lakhs',
    '10 Lakhs and above'
  ]; // New income range options

  bool _houseAffected = false;
  bool _hasInfant = false;
  bool _hasPregnantWoman = false;

  final List<String> _yesNoOptions = ['Yes', 'No']; // Options for Yes/No fields

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Add Person',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade700,
              Colors.teal.shade500,
              Colors.teal.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildTextField('Name', Icons.person),
                          const SizedBox(height: 20),
                          _buildTextField('Age', Icons.cake, isNumber: true),
                          const SizedBox(height: 20),
                          _buildDropdownField(
                              'Gender', Icons.wc, ['Male', 'Female', 'Other']),
                          const SizedBox(height: 20),
                          _buildTextField('Contact Number', Icons.phone,
                              isPhone: true),
                          const SizedBox(height: 20),
                          _buildDropdownField(
                              'Income Range', Icons.money, _incomeRanges,
                              initialValue: _incomeRange, onChanged: (value) {
                            setState(() {
                              _incomeRange = value!;
                            });
                          }), // New income range field
                          const SizedBox(height: 20),
                          _buildDropdownField('Did the house get affected?',
                              Icons.home, _yesNoOptions,
                              initialValue: _houseAffected ? 'Yes' : 'No',
                              onChanged: (value) {
                            setState(() {
                              _houseAffected = value == 'Yes';
                            });
                          }),
                          const SizedBox(height: 20),
                          _buildDropdownField(
                              'Is there any infant in the family?',
                              Icons.child_care,
                              _yesNoOptions,
                              initialValue: _hasInfant ? 'Yes' : 'No',
                              onChanged: (value) {
                            setState(() {
                              _hasInfant = value == 'Yes';
                            });
                          }),
                          const SizedBox(height: 20),
                          _buildDropdownField('Is there any pregnant woman?',
                              Icons.pregnant_woman, _yesNoOptions,
                              initialValue: _hasPregnantWoman ? 'Yes' : 'No',
                              onChanged: (value) {
                            setState(() {
                              _hasPregnantWoman = value == 'Yes';
                            });
                          }),
                          const SizedBox(height: 20),
                          _buildDropdownField('Document Type',
                              Icons.description, _documentTypes),
                          const SizedBox(height: 20),
                          _buildDocumentUploadButton(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon,
      {bool isNumber = false, bool isPhone = false, int maxLines = 1}) {
    return TextFormField(
      decoration: _inputDecoration(label, icon),
      keyboardType: isNumber
          ? TextInputType.number
          : (isPhone ? TextInputType.phone : TextInputType.text),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: (value) {
        switch (label) {
          case 'Name':
            _name = value!;
            break;
          case 'Age':
            _age = value!;
            break;
          case 'Contact Number':
            _contactNumber = value!;
            break;
        }
      },
    );
  }

  Widget _buildDropdownField(String label, IconData icon, List<String> items,
      {String? initialValue, ValueChanged<String?>? onChanged}) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(label, icon),
      value: initialValue,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildYesNoField(
      String label, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 10),
        DropdownButton<bool>(
          value: value,
          items: [
            DropdownMenuItem(value: true, child: Text('Yes')),
            DropdownMenuItem(value: false, child: Text('No')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDocumentUploadButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.upload_file, size: 24),
      label: Text(
        _documentPath.isEmpty
            ? 'Upload $_documentType'
            : '$_documentType Uploaded',
        style: const TextStyle(fontSize: 16),
      ),
      onPressed: _pickDocument,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal.shade600,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.person_add, size: 28),
      label: const Text(
        'Add Person',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.teal.shade700,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      prefixIcon: Icon(icon, color: Colors.teal.shade700),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.teal.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.teal.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.teal.shade700, width: 2),
      ),
      labelStyle: TextStyle(color: Colors.teal.shade700),
    );
  }

  Future<void> _pickDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _documentPath = result.files.single.path!;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String impactFactor = _calculateImpactFactor();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 16,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade300, Colors.teal.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Submission Successful',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Impact Factor: $impactFactor',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String _calculateImpactFactor() {
    int impact = 0;

    // Calculate impact based on income range
    switch (_incomeRange) {
      case 'Under 1 Lakh':
        impact += 1;
        break;
      case '1 to 5 Lakhs':
        impact += 2;
        break;
      case '5 to 10 Lakhs':
        impact += 3;
        break;
      case '10 Lakhs and above':
        impact += 4;
        break;
    }

    // Add impact for house affected
    if (_houseAffected) {
      impact += 2;
    }

    // Add impact for pregnant woman
    if (_hasPregnantWoman) {
      impact += 3;
    }

    return impact.toString();
  }
}
