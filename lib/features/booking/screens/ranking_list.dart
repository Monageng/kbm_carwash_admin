import 'package:flutter/material.dart';

import '../../../session/app_session.dart';
import '../../franchise/models/franchise_model.dart';
import '../models/appointment_model.dart';
import '../models/rank_model.dart';
import '../services/book_appointment_service.dart';

class RankOverviewScreen extends StatefulWidget {
  RankOverviewScreen({super.key, required this.franchise});

  Franchise franchise;

  @override
  createState() => _RankOverviewScreenState();
}

class _RankOverviewScreenState extends State<RankOverviewScreen> {
  late Future<List<RankModel>>? rankingListFuture;

  @override
  void initState() {
    super.initState();
    rankingListFuture = fetchRankingData();

    rankingListFuture!.then((data) {
      setState(() {});
    });
  }

  Future<List<RankModel>> fetchRankingData() async {
    List<Appointment> appointmentList = await BookAppointmentApiService()
        .getAllAppointmentForRankinsByFranchiseId(
            AppSessionModel().loggedOnUser!.franchise!.id);
    List<RankModel> rankingList = [];

    if (appointmentList.isNotEmpty) {
      for (var appointment in appointmentList) {
        RankModel? existingRank = rankingList.firstWhere(
          (rank) =>
              rank.firstName == appointment.client!.firstName &&
              rank.lastName == appointment.client!.lastName,
          orElse: () => RankModel(),
        );

        if (existingRank.firstName != null && existingRank.lastName != null) {
          existingRank.count = (existingRank.count ?? 0) + 1;
        } else {
          RankModel newRank = RankModel(
            firstName: appointment.client!.firstName,
            lastName: appointment.client!.lastName,
            count: 1,
          );
          rankingList.add(newRank);
        }
      }

      rankingList.sort((a, b) => (b.count ?? 0).compareTo(a.count ?? 0));

      for (int i = 0; i < rankingList.length; i++) {
        rankingList[i].rank = i + 1;
      }

      rankingList.firstWhere(
        (rank) =>
            rank.firstName == AppSessionModel().loggedOnUser!.firstName &&
            rank.lastName == AppSessionModel().loggedOnUser!.lastName,
        orElse: () => RankModel(),
      );
    }
    return rankingList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking Leaderboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<RankModel>>(
          future: rankingListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No rankings available.'),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var ranking = snapshot.data![index];
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
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          child: const Icon(
                            Icons.star,
                            color: Colors.blueAccent,
                            size: 30,
                          ),
                        ),
                        title: Text(
                          "${ranking.rank}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
                                '${ranking.firstName}  ${ranking.lastName}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Washed : ${ranking.count ?? 'Unavailable'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Washed : ${ranking.count ?? 'Unavailable'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const SizedBox(height: 2),
                              Text(
                                'From: ${ranking.fromDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'To Date: ${ranking.toDate?.toLocal().toString().split(' ')[0] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              // const SizedBox(height: 2),
                              // Text(
                              //   'Status: ${referral.status ?? 'Unknown'}',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     color: referral.status == 'Active'
                              //         ? Colors.green
                              //         : Colors.redAccent,
                              //   ),
                              // ),
                              // const SizedBox(height: 2),
                              // Text(
                              //   'Description: ${referral.desciption ?? 'No description provided.'}',
                              //   style: const TextStyle(
                              //     fontSize: 14,
                              //     color: Colors.black54,
                              //   ),
                              // ),
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
              // return PaginatedDataTable(
              //   showFirstLastButtons: true,
              //   arrowHeadColor: Colors.black,
              //   sortAscending: _sortAscending,
              //   sortColumnIndex: _sortColumnIndex,
              //   onPageChanged: (value) {},
              //   header: const Text(
              //     "Leaderboard",
              //     style: TextStyle(
              //       fontWeight: FontWeight.bold,
              //       fontSize: 18,
              //       color: Colors.black,
              //     ),
              //   ),
              //   columns: const [
              //     DataColumn(
              //       label: Text('Rank'),
              //     ),
              //     DataColumn(
              //       label: Text('First Name'),
              //     ),
              //     DataColumn(
              //       label: Text('Last Name'),
              //     ),
              //     DataColumn(
              //       label: Text('Washes'),
              //     ),
              //   ],
              //   source: _rankingDataSource,
              //   columnSpacing: 20,
              //   availableRowsPerPage: availableRowsPerPage2,
              //   onRowsPerPageChanged: (int? value) {},
              //   rowsPerPage:
              //       snapshot.data!.length < 10 ? snapshot.data!.length : 10,
              //   headingRowColor:
              //       WidgetStateColor.resolveWith((states) => Colors.blueAccent),
              //   // headingTextStyle: const TextStyle(
              //   //   color: Colors.white,
              //   //   fontWeight: FontWeight.bold,
              //   // ),
              //   // dataRowColor: WidgetStateProperty.resolveWith(
              //   //   (Set<MaterialState> states) {
              //   //     if (states.contains(MaterialState.selected)) {
              //   //       return Colors.blue.withOpacity(0.1);
              //   //     }
              //   //     return Colors.transparent;
              //   //   },
              //   // ),
              // );
            }
          },
        ),
      ),
    );
  }
}

// Data source for PaginatedDataTable
class RankingDataSource extends DataTableSource {
  final List<RankModel> _rankings;

  RankingDataSource(this._rankings);

  @override
  DataRow getRow(int index) {
    final rankModel = _rankings[index];
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${rankModel.rank}')),
        DataCell(Text(rankModel.firstName ?? 'N/A')),
        DataCell(Text(rankModel.lastName ?? 'N/A')),
        DataCell(Text('${rankModel.count}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rankings.length;

  @override
  int get selectedRowCount => 0;
}
