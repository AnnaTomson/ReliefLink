import 'package:flutter/material.dart';

class CampHelpScreen extends StatefulWidget {
  const CampHelpScreen({super.key});

  @override
  _CampHelpScreenState createState() => _CampHelpScreenState();
}

class _CampHelpScreenState extends State<CampHelpScreen> {
  final List<DonationItem> donationItems = [
    DonationItem(
      name: 'Bottled Water',
      description: '1 liter bottles, pack of 12',
      icon: Icons.local_drink,
      requiredQuantity: 100,
    ),
    DonationItem(
      name: 'Blankets',
      description: 'Warm, fleece blankets',
      icon: Icons.bed,
      requiredQuantity: 50,
    ),
    DonationItem(
      name: 'First Aid Kit',
      description: 'Basic medical supplies',
      icon: Icons.medical_services,
      requiredQuantity: 30,
    ),
    DonationItem(
      name: 'Canned Food',
      description: 'Non-perishable food items',
      icon: Icons.fastfood,
      requiredQuantity: 200,
    ),
    DonationItem(
      name: 'Hygiene Kit',
      description: 'Soap, toothbrush, toothpaste, etc.',
      icon: Icons.cleaning_services,
      requiredQuantity: 75,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Donate to Relief Camps',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black26,
                offset: Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () {
              // Add info button functionality here
            },
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: donationItems.length,
            itemBuilder: (context, index) {
              return DonationItemTile(
                item: donationItems[index],
                onDonate: (int quantity) {
                  setState(() {
                    donationItems[index].requiredQuantity -= quantity;
                    if (donationItems[index].requiredQuantity < 0) {
                      donationItems[index].requiredQuantity = 0;
                    }
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class DonationItem {
  final String name;
  final String description;
  final IconData icon;
  int requiredQuantity;

  DonationItem({
    required this.name,
    required this.description,
    required this.icon,
    required this.requiredQuantity,
  });
}

class DonationItemTile extends StatefulWidget {
  final DonationItem item;
  final Function(int) onDonate;

  const DonationItemTile(
      {super.key, required this.item, required this.onDonate});

  @override
  _DonationItemTileState createState() => _DonationItemTileState();
}

class _DonationItemTileState extends State<DonationItemTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.item.requiredQuantity > 0
            ? () => _showDonationDialog(context)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.item.icon, color: Colors.teal, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.item.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.item.description,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Required: ${widget.item.requiredQuantity}',
                      style: TextStyle(
                          color: Colors.teal[700], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              widget.item.requiredQuantity > 0
                  ? ElevatedButton(
                      onPressed: () => _showDonationDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text('Donate'),
                    )
                  : const Icon(Icons.check_circle,
                      color: Colors.green, size: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showDonationDialog(BuildContext context) {
    int donationQuantity = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Donate ${widget.item.name}',
              style: const TextStyle(color: Colors.teal)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'How many ${widget.item.name.toLowerCase()} would you like to donate?'),
              const SizedBox(height: 8),
              Text(
                'Required: ${widget.item.requiredQuantity}',
                style: TextStyle(
                    color: Colors.teal[700], fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  labelText: 'Quantity',
                ),
                onChanged: (value) {
                  donationQuantity = int.tryParse(value) ?? 0;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (donationQuantity > 0) {
                  widget.onDonate(donationQuantity);
                  Navigator.of(context).pop();
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Thank you for donating $donationQuantity ${widget.item.name}!'),
                      backgroundColor: Colors.teal,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Donate'),
            ),
          ],
        );
      },
    );
  }
}
