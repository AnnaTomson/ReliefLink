import 'package:flutter/material.dart';

class TransactionProcessing extends StatefulWidget {
  @override
  _TransactionProcessingState createState() => _TransactionProcessingState();
}

class _TransactionProcessingState extends State<TransactionProcessing> {
  final _formKey = GlobalKey<FormState>();
  String donorName = '';
  double donationAmount = 0.0;
  bool isTransactionProcessed = false;

  // Mock data for a single recipient
  final Map<String, dynamic> receiver = {
    'id': 'R001',
    'name': 'John Joseph',
    'disaster': 'Flood',
  };

  void processTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        isTransactionProcessed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Process Transaction'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isTransactionProcessed
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction Successful!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Donor: $donorName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Amount Donated: ₹${donationAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Receiver Details:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Receiver ID: ${receiver['id']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Name: ${receiver['name']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Disaster Affected: ${receiver['disaster']}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isTransactionProcessed = false;
                      });
                    },
                    child: const Text('Process Another Transaction'),
                  ),
                ],
              )
            : Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Details',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Donor Name'),
                      onSaved: (value) => donorName = value!,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your name' : null,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Donation Amount (₹)'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => donationAmount = double.parse(value!),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter an amount' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: processTransaction,
                      child: const Text('Process Transaction'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
