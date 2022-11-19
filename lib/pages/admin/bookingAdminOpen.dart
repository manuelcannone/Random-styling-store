import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:intl/intl.dart';
import 'package:randomstylingstore/pages/admin/bookingsAdmin.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

import 'notificationPage.dart';

class AdminBookingOpen extends StatelessWidget {
  AdminBookingOpen({
    super.key,
    required this.idBooking,
  });

  dynamic idBooking;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("booking/")
                  .doc(idBooking)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshotBooking) {
                if (snapshotBooking.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Color(0xffAE8952),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff181818))),
                  );
                } else {
                  if (snapshotBooking.hasData) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          width: currentWidth * 0.9,
                          child: FutureBuilder(
                              future: FirebaseFirestore.instance
                                  .collection("users/")
                                  .doc(snapshotBooking.data["user"])
                                  .get(),
                              builder: (context, AsyncSnapshot snapshotUser) {
                                if (snapshotUser.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        backgroundColor: Color(0xffAE8952),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xff181818))),
                                  );
                                } else {
                                  return Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Prenotazione ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                        TextSpan(
                                          text: 'da\n',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 30),
                                        ),
                                        TextSpan(
                                          text: snapshotUser
                                              .data["firstAndLastNames"],
                                          //snapshot.data.docs['users']['firstAndLastNames']
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xffAE8952),
                                            fontSize: 30,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              }),
                        ),
                        Container(
                          width: currentWidth * 0.9,
                          height: 240,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CRichText(
                                title: "Tipologia servizio: ",
                                content: snapshotBooking.data["sex"],
                              ),
                              CRichText(
                                title: "Servizio: ",
                                content: snapshotBooking.data["type"],
                              ),
                              CRichText(
                                title: "Operatore: ",
                                content: snapshotBooking.data["operators"],
                              ),
                              Row(
                                children: [
                                  Text("Data: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 20)),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(
                                        snapshotBooking.data["date"].toDate()),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                              CRichText(
                                title: "Ora: ",
                                content: snapshotBooking.data["hours"],
                              ),
                              CRichText(
                                title: "Email: ",
                                content: snapshotBooking.data["email"],
                              ),
                              CRichTextNoNotes(
                                title: "Note: ",
                                content: snapshotBooking.data["note"],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 40),
                          alignment: Alignment.center,
                          width: currentWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DecisionButton(
                                  function: () async {
                                    await FirebaseFirestore.instance
                                        .collection("booking/")
                                        .doc(idBooking)
                                        .update({"state": 1});
                                    NotificationPage.Emailsend(
                                        snapshotBooking.data["email"],
                                        "la tua prenotazione è stata rifiutata",
                                        []);
                                    Navigator.pop(context);

                                    barberSnapBar(context,
                                        "Prenotazione rifiutata", true);
                                  },
                                  borderColor: Color(0xffC50707),
                                  backColor: Color.fromARGB(40, 255, 0, 0),
                                  text: "NO"),
                              DecisionButton(
                                  function: () async {
                                    await FirebaseFirestore.instance
                                        .collection("booking/")
                                        .doc(idBooking)
                                        .update({"state": 2});
                                    NotificationPage.Emailsend(
                                        snapshotBooking.data["email"],
                                        "la tua prenotazione è stata accettata",
                                        []);

                                    Navigator.pop(context);
                                    barberSnapBar(context,
                                        "Prenotazione accettata", true);
                                  },
                                  borderColor: Color(0xff0EB100),
                                  backColor: Color.fromARGB(40, 15, 177, 0),
                                  text: "SI"),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  else
                  return Center(
                    child: CircularProgressIndicator(
                        backgroundColor: Color(0xffAE8952),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff181818))),
                  );
                }
              }),
        ),
      ),
    );
  }
}

class CRichText extends StatelessWidget {
  CRichText({super.key, required this.title, required this.content});

  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        TextSpan(
          text: content,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ]),
    );
  }
}

class CRichTextNoNotes extends StatelessWidget {
  CRichTextNoNotes({super.key, required this.title, required this.content});

  String title;
  String content;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
          text: title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        TextSpan(
          text: content,
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ]),
    );
  }
}

class DecisionButton extends StatefulWidget {
  DecisionButton(
      {super.key,
      required this.borderColor,
      required this.backColor,
      required this.text,
      required this.function});

  Color borderColor;
  Color backColor;
  String text;
  Function() function;

  @override
  State<DecisionButton> createState() => _DecisionButtonState();
}

class _DecisionButtonState extends State<DecisionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
          ),
          borderRadius: BorderRadius.circular(5),
          color: widget.backColor,
        ),
        alignment: Alignment.center,
        width: 150,
        height: 50,
        child: Text(
          widget.text,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
    );
  }
}
