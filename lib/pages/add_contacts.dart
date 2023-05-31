import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_safe/components/primary_button.dart';
import 'package:v_safe/db/db_services.dart';
import 'package:v_safe/model/contact_model.dart';
import 'package:v_safe/pages/contact_screen.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class AddContactsScreen extends StatefulWidget {
  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  Future<bool> _onPop() async {
    goTo(context, DrawerScreen());
    return true;
  }

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<TContactModel>? contactList;
  int count = 0;

  void showList() {
    Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {

     Future<List<TContactModel>> contactListFuture =  dataBaseHelper.getContactList();
     contactListFuture.then((value) {
       setState(() {
         this.contactList = value;
         this.count = value.length;
       });
     });
    });
  }

  void deleteContact(TContactModel contact) async {
    int result = await dataBaseHelper.deleteContact(contact.id);
    if(result != 0){
      Fluttertoast.showToast(msg: "contact removed from trusted contact list");
      showList();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(contactList == null){
      contactList = [];
    }

    return WillPopScope(
      onWillPop: _onPop,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xfff9d2cf).withOpacity(0.5),
          ),
          child: Column(
            children: [
              PrimaryButton(title: "Add Trusted Contacts", onPressed: () async {
                bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ContactScreen();
                }));

                if(result == true) {
                  showList();
                }

              }),

              Expanded(
                child: ListView.builder(
                  // shrinkWrap: true,
                  itemCount: count,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        elevation: 4,
                        color: Color(0xffdcdfff),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(contactList![index].name),
                            trailing: Container(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      await FlutterPhoneDirectCaller.callNumber(contactList![index].number);
                                    },
                                    icon: Icon(Icons.call, color: Colors.green[900],),
                                  ),

                                  IconButton(
                                    onPressed: () {
                                      deleteContact(contactList![index]);
                                    },
                                    icon: Icon(Icons.delete, color: Colors.red[900],),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}