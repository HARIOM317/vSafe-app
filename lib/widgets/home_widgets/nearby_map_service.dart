import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

// function to create nearby service button
Widget createNearbyWidget(String path, String text){
  return Padding(
    padding: const EdgeInsets.only(top: 8, bottom: 8, left: 2.5, right: 2.5),
    child: SizedBox(
      width: 80,
      child: Column(
        children: [
          Card(
            color: Color(0xffddd6f3),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 55,
              width: 55,
              child: Center(
                child: Image.asset(path, fit: BoxFit.cover, height: 40,),
              ),
            ),
          ),
          Text(text, style: TextStyle(fontFamily: 'PTSans-Regular', fontSize: 12, fontWeight: FontWeight.bold),)
        ],
      ),
    ),
  );
}

class NearbyMapService extends StatelessWidget{
  static Future<void> openMap(String location) async{
    String googleUrl = "https://www.google.com/maps/search/$location";
    final Uri _url = Uri.parse(googleUrl);
    try{
      await launchUrl(_url);
    } catch (e){
      Fluttertoast.showToast(msg: "Something went wrong! call emergency number");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NearbyPoliceStation(onMapFunction: openMap,),
              NearbyHospital(onMapFunction: openMap),
              NearbyPharmacy(onMapFunction: openMap),
              NearbyBusStation(onMapFunction: openMap),
            ],
          ),
        ),
      ),
    );
  }
}


class NearbyPoliceStation extends StatelessWidget{
  final Function? onMapFunction;
  const NearbyPoliceStation({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onMapFunction!('police stations near me');
      },
      child: createNearbyWidget("assets/images/nearby_service/police_station.png", "Police Stations")
    );
  }
}

class NearbyHospital extends StatelessWidget{
  final Function? onMapFunction;
  const NearbyHospital({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onMapFunction!('hospitals near me');
        },
        child: createNearbyWidget("assets/images/nearby_service/hospital.png", "Hospitals")
    );
  }
}

class NearbyPharmacy extends StatelessWidget{
  final Function? onMapFunction;
  const NearbyPharmacy({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onMapFunction!('pharmacies near me');
        },
        child: createNearbyWidget("assets/images/nearby_service/pharmacy.png", "Pharmacy")
    );
  }
}

class NearbyBusStation extends StatelessWidget{
  final Function? onMapFunction;
  const NearbyBusStation({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onMapFunction!('bus stops near me');
        },
        child: createNearbyWidget("assets/images/nearby_service/bus_station.png", "Bus Stations")
    );
  }
}