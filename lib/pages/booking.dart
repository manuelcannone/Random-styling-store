import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:randomstylingstore/colors.dart';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/home.dart';

import "package:animations/animations.dart";
import 'package:randomstylingstore/pages/selectServices&Booking.dart';

String operatorsValue = "";
DateTime selectDate = DateTime(2020, 01, 01);
int selectDateWeekDay = selectDate.weekday;
String dataValue = "";
String type = "";
dynamic typePrice = 0.0;
String hoursSelect = "";
String selectSex = "";
String timeModality = "";

TextEditingController noteController = TextEditingController();
void resetSelectedValue() {
  operatorsValue = "";
  selectDate = DateTime(2020, 01, 01);
  selectDateWeekDay = selectDate.weekday;
  dataValue = "";
  type = "";
  typePrice = 0.0;
  hoursSelect = "";
  selectSex = "";
  noteController.text = "";
  timeModality = "";
}

class Booking extends StatefulWidget {
  Booking({super.key, required this.services, required this.price, required this.sex, this.timeModality = "" });

  String services;
  dynamic price;
  String sex;
  String timeModality;

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> with TickerProviderStateMixin {
  final double sectionPadding = 20;

  final now = DateTime.now();

  late AnimationController _controller;
  late Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    Future.delayed(Duration(milliseconds: 1000), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    type = widget.services;
    typePrice = widget.price;
    selectSex = widget.sex;
    timeModality = widget.timeModality;
    print("==============");
    print(timeModality);
    return WillPopScope(
      onWillPop: () {
        resetSelectedValue();
        return Future.value(true);
      },
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //title part
          Container(
            padding: EdgeInsets.all(sectionPadding),
            child: RichText(
              text: const TextSpan(
                  text: "Seleziona\n",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: "Operatore", style: TextStyle(color: CColors.gold)),
                  ]),
            ),
          ),

          //Operators System
          Container(
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("operators")
                          .where("sex", isEqualTo: selectSex)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.2,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          if (snapshot.hasData) {
                            List<Widget> operatorsContent = [];

                            for (dynamic operator in snapshot.data!.docs) {
                              operatorsContent.add(
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      operatorsValue = operator["name"];
                                    });
                                  },
                                  child: FadeScaleTransition(
                                    animation: _animation,
                                    child: OperatorsWidget(
                                      myValue: operator["name"],
                                      isSelected: operatorsValue == operator["name"] ? true : false,
                                      pathImage: operator["path"],
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Row(children: operatorsContent);
                          }
                        }

                        return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width * 0.4,
                            child: Center(
                                child: Text(
                              "Errore riprova piu` tardi",
                              style: TextStyle(color: Colors.red),
                            )));
                      }))),

          BookingSection()
        ]),
      ),
    );
  }
}

class OperatorsWidget extends StatefulWidget {
  OperatorsWidget({super.key, this.isSelected = false, required this.myValue, required this.pathImage});

  bool isSelected;
  String myValue;
  String pathImage;

  @override
  State<OperatorsWidget> createState() => _OperatorsWidgetState();
}

class _OperatorsWidgetState extends State<OperatorsWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.25,
          // height: MediaQuery.of(context).size.height * 25,
          decoration: BoxDecoration(
              color: CColors.black,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: widget.isSelected ? Colors.green : Colors.transparent, width: 2),
              image: DecorationImage(
                  image: NetworkImage(widget.pathImage),
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(1), BlendMode.dstATop),
                  fit: BoxFit.fitHeight)),
        ),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Center(
            child: Text(
              widget.myValue,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        )
      ]),
    );
  }
}

class BookingSection extends StatefulWidget {
  const BookingSection({super.key});

  @override
  State<BookingSection> createState() => _BookingSectionState();
}

class _BookingSectionState extends State<BookingSection> {
  /// Show calendar in pop up dialog for selecting date range for calendar event.

  void showCalendar_(context) async {
    print(selectDate.year.compareTo(DateTime(2020, 01, 01).year) != -1);
    final values = await showCalendarDatePicker2Dialog(
      dialogBackgroundColor: CColors.black,
      context: context,
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
      dialogSize: const Size(325, 400),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    );

    if (values != null) {
      // ignore: avoid_print

      selectDate = values.first!;
      selectDateWeekDay = selectDate.weekday;
      print(selectDateWeekDay);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(children: [
        Center(
            child: operatorsValue != ""
                ? ElevatedButton(
                    child: Text(
                      selectDate.year.compareTo(DateTime(2020, 01, 01).year) != -1
                          ? DateFormat('dd/MM/yyyy').format(selectDate)
                          : DateFormat('dd/MM/yyyy').format(DateTime.now()),
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      showCalendar_(context);
                    },
                  )
                : ElevatedButton(
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(selectDate),
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: null,
                  )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            LegendItem(
              color: Colors.green,
              title: "Disponibile",
            ),
            LegendItem(
              color: Colors.red,
              title: "Occupato",
            ),
          ],
        ),
        BookingItems()
      ]),
    );
  }
}

class LegendItem extends StatelessWidget {
  LegendItem({super.key, required this.title, required this.color});

  String title;
  Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(100))),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}

class BookingItems extends StatefulWidget {
  const BookingItems({super.key});

  @override
  State<BookingItems> createState() => _BookingItemsState();
}

class _BookingItemsState extends State<BookingItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      width: MediaQuery.of(context).size.width * 0.85,
      child: Center(
          child: operatorsValue != ""
              // la data selezionata e` maggiore della data corrente?
              ? Timestamp.fromDate(DateTime(selectDate.year, selectDate.month, selectDate.day, 0, 0, 0, 0, 0))
                          .toDate()
                          .compareTo(Timestamp.fromDate(DateTime(
                                  DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0, 0, 0))
                              .toDate()) >
                      -1
                  ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("dates")
                          .where("day", isEqualTo: selectDateWeekDay)
                          .where("operators", isEqualTo: operatorsValue)
                          .snapshots()
                          .distinct(),
                      builder: (context, snapshot) {
                        //this date is used for where (maggiore di selectDate e minore di dateplus24 hours in modo da prendere tutte le ore)
                        final DateTime selectDateZeroMinute = Timestamp.fromDate(
                                DateTime(selectDate.year, selectDate.month, selectDate.day, 0, 0, 0, 0, 0))
                            .toDate()
                            .subtract(Duration(minutes: 1));
                        final DateTime selectDatePlus24Hours = Timestamp.fromDate(
                                DateTime(selectDate.year, selectDate.month, selectDate.day, 23, 59, 60, 0, 0))
                            .toDate();
                        try {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.4,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          } else {
                            if (snapshot.hasData) {
                              if (snapshot.data!.docs[0]["dates" + timeModality].length == -0) {
                                throw "Non ci sono date";
                              }
                              ;

                              try {
                                return StreamBuilder(
                                    // add state equal true
                                    stream: FirebaseFirestore.instance
                                        .collection("booking/")
                                        .where("date",
                                            isGreaterThanOrEqualTo: selectDateZeroMinute,
                                            isLessThan: selectDatePlus24Hours)
                                        .where("operators", isEqualTo: operatorsValue)
                                        .snapshots(),
                                    builder: (context, snapshot2) {
                                      List<Widget> dates = [];

                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      {
                                        try {
                                          if (snapshot.hasData) {
                                            dates = [];
                                            if (snapshot.data!.docs.length != 0) {
                                              for (var dayDate in snapshot.data!.docs) {
                                                
                                                for (var hours in dayDate["dates" + timeModality]) {
                                                  print("dates" + timeModality);
                                                  bool dataIsNotavaible = false;
                                                  for (var isSelectedHours in snapshot2.data!.docs) {
                                                   
                                                    print(isSelectedHours["hours"]);
                                                      print(isSelectedHours["state"]);
                                                      
                                                    if (hours == isSelectedHours["hours"]) {
                                                      dataIsNotavaible = true;
                                                      dates.add(BookingItem(
                                                        isAvaible: false,
                                                        value: hours,
                                                      ));
                                                      break;
                                                    }
                                                  }

                                                  if (dataIsNotavaible == false) {
                                                    dates.add(BookingItem(
                                                      isAvaible: true,
                                                      value: hours,
                                                    ));
                                                  }
                                                }
                                              }
                                            } else {
                                              throw "Date non disponibili";
                                            }

                                            return Wrap(
                                              spacing: 8,
                                              runSpacing: 10,
                                              children: dates,
                                            );
                                          }
                                        } catch (e) {
                                          print("Erroreee");
                                          print(e);
                                        }
                                      }

                                      return Container(
                                          width: MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context).size.width * 0.4,
                                          child: Center(
                                              child: Text(
                                            "Non ci sono date disponibili",
                                            style: TextStyle(color: Colors.white),
                                          )));
                                    });
                              } catch (e) {
                                //if not have data booking
                                print("Niente booking");
                                print(e);
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.width * 0.4,
                                    child: Center(
                                        child: Text(
                                      "Seleziona un operatore\no\nuna data",
                                      style: TextStyle(color: Colors.white),
                                    )));
                              }
                              ;
                            } else if (snapshot.hasError) {
                              return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  child: Center(
                                      child: Text(
                                    "Errore riprova piu` tardi",
                                    style: TextStyle(color: Colors.red),
                                  )));
                            }
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width * 0.4,
                                child: Center(
                                    child: Text(
                                  "Non ci sono date disponibili",
                                  style: TextStyle(color: Colors.white),
                                )));
                          }
                        } catch (e) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width * 0.4,
                              child: Center(
                                  child: Text(
                                "Non ci sono date disponibili",
                                style: TextStyle(color: Colors.white),
                              )));
                        }
                      })
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width * 0.4,
                      child: Center(
                          child: Text(
                        "Seleziona una data",
                        style: TextStyle(color: Colors.white),
                      )))
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.4,
                  child: Center(
                      child: Text(
                    "Seleziona un operatore",
                    style: TextStyle(color: Colors.white),
                  )))),
    );
  }
}

class BookingItem extends StatelessWidget {
  BookingItem({super.key, this.isAvaible = true, required this.value});

  bool isAvaible;
  String value;
  Widget content = Container();

  Future<void> confirmBookingDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Conferma prenotazione", style: TextStyle(color: CColors.gold, fontWeight: FontWeight.bold)),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Giorno",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat('dd/MM/yyyy').format(selectDate))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ora",
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text(hoursSelect)
                      ],
                    )
                  ]),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Servizio: ",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Text(type),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Operatore: ",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Text(operatorsValue)
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: EdgeInsets.only(top: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Prezzo: ",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text(typePrice.toString() + " €")
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "note:",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: 'Scrivi...'),
                      controller: noteController,
                      keyboardType: TextInputType.multiline,

                      maxLines: 3, // when user presses enter it will adapt to it
                    ),
                  ]),
                ),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Annulla",
                            style: TextStyle(color: CColors.gold),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        ),
                        SendPronatotionBtn()
                      ],
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    content = Container(
      width: 70,
      height: 45,
      decoration: BoxDecoration(
          color: isAvaible ? Colors.green : Colors.red, borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Center(
          child: Text(
        value,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      )),
    );

    return isAvaible
        ? GestureDetector(
            onTap: () {
              confirmBookingDialog(context);
              hoursSelect = value;
            },
            child: content,
          )
        : content;
  }
}

class SendPronatotionBtn extends StatefulWidget {
  const SendPronatotionBtn({super.key});

  @override
  State<SendPronatotionBtn> createState() => _SendPronatotionBtnState();
}

class _SendPronatotionBtnState extends State<SendPronatotionBtn> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;

    return ElevatedButton(
        onPressed: () async {
          final FirebaseAuth auth = FirebaseAuth.instance;

          isLoading = true;
          setState(() {});
          print(noteController.text);
          // if(noteController.text == "" && noteController.text == null){
          //   noteController.text = "Non ci sono note";
          // }
          await FirebaseFirestore.instance.collection("booking").add({
            "operators": operatorsValue,
            "date": DateTime(
                selectDate.year, selectDate.month, selectDate.day, int.parse(hoursSelect.substring(0, hoursSelect.indexOf(":"))), 0, 0, 0, 0),
            "week": selectDateWeekDay,
            "type": type,
            "hours": hoursSelect,
            "user": auth.currentUser?.uid,
            "email": auth.currentUser?.email,
            "state": 0,
            "price": typePrice,
            "sex": selectSex,
            // if (noteController.text != "" && noteController.text != null)
            "note": noteController.text,
          });
          isLoading = false;

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => AppbarFooter(
                        body: SelectServicesAndBooking(),
                        isUserAdmin: isUserAdminGlobal,
                        automaticallyImplyLeading: false,
                      ),
                  maintainState: true),
              (Route<dynamic> route) => false);

          const snackBar = SnackBar(
            content: Text('La tua prenotazione e` stata inviata'),
          );

          resetSelectedValue();
// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {});
        },
        child: isLoading
            ? Center(child: Container(padding: EdgeInsets.all(5), child: CircularProgressIndicator()))
            : Text("Prenota"));
  }
}
