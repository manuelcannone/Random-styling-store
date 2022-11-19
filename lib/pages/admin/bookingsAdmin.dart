import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import 'package:randomstylingstore/pages/admin/bookingAdminOpen.dart';
import "package:randomstylingstore/pages/admin/notificationPage.dart";

import '../selectServices&Booking.dart';

bool order = true;
Stream _stream = FirebaseFirestore.instance
    .collection("booking/")
    .where("state", isEqualTo: 0)
    .where("date", isGreaterThan: DateTime.now())
    .orderBy("date", descending: order ? false : true)
    .snapshots();

class BookingsAdmin extends StatefulWidget {
  const BookingsAdmin({super.key});

  @override
  State<BookingsAdmin> createState() => _BookingsAdminState();
}

class _BookingsAdminState extends State<BookingsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      //color: Colors.red,
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: CColors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.4,
            child: CalendarDatePicker2(
              onValueChanged: ((value) {
                print(value);

                final DateTime selectDateZeroMinute = Timestamp.fromDate(
                        DateTime(value[0]!.year, value[0]!.month, value[0]!.day,
                            0, 0, 0, 0, 0))
                    .toDate()
                    .subtract(Duration(minutes: 1));

                final DateTime selectDatePlus24Hours = Timestamp.fromDate(
                        DateTime(value[0]!.year, value[0]!.month, value[0]!.day,
                            23, 59, 60, 0, 0))
                    .toDate();

                _stream = FirebaseFirestore.instance
                    .collection("booking/")
                    .where("date",
                        isGreaterThanOrEqualTo: selectDateZeroMinute,
                        isLessThan: selectDatePlus24Hours)
                    .where("state", isEqualTo: 0)
                    .orderBy("date", descending: order ? false : true)
                    .snapshots();

                setState(() {});
              }),
              config: CalendarDatePicker2WithActionButtonsConfig(
                calendarType: CalendarDatePicker2Type.single,
                calendarViewMode: DatePickerMode.day,
                selectedDayHighlightColor: CColors.gold,
                weekdayLabels: ["D", "L", "M", "M", "G", "V", "S"],
                controlsTextStyle: TextStyle(color: Colors.white),
                weekdayLabelTextStyle: TextStyle(color: CColors.gold),
                dayTextStyle: TextStyle(color: Colors.white),
                yearTextStyle: TextStyle(color: Colors.white),
                lastMonthIcon: Icon(Icons.arrow_back_ios_new),
                nextMonthIcon: Icon(Icons.arrow_forward_ios_outlined),
              ),
              initialValue: [],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 25, bottom: 10),
            height: 40,
            width: MediaQuery.of(context).size.width * 0.90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: ((context) => AlertDialog(
                            titlePadding: EdgeInsets.zero,
                            backgroundColor: CColors.grey,
                            title: Container(
                              // height: 90,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      order = true;
                                      setState(() {
                                        _stream = FirebaseFirestore.instance
                                            .collection("booking/")
                                            .where("state", isEqualTo: 0)
                                            .where("date", isGreaterThan: DateTime.now())
                                            .orderBy("date", descending: false)
                                            .snapshots();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text(
                                        "Più recenti",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: CColors.gold,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      order = false;
                                      setState(() {
                                        _stream = FirebaseFirestore.instance
                                            .collection("booking/")
                                            .where("state", isEqualTo: 0)
                                            .where("date", isGreaterThan: DateTime.now())
                                            .orderBy("date", descending: true)
                                            .snapshots();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text(
                                        "Meno recenti",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                    color: CColors.gold,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      order = false;
                                      setState(() {
                                        _stream = FirebaseFirestore.instance
                                            .collection("booking/")
                                            .where("state", isEqualTo: 0)
                                            .where("date", isGreaterThan: DateTime.now())
                                            .orderBy("date", descending: false)
                                            .snapshots();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text(
                                        "Visualizza tutte",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 22),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset("media/sort-by.png"),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              // flex: ,
              child: Bookings()),
        ],
      ),
    );
  }
}

class Bookings extends StatefulWidget {
  const Bookings({super.key});

  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.90,
      child: StreamBuilder(
        stream: _stream,
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
                print("I DATI CI SONOOOOOOOOOOOOOOOOOOOOO");
                if (snapshot.data.docs.length != 0) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: ((context, index) {
                        return SingleBooking(
                          idBooking: snapshot.data.docs[index].id,
                          id: snapshot.data.docs[index]["user"],
                          date: snapshot.data.docs[index]["date"],
                          hour: snapshot.data.docs[index]["hours"],
                          email: snapshot.data.docs[index]["email"],
                          button: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      String sex = "";
                                      String note = "";
                                      if (snapshot.data.docs[index]["sex"] ==
                                          "man") {
                                        sex = "Uomo";
                                      } else if (snapshot.data.docs[index]
                                              ["sex"] ==
                                          "woman") {
                                        sex = "Donna";
                                      }

                                      if (snapshot.data.docs[index]["note"] != "" && snapshot.data.docs[index]["note"] != null) {
                                        note = snapshot.data.docs[index]["note"];
                                      } else {
                                        note = "Non ci sono note";
                                      }

                                      return AppbarFooter(
                                        body: AdminBookingOpen(
                                          idBooking:
                                              snapshot.data.docs[index].id,
                                        ),
                                        isUserAdmin: true,
                                        automaticallyImplyLeading: true,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                "Visualizza",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                        );
                      }));
                } else {
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
            return Container();
          }
        }),
      ),
    );
  }
}

class SingleBooking extends StatelessWidget {
  SingleBooking(
      {super.key,
      required this.date,
      required this.hour,
      required this.button,
      required this.id,
      required this.idBooking,
      required this.email});

  Timestamp date;
  String hour;
  TextButton button;
  dynamic id;
  dynamic idBooking;
  String email;

  @override
  Widget build(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('ti è arrivata un Email'),
    );

    return Container(
      decoration: BoxDecoration(
          color: CColors.grey, borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width * 0.90,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
              future:
                  FirebaseFirestore.instance.collection("users/").doc(id).get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                      backgroundColor: Color(0xffAE8952),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff181818)));
                } else {
                  if (snapshot.hasData) {
                    return RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Richiesta da ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 25)),
                        TextSpan(
                            text: snapshot.data["firstAndLastNames"],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: CColors.gold,
                                fontSize: 25)),
                      ]),
                    );
                  }
                }
                return Container();
              }),
          Text(DateFormat('dd/MM/yyyy').format(date.toDate()) + " " + hour,
              style: TextStyle(color: Colors.white, fontSize: 20)),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 88,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BookingDecisionButton(
                        function: () async {
                          final newState = await FirebaseFirestore.instance
                              .collection("booking/")
                              .doc(idBooking)
                              .update({"state": 1});
                
                          barberSnapBar(
                              context, "Prenotazione rifiutata", true);

                          NotificationPage.Emailsend(email,
                              "la tua prenotazione è stata rifiutata", []);
                          snackBar;
                         
                          NotificationPage.Emailsend(email, "la tua prenotazione è stata rifiutata", []);
                        
                      
                        },
                        backColor: Color(0xffC50707),
                        icon: Icons.delete,
                      ),
                      BookingDecisionButton(
                        function: () async {
                          await FirebaseFirestore.instance
                              .collection("booking/")
                              .doc(idBooking)
                              .update({"state": 2});

                          barberSnapBar(
                              context, "Prenotazione accettata", true);

                          NotificationPage.Emailsend(email,
                              "la tua prenotazione è stata confermata!", []);
                          snackBar;
                          // }
                          NotificationPage.Emailsend(email, "la tua prenotazione è stata confermata!", []);
                      
                        },
                        backColor: Color(0xff0EB100),
                        icon: Icons.check,
                      ),
                    ],
                  ),
                ),
                Container(
                    height: 40, width: 180, color: CColors.gold, child: button),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingDecisionButton extends StatelessWidget {
  BookingDecisionButton(
      {super.key,
      required this.backColor,
      required this.icon,
      required this.function});

  Color backColor;
  IconData icon;
  Function() function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backColor,
          borderRadius: BorderRadius.circular(5),
        ),
        width: 40,
        height: 40,
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}
