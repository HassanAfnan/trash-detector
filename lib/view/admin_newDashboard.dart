import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:registraron_screen/view/admin_dashboard.dart';
import 'package:registraron_screen/view/adminlogin.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/rejected.dart';
import 'package:registraron_screen/view/resolved_complains.dart';
import 'package:registraron_screen/view/trash_bin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_drawer.dart';
import 'welcomescreen.dart';

class Newadmindashboard extends StatefulWidget {
  @override
  _NewadmindashboardState createState() => _NewadmindashboardState();
}

class _NewadmindashboardState extends State<Newadmindashboard> {
  String allComplain = "";
  String rejected = "";
  String resolved = "";
  String trash = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const oneSec = const Duration(seconds:5);
    new Timer.periodic(oneSec, (Timer t){
      print("Called");
      getValues();
    });
  }

  getValues(){
    FirebaseFirestore.instance.collection("Trash").where("type",isEqualTo: FirebaseAuth.instance.currentUser.email).get().then((value){
      setState(() {
        allComplain = value.docs.length.toString();
      });
    }).whenComplete((){
      FirebaseFirestore.instance.collection("Rejected").get().then((value){
        setState(() {
          rejected = value.docs.length.toString();
        });
      }).whenComplete((){
        FirebaseFirestore.instance.collection("Resolved").get().then((value){
          setState(() {
            resolved = value.docs.length.toString();
          });
        }).whenComplete((){
            print("called");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
          child: Scaffold(
         drawer: buildCustomDrawer(_height, _width, context,setState),
            appBar: AppBar(
              title: Center(child: Text('Trash Admin')),
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('email');
                    prefs.remove('role');
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WelcomeScreen(),
                        ));
                  },
                )
              ],

            ),
          body: SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    // Image.asset("assets/image.png",width: 52.0,)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    "Welcome, Admin",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing: 30,
                    runSpacing: 30.0,
                    children: <Widget>[
                      SizedBox(
                        width: 160.0,
                        height: 190.0,
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Updatescreen() ) );

                          },
                                                child: Container(
                            child: Card(
                              elevation: 10.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Center(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Image.asset(
                                      "assets/todo.png",
                                      width: 64.0,
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "All Complains",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                                                          child: Text(
                                        "${allComplain} Items",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 190.0,
                        child: GestureDetector(
                           onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RejectedScreen() ) );

                          },
                                                  child: Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/note.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:25),
                                    child: Text(
                                      "Rejected Complains",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${rejected} Items",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 190.0,
                        child: GestureDetector(
                            onTap: ()
                          {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ResolvedScreen() ) );

                          },
                                                  child: Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/calendar.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Resolved Complains",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "${resolved} Items",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 160.0,
                        height: 190.0,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TrashBin()));
                          },
                          child: Card(
                            elevation: 10.0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "assets/settings.png",
                                    width: 64.0,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "Trash Bin",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    "1 Items",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))),
    );
  }
}
