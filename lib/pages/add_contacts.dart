import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
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

  Future<void> _handleRefresh () async{
    // reloading takes some time
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
    return await Future.delayed(const Duration(seconds: 2));
  }

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<TContactModel>? contactList;
  int count = 0;

  final String _phoneNumber = "+91 8224826624";

  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSMS(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
            phoneNumber: phoneNumber, message: message, simSlot: simSlot)
        .then((SmsStatus status) {});
  }

  void showList() {
    Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContactModel>> contactListFuture =
          dataBaseHelper.getContactList();
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
    if (result != 0) {
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
    if (contactList == null) {
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    bool result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ContactScreen();
                    }));

                    if (result == true) {
                      showList();
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Trusted Contacts"),
                ),
              ),
              Expanded(
                child: LiquidPullToRefresh(
                  onRefresh: _handleRefresh,
                  color: Colors.transparent,
                  backgroundColor: Colors.deepPurple,
                  height: 300,
                  animSpeedFactor: 3,
                  showChildOpacityTransition: true,

                  child: ListView.builder(
                      itemCount: count,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          child: Card(
                            elevation: 3.5,
                            color: Color(0xfff5efff),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey, width: 1)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: ListTile(
                                title: Text(contactList![index].name),
                                trailing: SizedBox(
                                  width: 140,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await FlutterPhoneDirectCaller
                                                .callNumber(
                                                    contactList![index].number);
                                          },
                                          icon: Icon(
                                            Icons.call,
                                            color: Colors.green[900],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.question,
                                                animType: AnimType.scale,
                                                autoHide: const Duration(seconds: 5),
                                                transitionAnimationDuration: const Duration(milliseconds: 250),
                                                dialogBorderRadius: BorderRadius.circular(20),
                                                showCloseIcon: true,
                                                title: "Are you in trouble?",
                                                titleTextStyle: TextStyle(
                                                  color: Colors.red[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  fontFamily: 'PTSans-Regular'
                                                ),
                                                desc: "Do you really want to send an alert SOS message on ${contactList![index].number} ?",
                                                descTextStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Dosis-Regular'
                                                ),
                                                dismissOnTouchOutside: true,
                                                dismissOnBackKeyPress: true,
                                                // dialogBackgroundColor: const Color(0xffffe8d3),

                                                btnCancelOnPress: () {
                                                  dispose();
                                                },

                                                btnOkText: "Send",
                                                btnOkOnPress: () async {
                                                  String messageBody = "https://www.google.com/maps/search/?api=1&query=Ashoka+Garden+Bhopal";
                                                  if (await _isPermissionGranted()) {
                                                    _sendSMS(contactList![index].number, "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody", simSlot: 1);
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "message sent successfully");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Something went wrong!");
                                                  }
                                                  dispose();
                                                }).show();
                                          },
                                          icon: Icon(
                                            CupertinoIcons.chat_bubble_text_fill,
                                            color: Colors.blue[900],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            deleteContact(contactList![index]);
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red[900],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
