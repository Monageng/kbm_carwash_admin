// import 'package:flutter/material.dart';
// import 'package:kbm_carwash_admin/features/users/services/car_wash_api_service.dart';

// import '../../users/models/user_model.dart';

// class ClientSuggestionDropboxExample extends StatefulWidget {
//   @override
//   _SuggestionDropboxExampleState createState() =>
//       _SuggestionDropboxExampleState();
// }

// class _SuggestionDropboxExampleState
//     extends State<ClientSuggestionDropboxExample> {
//   final List<String> searchTerms = [
//     'Apple',
//     'Banana',
//     'Cherry',
//     'Date',
//     'Elderberry',
//     'Fig',
//     'Grape',
//     'Honeydew',
//   ];

//   List<String> searchTermsList = [];
//   List<String> filteredTerms = [];
//   OverlayEntry? overlayEntry;
//   final LayerLink _layerLink = LayerLink();
//   final TextEditingController _controller = TextEditingController();

//   void _filterSearchResults(String query) {
//     if (query.isNotEmpty) {
//       List<String> dummyListData = searchTerms.where((term) {
//         return term.toLowerCase().contains(query.toLowerCase());
//       }).toList();

//       setState(() {
//         filteredTerms.clear();
//         filteredTerms.addAll(dummyListData);
//         _showOverlay();
//       });
//     } else {
//       setState(() {
//         filteredTerms.clear();
//         _removeOverlay();
//       });
//     }
//   }

//   void _showOverlay() {
//     print("_showOverlay ${filteredTerms}");
//     _removeOverlay();
//     if (filteredTerms.isNotEmpty) {
//       overlayEntry = _createOverlayEntry();
//       Overlay.of(context)?.insert(overlayEntry!);
//     }
//   }

//   void _removeOverlay() {
//     if (overlayEntry != null) {
//       overlayEntry!.remove();
//       overlayEntry = null;
//     }
//   }

//   OverlayEntry _createOverlayEntry() {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     var size = renderBox.size;

//     print("size $size");
//     return OverlayEntry(
//       builder: (context) => Positioned(
//         width: size.width,
//         child: CompositedTransformFollower(
//           link: _layerLink,
//           showWhenUnlinked: false,
//           //offset: Offset(0.0, size.height + 5.0),
//           child: Material(
//             elevation: 4.0,
//             child: ListView.builder(
//               padding: EdgeInsets.zero,
//               shrinkWrap: true,
//               itemCount: filteredTerms.length,
//               itemBuilder: (context, index) {
//                 print("index $index");
//                 print("filteredTerms dd ${filteredTerms[index]}");
//                 return ListTile(
//                   title: Text(filteredTerms[index],
//                       style: TextStyle(color: Colors.blue)),
//                   onTap: () {
//                     _controller.text = filteredTerms[index];

//                     _removeOverlay();
//                   },
//                 );
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     UserApiService().getAllUsers();
//   }

//   void getUsers() async {
//     Future<List<UserModel>> userFuture = UserApiService().getAllUsers();

//      setState(() {
//       userList = fetchedUsers;
//       searchUserList = userList.map((e) => e.firstName).toList();
//     });
//     List<UserModel> userList = await userFuture;
//     List<String> searchUserList= userList.map((e) => e.firstName).toList();
//   }

//   @override
//   void dispose() {
//     _removeOverlay();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var padding2 = Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: CompositedTransformTarget(
//         link: _layerLink,
//         child: TextField(
//           style: TextStyle(color: Colors.black),
//           controller: _controller,
//           onChanged: (value) {
//             _filterSearchResults(value);
//           },
//           decoration: const InputDecoration(
//             fillColor: Colors.red,
//             labelText: "Search",
//             hintText: "Search",
//             prefixIcon: Icon(Icons.search),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(25.0)),
//             ),
//           ),
//         ),
//       ),
//     );

//     return padding2;
//     // return Scaffold(
//     //   appBar: AppBar(
//     //     title: const Text('Suggestion Dropbox Example'),
//     //   ),
//     //   body: padding2,
//     // );
//   }
// }
