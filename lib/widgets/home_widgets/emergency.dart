import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// function for direct emergency calling
_callNumber(String number) async{
  await FlutterPhoneDirectCaller.callNumber(number);
}

// function to create emergency number card
Widget emergencyCard(String imagePath, String emergencyNumber, String helplineName, String helplineService, {var helplineNameFontSize = 25.0, var emergencyNumberFontSize = 20.0, var emergencyNumberBGWidth = 70.0}) {
  return Card(
    elevation: 3,
    color: Colors.white,

    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: InkWell(
      onTap: () {
        _callNumber(emergencyNumber);
      },
      child: Container(
        margin: EdgeInsets.all(0.5),
        width: 215,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff863aff), Color(0xff9883ea)]
            ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // for image and emergency number
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.4),
                    child: Image.asset(
                      imagePath,
                      width: 40,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.all(5.0),
                    height: 30,
                    width: emergencyNumberBGWidth,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.call, color: Colors.deepPurple,),
                        Center(
                          child: Text(
                            emergencyNumber,
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                              fontSize: emergencyNumberFontSize,
                              fontFamily: 'EBGaramond-Regular'
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // for helpline name and service
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // helpline name
                    Center(
                      child: Text(
                        helplineName,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NovaSlim-Regular',
                          fontSize: helplineNameFontSize,
                        ),
                      ),
                    ),

                    // helpline service
                    Center(
                      child: Text(
                        helplineService,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'PTSans-Regular',
                          fontSize: 11
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

// Emergency class to call all emergency widget
class Emergency extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 150,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                PoliceHelpLine(),
                FireBrigadeHelpLine(),
                AmbulanceHelpLine(),
                MedicalHelpLine(),
                AccidentsHelpLine(),
                NationalHelpLine(),
                WomenDomesticAbuseHelpLine(),
                WomenHelpLine(),
                ChildHelpLine(),
                NCWHelpLine(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Todo: 1. Police Helpline Number (100)
class PoliceHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/police.png", "100", "Police", "(Police Emergency Service)");
  }
}

// Todo: 2. Fire Helpline Number (101)
class FireBrigadeHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/fire_brigade.png", "101", "Fire Emergency", "(Fire & Rescue Service)");
  }
}

// Todo: 3. Ambulance Helpline Number (102)
class AmbulanceHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/ambulance.png", "102", "Ambulance", "(National Ambulance Service)");
  }
}

// Todo: 4. Medical Helpline Number (104)
class MedicalHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/medical_helpline.png", "104", "Medical Helpline", "(Health Advice Helpline Service)", helplineNameFontSize: 22.0);
  }
}

// Todo: 5. Accidents Helpline Number (108)
class AccidentsHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/accident.png", "108", "Accidents", "(Emergency Ambulance Service)");
  }
}

// Todo: 6. National Helpline Number (112)
class NationalHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/national_emergency.png", "112", "National Emergency Number", "(For Urgent Help)", helplineNameFontSize: 15.0);
  }
}

// Todo: 7. Women Helpline Number (181)
class WomenDomesticAbuseHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/women_domestic_helpline.png", "181", "Women Helpline", "(For Domestic Abuse)");
  }
}

// Todo: 8. Women Helpline Number (1091)
class WomenHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/women_helpline.png", "1091", "Women Helpline", "(A Dedicated Police Helpline)");
  }
}

// Todo: 9. Child Helpline Number (1098)
class ChildHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/child_helpline.png", "1098", "Child Helpline", "(Child Care & Protection)");
  }
}

// Todo: 10. NCW Helpline Number (7827-170-170)
class NCWHelpLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return emergencyCard("assets/images/emergency_numbers/ncw.png", "7827-170-170", "NCW", "(National Commission for Women)", emergencyNumberFontSize: 15.0, emergencyNumberBGWidth: 110.0);
  }
}


