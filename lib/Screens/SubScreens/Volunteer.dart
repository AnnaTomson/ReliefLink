import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'CampRequirementsScreen.dart';
import 'PeopleAdd.dart'; // Import the PeopleAdd screen

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text('Volunteer Portal',
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
              Tab(text: 'Add Camp'),
              Tab(text: 'Add People'),
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
                _buildAddCampTab(context),
                _buildAddPeopleTab(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddCampTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add Camp',
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
                  .collection('DisasterList')
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
                final disasterDocs = snapshot.data!.docs;
                debugPrint('Data fetched: ${disasterDocs.length} documents');
                return ListView.builder(
                  itemCount: disasterDocs.length,
                  itemBuilder: (context, index) {
                    final disaster = disasterDocs[index];
                    debugPrint('Document ${index + 1}: ${disaster.data()}');
                    return disasterCard(
                      disaster['Name'],
                      'Region: ${disaster['Region']}', // Using 'region' instead of 'location'
                      'Status: In Camp',
                      ['Camp Alpha', 'Camp Beta', 'Camp Gamma'],
                      context,
                      isAddCamp: true,
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

  Widget _buildAddPeopleTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Add People',
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
                  .collection('DisasterList')
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
                final disasterDocs = snapshot.data!.docs;
                debugPrint('Data fetched: ${disasterDocs.length} documents');
                return ListView.builder(
                  itemCount: disasterDocs.length,
                  itemBuilder: (context, index) {
                    final disaster = disasterDocs[index];
                    debugPrint('Document ${index + 1}: ${disaster.data()}');
                    return disasterCard(
                      disaster['Name'],
                      'Region: ${disaster['Region']}', // Using 'region' instead of 'location'
                      'Status: In Camp',
                      ['Camp Eta', 'Camp Theta', 'Camp Iota'],
                      context,
                      isAddCamp: false,
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

  Widget disasterCard(String title, String region, String status,
      List<String> camps, BuildContext context,
      {required bool isAddCamp}) {
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
            Text(
              region,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 18,
                color: status == 'Status: In Camp' ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Select a Camp',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              items: camps.map((String camp) {
                return DropdownMenuItem<String>(
                  value: camp,
                  child: Text(camp),
                );
              }).toList(),
              onChanged: (String? newValue) {
                // Handle camp selection
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isAddCamp) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CampRequirementsScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PeopleAddScreen()),
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
                child:
                    const Text('Volunteer Now', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
