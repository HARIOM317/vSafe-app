// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:v_safe/utils/constants.dart';
// import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';
//
// class NetworkScreen extends StatefulWidget{
//   @override
//   State<NetworkScreen> createState() => _NetworkScreenState();
// }
//
// class _NetworkScreenState extends State<NetworkScreen> {
//   Future<bool> _onPop() async {
//     goTo(context, DrawerScreen());
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onPop,
//
//       child: Scaffold(
//         body: Container(
//           decoration: BoxDecoration(
//             color: Color(0xfff9d2cf).withOpacity(0.5),
//           ),
//
//           child: Center(
//               child: Text("Network Page")
//           ),
//         ),
//       ),
//     );
//   }
// }






// // todo ------------------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  var fireStoreDB = FirebaseFirestore.instance.collection('users').snapshots();

  final key = GlobalKey<FormState>();
  String? id;
  String profilePic = "";
  bool isSaving = false;

  TextEditingController nameController = TextEditingController();

  // function to get user image from database
  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.docs.first['name'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9d2cf).withOpacity(0.5),
        body: StreamBuilder(
            stream: fireStoreDB,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      elevation: 3.5,
                      color: const Color(0xfff5efff),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: const SizedBox(
                            height: 70,
                            child: CircleAvatar(
                              radius: 60,
                              // backgroundImage: NetworkImage(snapshot.data?.docs[index]["profilePic"]),
                              // backgroundImage: NetworkImage(profilePic),
                              child: Icon(Icons.person),
                            ),
                          ),

                          title: Text(snapshot.data!.docs[index]['name']),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                          ),
                        ),
                      ),
                    );
                  });
            }));
  }
}
