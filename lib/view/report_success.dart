import 'dart:io';

import 'package:flutter/material.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

class ReportSuccess extends StatefulWidget {
  final File image;
  final String email;

  const ReportSuccess({Key key, this.image, this.email}) : super(key: key);
  @override
  _ReportSuccessState createState() => _ReportSuccessState();
}

class _ReportSuccessState extends State<ReportSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report Success"),
      ),
      body: ListView(
        children: [
          Container(
            
          ),
          Center(child: Text(widget.email)),
          SizedBox(height: 20,),
          Image.file(widget.image,height: 200,),
          SizedBox(height: 20,),
          Center(child: Text("Report send successfully")),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:20,right: 20),
            child: FlatButton(
                color: primary,
                onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            }, child: Text("Done",style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}
