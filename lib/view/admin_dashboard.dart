
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/report_approval.dart';
import 'package:registraron_screen/view/welcomescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_drawer.dart';

class Updatescreen extends StatefulWidget {
  @override
  _UpdatescreenState createState() => _UpdatescreenState();
}

class _UpdatescreenState extends State<Updatescreen> {
  int _currentIndex = 0;
  List<String> ids = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const oneSec = const Duration(seconds:120);
    new Timer.periodic(oneSec, (Timer t){
      print("Called");
      getIds();
    });
    //getIds();
  }

  getIds(){
    FirebaseFirestore.instance.collection("Trash").get().then((value){
      value.docs.forEach((element) {
        //print(element.id);
         ids.add(element.id);
      });
      //print(ids.toString());
    }).whenComplete((){
      updateIDS();
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Alert"),
      //         content:
      //         Text('Do you want to move unresolved complains \n to higher authorities?'),
      //         actions: [
      //           FlatButton(
      //             onPressed: () {
      //               Navigator.pop(context);
      //             },
      //             color: Colors.blue,
      //             child: Text(
      //               "No",
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           ),
      //           FlatButton(
      //             onPressed: () {
      //               updateIDS();
      //             },
      //             color: Colors.red,
      //             child: Text(
      //               "Yes",
      //               style: TextStyle(color: Colors.white),
      //             ),
      //           )
      //         ],
      //       );
      //     });
    });
  }

  updateIDS(){
    ids.forEach((element) {
       print(element);
       FirebaseFirestore.instance.collection("Trash").doc(element).update({
         "type":"dmckarachiauth@gmail.com"
       }).whenComplete((){
         print("Updated");
       });
    });
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
          child: Scaffold(
        // drawer: buildCustomDrawer(_height, _width, context,setState),
          appBar: AppBar(
            centerTitle: true,
            title: Center(child: Text('COMPLAINS')),
            actions: [
              // IconButton(
              //   icon: Icon(Icons.exit_to_app),
              //   onPressed: () async {
              //     SharedPreferences prefs = await SharedPreferences.getInstance();
              //     prefs.remove('email');
              //     prefs.remove('role');
              //     FirebaseAuth.instance.signOut();
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) =>
              //               WelcomeScreen(),
              //         ));
              //   },
              // )
            ],
            
          ),
          body:StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Trash').where("type",isEqualTo: FirebaseAuth.instance.currentUser.email).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Text("Complains are loading...");
              return new ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(
                     Icons.location_on,
                     size: 30,
                     color:primary,
                      
                    ),
                    title: Text("Complain No: " +snapshot.data.docs[index].id,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: primary,
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReportApproval(
                            id: snapshot.data.docs[index].id,
                            lat: snapshot.data.docs[index]["latitude"],
                            long: snapshot.data.docs[index]["longitude"],
                            image: snapshot.data.docs[index]["url"],
                            email: snapshot.data.docs[index]["email"],
                            address: snapshot.data.docs[index]["address"],
                          )));
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) =>
                          //           MapsScreen(
                          //             email: snapshot.data.docs[index]["email"],
                          //             id: snapshot.data.docs[index].id,
                          //             lat: snapshot.data.docs[index]["latitude"],
                          //             long: snapshot.data.docs[index]["longitude"],
                          //             address: snapshot.data.docs[index]["address"],
                          //           ),
                          //     ));
                        }),
                    subtitle:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                         Row(
                           children: [
                             Text( 'Email:  ' +
                                snapshot.data.docs[index]["email"],
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                           ],
                         ),
                           Text(
                              snapshot.data.docs[index]["address"],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                           Divider(height:30),
                          
                      ],
                    )
                           )
              );
            },
          ),

          //bottom Navigation Bar

          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: primary,
            selectedLabelStyle: TextStyle(
              fontSize: 14,
            ),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.update, color: Colors.white),
                label: 'Update',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.star_half,
                  color: Colors.white,
                ),
                label: 'U.P GOV.',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.circle, color: Colors.white),
                label: 'Network',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.message, color: Colors.white),
                label: 'Update',
              ),
            ],
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          )),
    );
  }
}
