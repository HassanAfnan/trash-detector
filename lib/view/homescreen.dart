import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/loginscreen.dart';
import 'package:registraron_screen/view/uploadpicture.dart';
import 'package:registraron_screen/view/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  var email;
  bool isSun = true;
  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      print(email);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
 }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: new BoxDecoration(
//            gradient: new LinearGradient(
//                colors: [bottombackgroundColor, backgroundColor],
//                begin: const FractionalOffset(0.5, 0.0),
//                end: const FractionalOffset(0.0, 0.5),
//                stops: [0.0, 1.0],
//                tileMode: TileMode.clamp),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Consumer<ThemeNotifier>(
                            builder: (context,notifier,child) => notifier.darkTheme ? IconButton(icon:Icon(Icons.wb_sunny,color: Colors.yellow.shade700,),onPressed: (){
                              notifier.toggleTheme();
                              setState(() {
                                isSun = !isSun;
                              });
                            }): IconButton(icon:Icon(Icons.nightlight_round,color: Colors.white,),onPressed: (){
                              notifier.toggleTheme();
                              setState(() {
                                isSun = !isSun;
                              });
                            })
                        )
                      ],
                    ),
                  Container(

                    height: _height*0.15,
                    child: Padding(
                      padding: const EdgeInsets.only(top:50.0),
                      child: Text(
                        'welcome',
                        style: GoogleFonts.bitter(
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold,
                            ),
                      ),

                    ),
                  ),
                  Center(
                    child: Container(
                      child: Text(email == null ?"":email,style: TextStyle(),),
                    ),
                  ),
                  SizedBox(height:_height * 0.1),
                  Container(
                     height: _height*0.3,
                    
                    child: Padding(
                      padding: const EdgeInsets.only(
                      
                        left: 30.0,
                        right: 20.0,
                        bottom: 0.0,
                      ),
                      child: Image.asset(
                        'assets/3.png',
                      ),
                    ),
                  ), //is container ke baad
                ]),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: _width / 1.85,
                            child: RaisedButton(
                              color: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 20,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UploadingImageToFirebaseStorage(email: email),
                                  ));
                              },
                              textColor: Colors.white,
                              
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width:5.0),
                                    Text(
                                      "Camera",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                            width: _width / 1.85,
                            child: RaisedButton(
                              color: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 10,

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
                              textColor: Colors.white,
                              
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width:5.0),
                                    Text(
                                      "LOGOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      //     Container(

                      //   padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
                      //   height: 40.0,
                      //   child: Material(
                      //     borderRadius: BorderRadius.circular(20.0),
                      //     shadowColor: Color.fromARGB(255, 24, 24, 24),
                      //     color: Color.fromARGB(255, 40, 40, 40),
                      //     elevation: 7.0,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) =>
                      //                   UploadingImageToFirebaseStorage(),
                      //             ));
                      //       },
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(left: 60.0),
                      //         child: Row(
                      //           children: [
                      //             Icon(
                      //               Icons.camera_alt_outlined,
                      //               color: Colors.white,
                      //             ),
                      //             Text(
                      //               "Camera",
                      //               style: TextStyle(
                      //                 color: Colors.white,
                      //                 fontWeight: FontWeight.bold,
                      //               ),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(height: 10.0),

                      // Container(
                      //   padding: EdgeInsets.fromLTRB(100.0, 0.0, 100.0, 0.0),
                      //   height: 40.0,
                      //   child: Material(
                      //     borderRadius: BorderRadius.circular(20.0),
                      //     shadowColor: Color.fromARGB(255, 24, 24, 24),
                      //     color: Color.fromARGB(255, 40, 40, 40),
                      //     elevation: 7.0,
                      //     child: GestureDetector(
                      //       onTap: () {
                      //         Navigator.push(
                      //             context,
                      //             MaterialPageRoute(
                      //               builder: (context) => WelcomeScreen(),
                      //             ));
                      //       },
                      //       child: Center(
                      //         child: Text(
                      //           'logout',
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.bold,
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
