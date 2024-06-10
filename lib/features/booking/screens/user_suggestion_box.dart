import 'package:flutter/material.dart';
import 'package:kbm_carwash_admin/features/users/models/user_model.dart';

import '../../users/services/car_wash_api_service.dart';

class UserSearchExample extends StatefulWidget {
  @override
  _UserSearchExampleState createState() => _UserSearchExampleState();
}

class _UserSearchExampleState extends State<UserSearchExample> {
  List<UserModel> userList = [];
  List<String?> searchUserList = [];

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    List<UserModel> fetchedUsers = await UserApiService().getAllUsers();
    setState(() {
      userList = fetchedUsers;
      searchUserList = userList.map((e) => e.firstName).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              // Your search logic here
            },
            decoration: const InputDecoration(
              labelText: 'Search Users',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchUserList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(searchUserList[index]!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
