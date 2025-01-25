import 'package:flutter/material.dart';
import 'ReceiverEnquiry.dart'; // Import the ReceiverEnquiry screen

class TransactionProcessing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy donor details
    String donorName = 'Alice Smith';
    String donorEmail = 'alice.smith@example.com';
    String donorPhone = '1234567890';
    double donationAmount = 1000.0;

    // Mock data for a single recipient
    final Map<String, dynamic> receiver = {
      'id': 'R001',
      'name': 'John Joseph',
      'disaster': 'Flood',
    };

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Transaction Summary',
            style: TextStyle(color: Colors.white)), // Changed text color
        backgroundColor: Colors.teal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>
              Navigator.of(context).pop(), // Navigate back to the last page
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              // Show information dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Transaction Info'),
                  content: const Text('This is a summary of your transaction.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction Successful!',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildDetailCard('Donor:', donorName),
                _buildDetailCard('Email:', donorEmail),
                _buildDetailCard('Phone:', donorPhone),
                _buildDetailCard(
                    'Amount Donated:', '₹${donationAmount.toStringAsFixed(2)}'),
                const SizedBox(height: 20),
                const Text('Receiver Details:',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 10),
                _buildDetailCard('Receiver ID:', receiver['id']),
                _buildDetailCard('Name:', receiver['name']),
                _buildDetailCard('Disaster Affected:', receiver['disaster']),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the ReceiverEnquiry screen
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const ReceiverEnquiryScreen(),
                        ),
                        (Route<dynamic> route) =>
                            false, // Remove all previous routes
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                    child: const Text('Go to Receiver Enquiry',
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 18, color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}
