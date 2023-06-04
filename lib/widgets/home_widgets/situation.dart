import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:v_safe/db/db_services.dart';
import 'package:v_safe/model/contact_model.dart';

class Situation extends StatefulWidget {
  @override
  State<Situation> createState() => _SituationState();
}

class _SituationState extends State<Situation> {
  // variables for panic button
  double buttonRadius = 35;
  double shadowRadius = 30;
  Color shadowColor = Colors.white.withOpacity(0.5);
  Color buttonBG = Colors.white.withOpacity(0.5);
  Color iconColor = Color(0xffcc1840);
  Color textColor = Color(0xffcc1840);

  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? locationPermission;

  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSMS(String phoneNumber, String message, {int? simSlot}) async {
    await BackgroundSms.sendMessage(phoneNumber: phoneNumber, message: message, simSlot: simSlot);
  }

  _getCurrentLocation() async{
    locationPermission = await Geolocator.checkPermission();
    if(locationPermission == LocationPermission.denied){
      locationPermission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permission denied!");
      if(locationPermission == LocationPermission.deniedForever){
        Fluttertoast.showToast(msg: "Location permission permanently denied!");
      }
    }
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      forceAndroidLocationManager: true
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLong();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLong() async{
    try{
      List<Placemark> placeMarks = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);

      Placemark place = placeMarks[0];
      setState(() {
        _currentAddress = "${place.locality.toString()}, ${place.subLocality.toString()}, ${place.street.toString()}, ${place.postalCode.toString()}";
      });
    } catch(e){
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Column(
        children: [
          // Todo: Panic situation
          Center(
            child: Container(
              height: 120,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.deepPurple.withOpacity(0.5),
                      Colors.indigoAccent.withOpacity(0.7)
                    ]),
                border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(1.5, 2),
                      color: Colors.blueAccent.withOpacity(0.6))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Panic Situation",
                    style: TextStyle(
                        fontFamily: 'Courgette-Regular',
                        color: Colors.white,
                        fontSize: 18),
                  ),

                  // Panic Button
                  GestureDetector(
                    onTap: (){
                      setState(() {
                          buttonRadius = 40;
                          buttonBG = Color(0xffff5722);
                          iconColor = Colors.white;
                          textColor = Colors.white;
                          shadowColor = Colors.deepOrange.withOpacity(0.5);
                          shadowRadius = 50;
                      });

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
                                    child: Text("Are you in Danger?", style: TextStyle(color: Color(0xff6a1010)),),
                                  )
                                ],
                              ),

                              content: const Text("Do you really want to send an alert SOS message to all trusted contacts?"),

                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        buttonRadius = 35;
                                        shadowRadius = 30;
                                        shadowColor = Colors.white.withOpacity(0.5);
                                        buttonBG = Colors.white.withOpacity(0.5);
                                        iconColor = Color(0xffcc1840);
                                        textColor = Color(0xffcc1840);
                                      });
                                    },
                                    child: Text("Cancel", style: TextStyle(color: Colors.green[900]),)
                                ),

                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop(true);

                                      List<TContactModel> contactList = await DataBaseHelper().getContactList();
                                      String recipients = "";
                                      int i = 1;
                                      for(TContactModel contact in contactList){
                                        recipients += contact.number;
                                        if(i != contactList.length){
                                          recipients += ";";
                                          i++;
                                        }
                                      }

                                      String messageBody = "https://www.google.com/maps/search/?api=1&query=$_currentAddress";
                                      if(await _isPermissionGranted()) {
                                        for (var element in contactList) {
                                          _sendSMS(element.number, "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody", simSlot: 1);
                                        }
                                        Fluttertoast.showToast(msg: "SOS alert sent successfully!");
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: "Something went wrong!");
                                      }
                                      setState(() {
                                        buttonRadius = 35;
                                        shadowRadius = 30;
                                        shadowColor = Colors.white.withOpacity(0.5);
                                        buttonBG = Colors.white.withOpacity(0.5);
                                        iconColor = Color(0xffcc1840);
                                        textColor = Color(0xffcc1840);
                                      });
                                    },
                                    child: const Text("Send", style: TextStyle(color: Color(0xff6a1010)),))
                              ],
                            );
                          }
                      );
                    },

                    onLongPress: () {
                      setState(() {
                        buttonRadius = 40;
                        buttonBG = Color(0xffff5722);
                        iconColor = Colors.white;
                        textColor = Colors.white;
                        shadowColor = Colors.deepOrange.withOpacity(0.5);
                        shadowRadius = 50;
                      });

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
                                    child: Text("Are you in Danger?", style: TextStyle(color: Color(0xff6a1010)),),
                                  )
                                ],
                              ),

                              content: const Text("Do you really want to send an alert SOS message to all trusted contacts?"),

                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        buttonRadius = 35;
                                        shadowRadius = 30;
                                        shadowColor = Colors.white.withOpacity(0.5);
                                        buttonBG = Colors.white.withOpacity(0.5);
                                        iconColor = Color(0xffcc1840);
                                        textColor = Color(0xffcc1840);
                                      });
                                    },
                                    child: Text("Cancel", style: TextStyle(color: Colors.green[900]),)
                                ),

                                TextButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop(true);

                                      List<TContactModel> contactList = await DataBaseHelper().getContactList();
                                      String recipients = "";
                                      int i = 1;
                                      for(TContactModel contact in contactList){
                                        recipients += contact.number;
                                        if(i != contactList.length){
                                          recipients += ";";
                                          i++;
                                        }
                                      }

                                      String messageBody = "https://www.google.com/maps/search/?api=1&query=$_currentAddress";
                                      if(await _isPermissionGranted()) {
                                        for (var element in contactList) {
                                          _sendSMS(element.number, "I am in trouble! Please try to reach me as soon as possible.\nMy current location is $messageBody", simSlot: 1);
                                        }
                                        Fluttertoast.showToast(msg: "SOS alert sent successfully!");
                                      }
                                      else{
                                        Fluttertoast.showToast(msg: "Something went wrong!");
                                      }
                                      setState(() {
                                        buttonRadius = 35;
                                        shadowRadius = 30;
                                        shadowColor = Colors.white.withOpacity(0.5);
                                        buttonBG = Colors.white.withOpacity(0.5);
                                        iconColor = Color(0xffcc1840);
                                        textColor = Color(0xffcc1840);
                                      });
                                    },
                                    child: const Text("Send", style: TextStyle(color: Color(0xff6a1010)),))
                              ],
                            );
                          }
                      );
                    },

                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: shadowRadius,
                                // blurRadius: 50,
                                offset: const Offset(0, 2),
                                color: shadowColor
                                // color: Colors.deepOrange.withOpacity(0.5)
                            )
                          ]),
                      child: CircleAvatar(
                        radius: buttonRadius,
                        // radius: 40,
                        backgroundColor: buttonBG,
                        // backgroundColor: Colors.deepOrange[500],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.emergency_share_sharp,
                              color: iconColor,
                              // color: Colors.white,
                            ),
                            Text(
                              "SOS",
                              style: TextStyle(
                                  color: textColor,
                                  // color: Colors.white,
                                  fontFamily: 'NovaSlim-Regular',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // Todo: Feel Unsafe situation
          Center(
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5),
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigoAccent.withOpacity(0.7),
                      Colors.deepPurple.withOpacity(0.5)
                    ]),
                border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 3,
                      offset: const Offset(1.5, 2),
                      color: Colors.blueAccent.withOpacity(0.6))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Feel Unsafe',
                      style: TextStyle(
                          fontFamily: 'Courgette-Regular',
                          color: Colors.white,
                          fontSize: 18),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Record Surrounding Button
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 62,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 15,
                                          offset: const Offset(0, 2),
                                          color: Colors.white.withOpacity(0.5))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.video,
                                      color: Color(0xff003c6b),
                                      size: 20,
                                    ),
                                    Text(
                                      "Record Surrounding",
                                      style: TextStyle(
                                          color: Color(0xff003c6b),
                                          fontFamily: 'PTSans-Regular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Capture Surrounding Button
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 150,
                            height: 62,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 15,
                                          offset: const Offset(0, 2),
                                          color: Colors.white.withOpacity(0.5))
                                    ]),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.image,
                                      color: Color(0xff003c6b),
                                      size: 20,
                                    ),
                                    Text(
                                      "Capture Surrounding",
                                      style: TextStyle(
                                          color: Color(0xff003c6b),
                                          fontFamily: 'PTSans-Regular',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
