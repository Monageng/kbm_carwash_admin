import 'package:flutter/material.dart';

class SuggestionBoxExample extends StatefulWidget {
  @override
  _SuggestionBoxExampleState createState() => _SuggestionBoxExampleState();
}

class _SuggestionBoxExampleState extends State<SuggestionBoxExample> {
  final List<String> searchTerms = [
    'Apple',
    'Banana',
    'Cherry',
    'Date',
    'Elderberry',
    'Fig',
    'Grape',
    'Honeydew',
  ];
  List<String> filteredTerms = [];

  void _filterSearchResults(String query) {
    List<String> dummySearchList = [];
    dummySearchList.addAll(searchTerms);
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredTerms.clear();
        filteredTerms.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredTerms.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suggestion Box Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Colors.black),
              onChanged: (value) {
                _filterSearchResults(value);
              },
              decoration: const InputDecoration(
                fillColor: Colors.amber,
                labelText: "Search",
                hintText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredTerms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredTerms[index],
                        style: TextStyle(color: Colors.red)),
                    onTap: () {
                      // Handle the suggestion tap, if necessary
                      print('Selected: ${filteredTerms[index]}');
                    },
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
