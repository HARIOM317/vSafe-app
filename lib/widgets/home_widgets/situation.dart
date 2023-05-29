import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Situation extends StatelessWidget{
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
              margin: EdgeInsets.only(left: 5, right: 5, top: 2.5, bottom: 2.5),

              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), topLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.deepPurple.withOpacity(0.5), Colors.indigoAccent.withOpacity(0.7)]
                  ),
                  border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(blurRadius: 3, offset: const Offset(1.5, 2), color: Colors.blueAccent.withOpacity(0.6))
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Panic Situation", style: TextStyle(
                      fontFamily: 'Courgette-Regular',
                      color: Colors.white,
                      fontSize: 18
                  ),
                  ),

                  // Panic Button
                  InkWell(
                    onTap: (){
                      print("Hello");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(blurRadius: 30, offset: const Offset(0, 2), color: Colors.white.withOpacity(0.5))
                        ]
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.emergency_share_sharp, color: Color(0xffcc1840),),
                            Text("SOS", style: TextStyle(
                              color: Color(0xffcc1840),
                              fontFamily: 'NovaSlim-Regular',
                              fontWeight: FontWeight.bold,
                              fontSize: 22
                            ),
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
                  borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15), topLeft: Radius.circular(5), bottomRight: Radius.circular(5)),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.indigoAccent.withOpacity(0.7), Colors.deepPurple.withOpacity(0.5)]
                  ),
                  border: Border.all(width: 1, color: Colors.white),
                boxShadow: [
                  BoxShadow(blurRadius: 3, offset: const Offset(1.5, 2), color: Colors.blueAccent.withOpacity(0.6))
                ],
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Feel Unsafe', style: TextStyle(
                        fontFamily: 'Courgette-Regular',
                        color: Colors.white,
                        fontSize: 18
                    ),),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Record Surrounding Button
                      InkWell(
                        onTap: () {

                        },

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20)
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(blurRadius: 15, offset: const Offset(0, 2), color: Colors.white.withOpacity(0.5))
                                  ]
                                ),
                                child: Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.video, color: Color(0xff003c6b), size: 20,),
                                    Text("Record Surrounding", style: TextStyle(
                                        color: Color(0xff003c6b),
                                        fontFamily: 'PTSans-Regular',
                                        fontWeight: FontWeight.bold,
                                      fontSize: 13
                                    ),
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
                        onTap: () {

                        },

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 130,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(blurRadius: 15, offset: const Offset(0, 2), color: Colors.white.withOpacity(0.5))
                                    ]
                                ),
                                child: Column(
                                  children: [
                                    FaIcon(FontAwesomeIcons.image, color: Color(0xff003c6b), size: 20,),
                                    Text("Capture Surrounding", style: TextStyle(
                                        color: Color(0xff003c6b),
                                        fontFamily: 'PTSans-Regular',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13
                                    ),
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