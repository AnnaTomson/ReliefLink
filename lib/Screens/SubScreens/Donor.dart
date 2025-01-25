import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:relief_link/Screens/Payment.dart'; // Import the Payment screen
import 'package:relief_link/Screens/SubScreens/CampHelp.dart'; // Import the CampHelp screen

class DonorScreen extends StatelessWidget {
  const DonorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Donor Portal',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Camp Help'),
              Tab(text: 'Post-Camp Help'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal, Colors.tealAccent, Colors.cyan],
            ),
          ),
          child: SafeArea(
            child: TabBarView(
              children: [
                _buildCampHelpTab(context),
                _buildPostCampHelpTab(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCampHelpTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support Camp Relief',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(
                      'DisasterList') // Fetching from DisasterList collection
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return const Center(child: Text('Error fetching data'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  debugPrint('No data found');
                  return const Center(child: Text('No data available'));
                }
                final disasters = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: disasters.length,
                  itemBuilder: (context, index) {
                    final disaster = disasters[index];
                    return campaignCard(
                      disaster['Name'], // Fetching Name from DisasterList
                      disaster['Region'], // Fetching Region from DisasterList
                      0.0, // Placeholder for progress, adjust as needed
                      context,
                      true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCampHelpTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support Post-Camp Recovery',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(
                      'DisasterList') // Fetching from DisasterList collection
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  debugPrint('Error: ${snapshot.error}');
                  return const Center(child: Text('Error fetching data'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  debugPrint('No data found');
                  return const Center(child: Text('No data available'));
                }
                final disasters = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: disasters.length,
                  itemBuilder: (context, index) {
                    final disaster = disasters[index];
                    return campaignCard(
                      disaster['Name'], // Fetching Name from DisasterList
                      disaster['Region'], // Fetching Region from DisasterList
                      0.0, // Placeholder for progress, adjust as needed
                      context,
                      false,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget campaignCard(String title, String raised, double progress,
      BuildContext context, bool isCampHelp) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
            const SizedBox(height: 16),
            Text(
              raised,
              style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            if (isCampHelp) ...[
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select a Camp',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                      value: 'Camp Alpha', child: Text('Camp Alpha')),
                  DropdownMenuItem(
                      value: 'Camp Beta', child: Text('Camp Beta')),
                  DropdownMenuItem(
                      value: 'Camp Gamma', child: Text('Camp Gamma')),
                ],
                onChanged: (String? newValue) {
                  // Handle camp selection
                },
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isCampHelp) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CampHelpScreen(),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PaymentScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Donate Now', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
