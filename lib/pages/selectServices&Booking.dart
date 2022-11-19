import 'dart:async';

import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/services.dart';
import 'Appbar_Footer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SelectServicesAndBooking extends StatefulWidget {
  const SelectServicesAndBooking({super.key});

  @override
  State<SelectServicesAndBooking> createState() => _SelectServicesAndBookingState();
}

class _SelectServicesAndBookingState extends State<SelectServicesAndBooking> {
  String manService = "man";
  String womanService = "woman";

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: FirebaseFirestore.instance.collection("users").doc(auth.currentUser?.uid).get(),
      builder: (context, AsyncSnapshot snapshot) {
        // changeValue();

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingPage();
        } else {
          return Page();
        }
      });
}

class CBooking extends StatefulWidget {
  CBooking(
      {super.key,
      required this.date,
      required this.hour,
      required this.service,
      required this.state,
      required this.icon});

  Timestamp date;
  String hour;
  String service;
  int state;
  IconData icon;

  @override
  State<CBooking> createState() => _CBookingState();
}

class _CBookingState extends State<CBooking> {
  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = DateTime.now();
    Timestamp myTimeStamp = Timestamp.fromDate(myDateTime);

    return CContainer(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      // width: MediaQuery.of(context).size.width * 0.85,
      height: 65,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('dd/MM/yyyy').format(widget.date.toDate()) + " " + widget.hour,
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(widget.service,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
          Row(
            children: [
              Text("stato:", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Icon(
                widget.icon,
                color: CColors.gold,
                size: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BookingState extends StatelessWidget {
  BookingState({super.key, required this.icon, required this.text});

  IconData icon;
  String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: CColors.gold,
            size: 45,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class ButtonService extends StatefulWidget {
  ButtonService(
      {super.key, required this.isUserAdmin, required this.type, required this.image, required this.serviceSex});

  bool isUserAdmin;
  String type;
  String image;
  String serviceSex;

  @override
  State<ButtonService> createState() => _ButtonServiceState();
}

class _ButtonServiceState extends State<ButtonService> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AppbarFooter(
                    body: Services(serviceSex: widget.serviceSex),
                    isUserAdmin: widget.isUserAdmin,
                    automaticallyImplyLeading: true,
                  )),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: CColors.black,
          image: DecorationImage(
            opacity: 0.3,
            image: AssetImage(widget.image),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.18,
        child: Text(
          widget.type,
          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, shadows: [
            Shadow(
              offset: Offset(4.0, 5.0),
              blurRadius: 8.0,
              color: Colors.black,
            ),
          ]),
        ),
      ),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String manService = "man";
    String womanService = "woman";

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: MediaQuery.of(context).size.width * 0.075),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 20,
            child: Column(
              children: [
                FadeScaleTransition(
                  animation: _controller,
                  child: ButtonService(
                    isUserAdmin: isUserAdminGlobal,
                    type: "Uomo",
                    image: "media/manhair.jpg",
                    serviceSex: manService,
                  ),
                ),
                // SizedBox(
                //   height: 20,
                // ),
                // FadeScaleTransition(
                //   animation: _controller,
                //   child: ButtonService(
                //     isUserAdmin: isUserAdminGlobal,
                //     type: "Donna",
                //     image: "media/womanhair.jpg",
                //     serviceSex: womanService,
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(                  
                  //color: Colors.blue,
                  margin: EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width * 0.75, //200,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "Le ",
                            style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "tue\n",
                            style: TextStyle(color: CColors.gold, fontSize: 35, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: "prenotazioni",
                            style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                Container(
                  //color: Colors.teal,
                  alignment: Alignment.bottomRight,
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: 90,
                  child: GestureDetector(
                    onTap: (() {
                      showDialog(
                        context: context,
                        builder: ((context) => AlertDialog(
                              backgroundColor: CColors.grey,
                              title: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    BookingState(
                                      icon: Icons.check_rounded,
                                      text: "la tua prenotazione è stata confermata",
                                    ),
                                    BookingState(
                                      icon: Icons.hourglass_bottom_rounded,
                                      text: "la tua prenotazione è ancora in fase di accettazione",
                                    ),
                                    BookingState(
                                      icon: Icons.clear_rounded,
                                      text: "la tua prenotazione è stata rifiutata",
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    }),
                    child: Icon(
                      Icons.info_outline,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 30,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("booking/")
                    .where("user", isEqualTo: auth.currentUser?.uid)
                    .where("date", isGreaterThan: DateTime.now())
                    .orderBy("date", descending: false)
                    .snapshots(),
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Color(0xffAE8952),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xff181818))),
                    );
                  } else {
                    try {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.length != 0) {
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: ((context, index) {
                                List<IconData> icons = [
                                  Icons.hourglass_bottom_rounded,
                                  Icons.clear_rounded,
                                  Icons.check_rounded
                                ];

                                return CBooking(
                                  date: snapshot.data.docs[index]["date"],
                                  hour: snapshot.data.docs[index]["hours"],
                                  service: snapshot.data.docs[index]["type"],
                                  state: snapshot.data.docs[index]["state"],
                                  icon: icons[snapshot.data.docs[index]["state"]],
                                );
                              }));
                        } else {
                          // Non c'è nulla dentro il db
                          throw "Db vuoto";
                        }
                      } else if (snapshot.hasError) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: Center(
                                child: Text(
                              "Errore riprova piu` tardi",
                              style: TextStyle(color: Color.fromARGB(255, 237, 30, 3)),
                            )));
                      }
                    } catch (e) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width * 0.4,
                          child: Center(
                              child: Text(
                            "Non ci sono prenotazioni",
                            style: TextStyle(color: Colors.white),
                          )));
                    }
                  }
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: Center(
                          child: Text(
                        "Non ci sono più prenotazioni",
                        style: TextStyle(color: CColors.gold),
                      )));
                })),
          ),
        ],
      ),
    );
  }
}
