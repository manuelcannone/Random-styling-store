import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/admin/prenotationCalendar.dart';
import 'package:randomstylingstore/pages/home.dart';
import 'package:randomstylingstore/pages/selectServices&Booking.dart';
import 'package:randomstylingstore/pages/services.dart';
import 'package:tcard/tcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../main.dart';

/*
    
   final operator = {

      "name" : "Gianmarco"
    };

      final addDatesToOperators = FirebaseFirestore.instance.collection("dates");
    
    addDatesToOperators.add({
      "dates" : [
         
      ],
      "dates1" : [
       
      ],
       "dates2" : [
      
      ],

      "day": 1,
      "week" : "lunedi",
      "operators": operator["name"],
    });

        addDatesToOperators.add({
         "dates" : [
        "9:00",
        "9:30",
        "10:00",
        "10:30",
        "11:00",
        "11:30",
        "14:00",
        "16:30"   
      ],
      "dates1" : [
        "12:00",
        "13:00",
        "15:00",
        "17:00"
      ],
       "dates2" : [
      
      ],
      "day": 2,
      "week" : "Martedi",
      "operators": operator["name"],
    });
      
        addDatesToOperators.add({
  "dates" : [
        "9:00",
        "9:30",
        "10:00",
        "10:30",
        "11:00",
        "11:30",
        "14:00",
        "16:30"   
      ],
      "dates1" : [
        "12:00",
        "13:00",
        "15:00",
        "17:00"
      ],
       "dates2" : [
      
      ],
      "day": 3,
      "week" : "Mercoledi",
      "operators":operator["name"],
    });
        addDatesToOperators.add({
      "dates" : [
        "9:00",
        "9:30",
        "10:00",
        "10:30",
        "11:00",
        "11:30",
        "14:00",
        "16:30"   
      ],
      "dates1" : [
        "12:00",
        "13:00",
        "15:00",
        "17:00"
      ],
       "dates2" : [
      
      ],
      "day": 4,
      "week" : "Giovedi",
      "operators": operator["name"],
    });
        addDatesToOperators.add({
     "dates" : [
        "9:00",
        "9:30",
        "10:00",
        "10:30",
        "11:00",
        "11:30",
        "14:00",
        "16:30"   
      ],
      "dates1" : [
        "12:00",
        "13:00",
        "15:00",
        "17:00"
      ],
       "dates2" : [
      
      ],
      "day": 5,
      "week" : "Venerdi",
      "operators":operator["name"],
    });

        addDatesToOperators.add({
      "dates" : [
        "9:00",
        "9:30",
        "10:00",
        "10:30",
        "11:00",
        "11:30",
        "14:00",
        "16:30"   
      ],
      "dates1" : [
        "12:00",
        "13:00",
        "15:00",
        "17:00"
      ],
       "dates2" : [
      
      ],
      "day": 6,
      "week" : "Sabato",
      "operators": operator["name"],
    });
       
       
        addDatesToOperators.add({
     "dates" : [
     
      ],
      "dates1" : [
      
      ],
       "dates2" : [
      
      ],
      "day": 7,
      "week" : "Domenica",
      "operators": operator["name"],
    });
 

*/
 String timeModality = "";

String operatorsValue = "";

class GestionService extends StatefulWidget {
  GestionService({
    super.key,
  });
  @override
  State createState() {
    return _GestionServiceState();
  }
}

class _GestionServiceState extends State<GestionService> {
  

  @override
  Widget build(BuildContext context) {
 
    return 
    Container(
      child: Center( child: 
      Column(children: [
        GestureDetector(
          onTap: (){
            timeModality = "";
             Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  AppbarFooter(
                                              body: OpertorSelected(),
                                              isUserAdmin: isUserAdminGlobal,
                                              automaticallyImplyLeading: true,
                                            )),
  );
          },
          child: OperatorsAdminView(
                              myValue: "Normale",
                              isSelected: false,
                            ),
        ),

         GestureDetector(
          onTap: (){
            timeModality = "1";
             Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  AppbarFooter(
                                              body: OpertorSelected(),
                                              isUserAdmin: isUserAdminGlobal,
                                              automaticallyImplyLeading: true,
                                            )),
  );
          },
          child: OperatorsAdminView(
                              myValue: "Medio",
                              isSelected: false,
                            ),
        ),


     GestureDetector(
          onTap: (){
            timeModality = "2";
             Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  AppbarFooter(
                                              body: OpertorSelected(),
                                              isUserAdmin: isUserAdminGlobal,
                                              automaticallyImplyLeading: true,
                                            )),
  );
          },
          child: OperatorsAdminView(
                              myValue: "Lento",
                              isSelected: false,
                            ),
        ),



      ],)

      ),
    );
    
    
  
  }
}

class OpertorSelected extends StatefulWidget {
   OpertorSelected({super.key, });


  @override
  State<OpertorSelected> createState() => _OpertorSelectedState();
}

class _OpertorSelectedState extends State<OpertorSelected> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return   Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("operators").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  //caricamento
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
                          child: OperatorsAdminView(
                            myValue: operator["name"],
                            isSelected: operatorsValue == operator["name"] ? true : false,
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                        scrollDirection: Axis.horizontal, child: Row(children: operatorsContent));
                  }

                  return Container();
                }
              }),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("dates/")
                    .where("operators", isEqualTo: operatorsValue)
                    .orderBy('day')
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  } else {
                    //se non e` in attesa:
                    if (snapshot.hasData) {
                      List<Widget> weeks = [];

                      for (var week in snapshot.data!.docs) {
                        weeks.add(CardExpandable(day: week["week"], bookingTime: week["dates" + timeModality], id: week.id));
                      }

                      return ExpandableTheme(
                        data: const ExpandableThemeData(
                          useInkWell: true,
                        ),
                        child: ListView(shrinkWrap: true, physics: const BouncingScrollPhysics(), children: weeks),
                      );
                    }
                    ;
                  }
                  if (snapshot.hasError) {
                    return Container();
                  }
                  return Container();
                }),
          ),
        ),
      ],
    );


  }
}


class CardExpandable extends StatelessWidget {
  CardExpandable({super.key, required this.day, required this.bookingTime, required this.id});
  List bookingTime;
  dynamic id;
  String day;

  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Card(
        color: CColors.black,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Colors.white,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Container(
                    child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    day,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )),
                collapsed: SizedBox(height: 0),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (var hours in bookingTime)
                      Container(
                        height: 60,
                        decoration: BoxDecoration(),
                        margin: EdgeInsets.only(
                          top: 5,
                          bottom: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              hours,
                              style: TextStyle(color: Colors.white, fontSize: 25),
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.red,
                              ),
                              height: 40,
                              width: 40,
                              child: IconButton(
                                icon: const Icon(Icons.delete),
                                iconSize: 20,
                                color: Colors.white,
                                onPressed: () {
                                  print(bookingTime);
                                  FirebaseFirestore.instance.collection("dates/").doc(id).update(
                                    {
                                      'dates' + timeModality: FieldValue.arrayRemove([hours.toString()]),
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    //bottone per aggiungere una prenotazione
                    AddTime(
                      id: id,
                    )
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Container(
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTime extends StatefulWidget {
  AddTime({super.key, required this.id});

  String id;
  bool isWriting = false;
  @override
  State<AddTime> createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {
  @override
  Widget build(BuildContext context) {
    late TextEditingController _controller = TextEditingController();
    String? _selectedTime;

    // We don't need to pass a context to the _show() function
    // You can safety use context as below
    Future<void> _show() async {
      final TimeOfDay? result = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.dialOnly,
          builder: (context, childWidget) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    // Using 24-Hour format
                    alwaysUse24HourFormat: true),
                // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
                child: childWidget!);
          });

      if (result != null) {

        setState(() {
          _selectedTime = result.format(context);
          print(result.format(context));
          print("search");
          FirebaseFirestore.instance.collection("dates/").doc(widget.id).update(
            {
              'dates' + timeModality : FieldValue.arrayUnion([result.format(context)])
            },
          );
        });
      }
    }

    @override
    void initState() {
      super.initState();
    }

    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          print(widget.isWriting);
          _show();
        },
        child: Text(
          '+ Aggiungi ora',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
