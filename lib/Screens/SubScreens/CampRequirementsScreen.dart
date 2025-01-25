import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requirement {
  String name;
  int quantity;
  String urgencyLevel;

  Requirement(
      {required this.name, required this.quantity, required this.urgencyLevel});

  Map<String, dynamic> toMap() {
    return {
      'RequirementName': name,
      'Quantity': quantity,
      'UrgencyLevel': urgencyLevel,
    };
  }

  static Requirement fromMap(Map<String, dynamic> map) {
    return Requirement(
      name: map['RequirementName'],
      quantity: map['Quantity'],
      urgencyLevel: map['UrgencyLevel'],
    );
  }
}

class CampRequirementsScreen extends StatefulWidget {
  const CampRequirementsScreen({Key? key}) : super(key: key);

  @override
  _CampRequirementsScreenState createState() => _CampRequirementsScreenState();
}

class _CampRequirementsScreenState extends State<CampRequirementsScreen> {
  List<Requirement> requirements = [];

  @override
  void initState() {
    super.initState();
    _fetchRequirements();
  }

  Future<void> _fetchRequirements() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('RequirementList').get();
    setState(() {
      requirements =
          snapshot.docs.map((doc) => Requirement.fromMap(doc.data())).toList();
    });
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return Colors.red.shade400;
      case 'medium':
        return Colors.orange.shade400;
      case 'low':
        return Colors.green.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  void _addNewRequirement() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newName = '';
        int newQuantity = 0;
        String newUrgency = 'Medium';

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Requirement',
                  style: TextStyle(
                    color: Colors.teal,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  onChanged: (value) => newName = value,
                  decoration: InputDecoration(
                    labelText: 'Requirement Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.inventory, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.teal.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => newQuantity = int.tryParse(value) ?? 0,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 2),
                    ),
                    prefixIcon: const Icon(Icons.numbers, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.teal.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: newUrgency,
                  onChanged: (value) => newUrgency = value!,
                  items: ['Low', 'Medium', 'High'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'Urgency Level',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.teal, width: 2),
                    ),
                    prefixIcon:
                        const Icon(Icons.priority_high, color: Colors.teal),
                    filled: true,
                    fillColor: Colors.teal.withOpacity(0.1),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(color: Colors.grey, fontSize: 18)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      child: const Text('Add',
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      onPressed: () async {
                        if (newName.isNotEmpty && newQuantity > 0) {
                          Requirement newRequirement = Requirement(
                            name: newName,
                            quantity: newQuantity,
                            urgencyLevel: newUrgency,
                          );

                          // Debug logs to ensure correct values
                          print('Requirement Name: $newName');
                          print('Quantity: $newQuantity');
                          print('Urgency: $newUrgency');

                          // Firestore insertion with error handling
                          try {
                            await FirebaseFirestore.instance
                                .collection('RequirementList')
                                .add(newRequirement.toMap());

                            setState(() {
                              requirements.add(newRequirement);
                            });

                            Navigator.of(context).pop();

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('New requirement added',
                                    style: TextStyle(fontSize: 16)),
                                backgroundColor: Colors.green.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          } catch (e) {
                            print('Error adding requirement: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Error adding requirement',
                                    style: TextStyle(fontSize: 16)),
                                backgroundColor: Colors.red.shade400,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteRequirement(int index) async {
    final requirement = requirements[index];
    try {
      // Firestore deletion
      await FirebaseFirestore.instance
          .collection('RequirementList')
          .where('RequirementName', isEqualTo: requirement.name)
          .where('Quantity', isEqualTo: requirement.quantity)
          .where('UrgencyLevel', isEqualTo: requirement.urgencyLevel)
          .get()
          .then((snapshot) {
        for (var doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      setState(() {
        requirements.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              const Text('Requirement deleted', style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      print('Error deleting requirement: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error deleting requirement',
              style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Camp Requirements',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade700,
              Colors.teal.shade500,
              Colors.teal.shade300
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: requirements.length,
                  itemBuilder: (context, index) {
                    final requirement = requirements[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(20),
                          leading: Container(
                            width: 16,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: _getUrgencyColor(requirement.urgencyLevel),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          title: Text(
                            requirement.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                'Quantity: ${requirement.quantity}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Urgency: ${requirement.urgencyLevel}',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteRequirement(index);
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _addNewRequirement,
            icon: const Icon(
              Icons.add,
              size: 28,
              color: Colors.teal,
            ),
            label: const Text(
              'Add Requirement',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.teal.shade700,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation:
                  0, // Removed default elevation since we're using custom shadow
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
