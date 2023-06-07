import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:v_safe/db/db_services.dart';
import 'package:v_safe/model/contact_model.dart';
import 'package:v_safe/pages/contact_screen.dart';
import 'package:v_safe/utils/constants.dart';
import 'package:v_safe/widgets/drawer_widgets/screen_drawer.dart';

class AddContactsScreen extends StatefulWidget {
  const AddContactsScreen({super.key});

  @override
  State<AddContactsScreen> createState() => _AddContactsScreenState();
}

class _AddContactsScreenState extends State<AddContactsScreen> {
  Future<bool> _onPop() async {
    goTo(context, const DrawerScreen());
    return true;
  }

  // Position? _currentPosition;
  LocationPermission? permission;


  _getPermission() async => await Permission.sms.request();
  _isPermissionGranted() async => await Permission.sms.isGranted;

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

  String lat = "";
  String long = "";

  _getLatLong() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    long = position.longitude.toString();
    lat = position.latitude.toString();
  }

  // _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSMS(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(
            phoneNumber: phoneNumber, message: message, simSlot: simSlot)
        .then((SmsStatus status) {});
  }


  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "permission denied");
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "permission permanently denied");
      }
    }

    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true
    ).catchError((e){
      Fluttertoast.showToast(msg: e.toString());
      return e;
    });
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getPermission();
    _getLatLong();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
  }


  void showList() {
    Future<Database> dbFuture = dataBaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContactModel>> contactListFuture =
          dataBaseHelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          contactList = value;
          count = value.length;
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
  Widget build(BuildContext context) {
    contactList ??= [];

    return WillPopScope(
      onWillPop: _onPop,
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xfff9d2cf).withOpacity(0.5),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    bool result = await Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ContactScreen();
                    }));

                    if (result == true) {
                      showList();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Trusted Contacts"),
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
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          child: Card(
                            elevation: 3.5,
                            color: const Color(0xfff5efff),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(color: Colors.grey, width: 1)),
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
                                            _getLatLong();

                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    elevation: 20,
                                                    shadowColor: Colors.deepPurple.withOpacity(0.5),
                                                    backgroundColor: Colors.deepPurple[100],
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(32.0))
                                                    ),
                                                    title: Row(
                                                      children: const [
                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Icon(Icons.emergency_share, color: Color(0xff6a1010), size: 30,),
                                                        ),

                                                        Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Text("Are you in Trouble?", style: TextStyle(color: Color(0xff6a1010)),),
                                                        )
                                                      ],
                                                    ),

                                                    content: Text("Do you really want to send an alert SOS message on ${contactList![index].number} ?"),

                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("Cancel", style: TextStyle(color: Colors.green[900]),)
                                                      ),

                                                      TextButton(
                                                          onPressed: () async {
                                                            Navigator.of(context).pop(true);

                                                            String messageBody = "https://www.google.com/maps/search/?api=1&query=$lat%2C$long";
                                                            if (await _isPermissionGranted()) {
                                                              _sendSMS(contactList![index].number, "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody", simSlot: 1);

                                                              Fluttertoast.showToast(
                                                                  msg:"message sent successfully");
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg:"Something went wrong!");
                                                            }
                                                          },
                                                          child: const Text("Send", style: TextStyle(color: Color(0xff6a1010)),))
                                                    ],
                                                  );
                                                }
                                            );
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
