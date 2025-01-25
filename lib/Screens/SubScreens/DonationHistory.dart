import 'package:flutter/material.dart';

class DonationHistory extends StatelessWidget {
  final List<Map<String, String>> donations = [
    {'date': '2025-01-20', 'amount': '₹1,000', 'beneficiary': 'Camp A'},
    {'date': '2025-01-22', 'amount': '₹500', 'beneficiary': 'Camp B'},
    {'date': '2025-01-23', 'amount': '₹2,000', 'beneficiary': 'Camp C'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Donation History',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: donations.length,
                itemBuilder: (context, index) {
                  final donation = donations[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      title: Text(donation['amount']!),
                      subtitle: Text('Beneficiary: ${donation['beneficiary']}'),
                      trailing: Text(donation['date']!),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
