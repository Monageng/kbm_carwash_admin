import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/common/widgets/widget_style.dart';
import 'package:kbm_carwash_admin/features/rewards/models/referal_model.dart';
import 'package:kbm_carwash_admin/features/rewards/services/reward_service.dart';

class ReferralListScreen extends StatefulWidget {
  ReferralListScreen({super.key});

  @override
  State<ReferralListScreen> createState() => _ReferralListScreenState();
}

class _ReferralListScreenState extends State<ReferralListScreen> {
  late Future<List<Referral>> _futureList;
  List<Referral> _referralList = [];
  List<Referral> _filteredReferralList = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    _searchController.addListener(() {
      _filterReferrals(_searchController.text);
    });
  }

  void getData() async {
    _futureList = RewardsApiService().getAllReferals();
    _futureList.then((data) {
      setState(() {
        _referralList = data;
        _filteredReferralList = data;
      });
    });
  }

  void _filterReferrals(String query) {
    final filtered = _referralList.where((referral) {
      return referral.referralCode
              ?.toLowerCase()
              .contains(query.toLowerCase()) ??
          false;
    }).toList();

    setState(() {
      _filteredReferralList = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search by Referral Code',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Referral>>(
                future: _futureList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (_filteredReferralList.isEmpty) {
                    return const Center(child: Text('No referrals available'));
                  } else {
                    return ListView.builder(
                      itemCount: _filteredReferralList.length,
                      itemBuilder: (context, index) {
                        final referral = _filteredReferralList[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Colors.blueAccent.withOpacity(0.2),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.blueAccent,
                                  size: 30,
                                ),
                              ),
                              title: Text(
                                referral.senderClient?.firstName ??
                                    'Unknown Sender',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Referred: ${referral.recipientClient?.firstName ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Code: ${referral.referralCode ?? 'Unavailable'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Date: ${referral.fromDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Status: ${referral.status ?? 'Unknown'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: referral.status == 'Active'
                                            ? Colors.green
                                            : Colors.redAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Description: ${referral.desciption ?? 'No description provided.'}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.blueAccent,
                                size: 18,
                              ),
                              onTap: () {
                                // Navigate to referral details if needed
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
