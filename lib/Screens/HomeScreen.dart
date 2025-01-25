import 'dart:ui';
import 'package:flutter/material.dart';
import 'Payment.dart'; // Import the Payment screen
import 'SubScreens/Volunteer.dart'; // Import the Volunteer screen
import 'SubScreens/Donor.dart'; // Import the Donor screen
import 'SubScreens/ReceiverEnquiry.dart'; // Import the ReceiverEnquiry screen
import 'loginScreen.dart'; // Import the login screen
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final double _maxSlide = 255.0;
  final double _minDragStartEdge = 60;
  final double _maxDragStartEdge = 180;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth
  User? _user; // Store the current user
  String _userName = ""; // Default name
  String _userEmail = ""; // Default email

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _user = _auth.currentUser; // Get the current user
    _fetchUserData(); // Fetch user data from Firebase Auth
  }

  void _fetchUserData() {
    if (_user != null) {
      setState(() {
        _userName = _user!.displayName ?? "User";
        _userEmail = _user!.email ?? "No email";
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = _animationController.isDismissed &&
        details.globalPosition.dx < _minDragStartEdge;
    bool isDragCloseFromRight = _animationController.isCompleted &&
        details.globalPosition.dx > _maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / _maxSlide;
      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  bool _canBeDragged = false;

  // New function to navigate to the Payment screen
  void _navigateToPayment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaymentScreen()),
    );
  }

  // New function to navigate to the Volunteer screen
  /*void _navigateToVolunteer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VolunteerScreen()),
    );
  }

  // New function to navigate to the Donor screen
  void _navigateToDonor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DonorScreen()),
    );
  }

  // New function to navigate to the ReceiverEnquiry screen
  void _navigateToReceiverEnquiry() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ReceiverEnquiryScreen()),
    );
  }*/

  // New function to navigate to the Login screen
  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LogInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Material(
            color: Colors.teal, // Set the background color to match the drawer
            child: Stack(
              children: [
                _buildDrawer(),
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(_maxSlide * _animation.value)
                    ..scale(1 - (0.3 * _animation.value)),
                  child: Stack(
                    children: [
                      // Add a low transparent shadow of the home screen to its left
                      Positioned(
                        left: -10,
                        top: 0,
                        bottom: 0,
                        width: 10,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 5,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _animationController.isCompleted
                            ? _toggleDrawer
                            : null,
                        child: _buildMainContent(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return SizedBox(
      width: _maxSlide,
      child: Drawer(
        child: Container(
          color: Colors.teal,
          child: SafeArea(
            child: Theme(
              data: ThemeData(brightness: Brightness.dark),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userName, // Use the user's name from Firebase Auth
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _userEmail, // Use the user's email from Firebase Auth
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.white30),
                  _buildDrawerItem(Icons.create, "Create Fund"),
                  _buildDrawerItem(Icons.person, "Profile"),
                  _buildDrawerItem(Icons.settings, "Settings"),
                  _buildDrawerItem(Icons.history, "History"),
                  _buildDrawerItem(Icons.payment, "Payment"),
                  //_buildDrawerItem(Icons.info_outline, "Receiver Enquiry",
                  //onTap: _navigateToReceiverEnquiry),
                  _buildDrawerItem(Icons.help, "Help & FAQ"),
                  const Spacer(),
                  const Divider(color: Colors.white30),
                  _buildDrawerItem(Icons.exit_to_app, "Log Out",
                      onTap: _navigateToLogin),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 28),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap ??
          () {
            // Handle item tap
            _toggleDrawer();
          },
    );
  }

  Widget _buildMainContent() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.teal),
          onPressed: _toggleDrawer,
        ),
        title: const Text(
          'Relief Link',
          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.teal),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Start Your Own Funding Section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: _buildFundingSection(),
            ),

            // Category Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildCategorySection(),
            ),

            // Popular Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildPopularSection(),
            ),

            // Donation Cards
            _buildDonationCard(
              title: 'Wayanad Flood Relief Fund',
              organization: 'By Kerala State Disaster Management Authority',
              amountRaised: 'Rs 7,530.65',
              targetAmount: 'Rs 15,000',
            ),
            _buildDonationCard(
              title: 'Help for Flood Affected Families in Kerala',
              organization: 'By Kerala State Disaster Management Authority',
              amountRaised: 'Rs 12,000.00',
              targetAmount: 'Rs 20,000',
            ),
            _buildDonationCard(
              title: 'Help for Tsunami Affected Families in Kerala',
              organization: 'By Kerala State Disaster Management Authority',
              amountRaised: 'Rs 5,750.00',
              targetAmount: 'Rs 10,000',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFundingSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal, Colors.tealAccent],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Make a Difference',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start Your Own Fundraising Campaign',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            icon: const Icon(Icons.add_circle_outline),
            label: const Text(
              'Create Campaign',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*CategoryWidget(
              title: 'Volunteer',
              icon: Icons.volunteer_activism,
              color: Colors.teal,
              onPressed: _navigateToVolunteer,
            ),
            CategoryWidget(
              title: 'Donor',
              icon: Icons.favorite,
              color: Colors.red[400]!,
              onPressed: _navigateToDonor,
            ),*/
          ],
        ),
      ],
    );
  }

  Widget _buildPopularSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Campaigns',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See All',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildDonationCard({
    required String title,
    required String organization,
    required String amountRaised,
    required String targetAmount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: DonationCard(
        title: title,
        organization: organization,
        amountRaised: amountRaised,
        targetAmount: targetAmount,
        onDonatePressed: _navigateToPayment, // Pass the navigation function
      ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const CategoryWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class DonationCard extends StatelessWidget {
  final String title;
  final String organization;
  final String amountRaised;
  final String targetAmount;
  final VoidCallback onDonatePressed; // Add this line

  const DonationCard({
    super.key,
    required this.title,
    required this.organization,
    required this.amountRaised,
    required this.targetAmount,
    required this.onDonatePressed, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal, Colors.tealAccent],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              organization,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: double.parse(
                      amountRaised.replaceAll(RegExp(r'[^\d.]'), '')) /
                  double.parse(targetAmount.replaceAll(RegExp(r'[^\d.]'), '')),
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$amountRaised Raised',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Goal: $targetAmount',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onDonatePressed, // Use the callback here
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Center(
                child: Text(
                  'Donate Now',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
