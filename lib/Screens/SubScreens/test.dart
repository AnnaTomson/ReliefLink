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
  String _uniqueId = '';
  String _name = '';
  String _age = '';
  String _gender = 'Male';
  String _contactNumber = '';
  String _medicalCondition = '';
  String _documentType = 'Aadhar Card';
  String _documentPath = '';

  final List<String> _documentTypes = [
    'Aadhar Card',
    'PAN Card',
    'Voter ID',
    'Driving License',
    'Passport'
  ];

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
                          _buildTextField('Unique ID', Icons.fingerprint),
                          const SizedBox(height: 20),
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
                          _buildTextField('Medical Condition (if any)',
                              Icons.medical_services,
                              maxLines: 3),
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
          case 'Unique ID':
            _uniqueId = value!;
            break;
          case 'Name':
            _name = value!;
            break;
          case 'Age':
            _age = value!;
            break;
          case 'Contact Number':
            _contactNumber = value!;
            break;
          case 'Medical Condition (if any)':
            _medicalCondition = value!;
            break;
        }
      },
    );
  }

  Widget _buildDropdownField(String label, IconData icon, List<String> items) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(label, icon),
      value: label == 'Gender' ? _gender : _documentType,
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        setState(() {
          if (label == 'Gender') {
            _gender = value!;
          } else {
            _documentType = value!;
          }
        });
      },
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
      // TODO: Process the form data (e.g., save to database)
      // TODO: Handle the uploaded document (_documentPath)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Person added successfully'),
          backgroundColor: Colors.teal.shade600,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
