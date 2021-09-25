import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart' as add;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/map.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

class ReportApproval extends StatefulWidget {
  final String id;
  final double lat;
  final double long;
  final String image;
  final String email;
  final String address;
  

  const ReportApproval(
      {Key key,
      this.image,
      this.email,
      this.address,
      this.id,
      this.lat,
      this.long})
      : super(key: key);
  @override
  _ReportApprovalState createState() => _ReportApprovalState();
}

class _ReportApprovalState extends State<ReportApproval> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.email),
      ),
      body: ListView(
        children: [
          Center(child: Text(widget.email)),
          SizedBox(
            height: 20,
          ),
          Image.network(
            widget.image,
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
            widget.address,
            maxLines: 2,
          ),
              )),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapsScreen(
                            email: widget.email,
                            id: widget.id,
                            lat: widget.lat,
                            long: widget.long,
                            address: widget.address,
                            image: widget.image,
                            isMap: false,
                            isdetail: true,
                          ),
                        ));
                  },
                  child: Text(
                    "Approve",
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    resolve(context);
                    sendMessage();
                  },
                  child: Text(
                    "Reject",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }

  resolve(BuildContext context) {
    FirebaseFirestore.instance
        .collection("Trash")
        .doc(widget.id)
        .delete()
        .whenComplete(() {
      print("deleted");
    });
    FirebaseFirestore.instance.collection("Rejected").doc().set({
      "latitude": widget.lat,
      "longitude": widget.long,
      "address": widget.address,
      "email": widget.email,
      "image": widget.image
    }).whenComplete(() {
      sendMessage();
      print("Rejected");
      showDialog(
          builder: (context) => AlertDialog(
                title: Text("Rejected"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                      child: Text('Ok'))
                ],
              ),
          context: context);
    });
  }

//send Email when Resolve
  sendMessage() async {
    String username = 'kmckarachiauth@gmail.com';
    String password = 'hasanyousufi123';

    final smtpServer = gmail(username, password);
    final message = add.Message()
      ..from = add.Address(username, 'Trash Detector')
      ..recipients.add(widget.email)
      ..subject = 'Your Complain is rejected'
      ..text =
          ('Thankyou for filing a complaint, We value your time and contribution in order to keep the city Clean. \n Complain Id: ' +
              widget.id +
              '\n' +
              'Your address: \n' +
              widget.address +
              '\n' +
              'your cordinates: \n' +
              'Latitude: ' +
              widget.lat.toString() +
              '\n' +
              'Longitude:  ' +
              widget.long.toString()) + 
              '\n' + 
              'Image :' + widget.image;
              

    try {
      final sendReport = await add.send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Alert"),
      //       content: Text("Email send successfully"),
      //     )
      // );
    } on add.MailerException catch (e) {
      print(e.toString());
    }
    var connection = add.PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
  }
}
