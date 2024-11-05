import 'package:flutter/material.dart';

class Referral {
  final String referrerName;
  final String referredName;
  final String referralCode;
  final DateTime referralDate;

  Referral({
    required this.referrerName,
    required this.referredName,
    required this.referralCode,
    required this.referralDate,
  });
}

class ReferralListScreen extends StatelessWidget {
  final List<Referral> referrals = [
    Referral(
      referrerName: 'John Doe',
      referredName: 'Jane Smith',
      referralCode: 'ABC123',
      referralDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Referral(
      referrerName: 'Alex Johnson',
      referredName: 'Chris Lee',
      referralCode: 'XYZ789',
      referralDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
    // Add more Referral objects here as needed
  ];

  ReferralListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: referrals.length,
          itemBuilder: (context, index) {
            final referral = referrals[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.blueAccent,
                  size: 40,
                ),
                title: Text(
                  referral.referrerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Referred: ${referral.referredName}'),
                    Text('Code: ${referral.referralCode}'),
                    Text(
                      'Date: ${referral.referralDate.toLocal()}'.split(' ')[0],
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.blue,
                  size: 16,
                ),
                onTap: () {
                  // Navigate to referral details if needed
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
