import 'package:flutter/material.dart';

import 'package:randomstylingstore/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:randomstylingstore/pages/admin/bookingAdminOpen.dart';
import 'package:randomstylingstore/pages/selectServices&Booking.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'bookingAdminOpen.dart';

bool loadingStop = false;
String operatorsValue = "";
DateTime get _now => DateTime.now();

class CalendarView extends StatefulWidget {
  CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  Color TextColor = Colors.black;

  DateTime get _now => DateTime.now();
  String _timezone = 'Unknown';
  List<String> _availableTimezones = <String>[];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AppbarFooter(
                          body: SelectServicesAndBooking(),
                          isUserAdmin: isUserAdminGlobal,
                          automaticallyImplyLeading: true,
                        )),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.04,
              child: Center(child: Text("+ Crea prenotazione", style: TextStyle(color: Colors.white),)),
              decoration: BoxDecoration(
                  color: CColors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: CColors.grey, width: 1.5)),
            ),
          ),
          SizedBox(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("operators").snapshots(),
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
          // CalendarSingleView(),
          CalendarViewSf()
        ],
      ),
    );
  }
}

class CalendarViewSf extends StatelessWidget {
  CalendarViewSf({super.key});

  CalendarController calendarController = CalendarController();

  getDataFromDatabase(List a) async {
    return a;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("booking/").where("operators", isEqualTo: operatorsValue).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.2,
              child: Center(child: CircularProgressIndicator()),
            );
          } else {
            if (snapshot.hasData) {
              List<Appointment> _events = [];

              for (var eventProperty in snapshot.data!.docs) {
                String str = eventProperty["hours"].toString();

                final int endHours = str.indexOf(":");
                int hours = int.parse(str.substring(0, endHours));
                int minutes = int.parse(str.substring(endHours + 1, str.length));

                DateTime eventData = (eventProperty["date"]).toDate();

                final Appointment app = Appointment(
                    id: eventProperty!.id.toString(),
                    color: eventProperty["state"] == 1 ? Colors.red : CColors.black,
                    startTime: DateTime(eventData.year, eventData.month, eventData.day, hours, minutes),
                    endTime: DateTime(eventData.year, eventData.month, eventData.day, hours, minutes)
                        .add( eventProperty["state"] == 1 ? Duration(minutes: 30) : Duration(hours: 1)),
                    subject: eventProperty["type"] +
                        "\nOperatore:" +
                        eventProperty["operators"] +
                        "\n" +
                        eventProperty["email"]);
                print(eventProperty!.id);
                _events.add(app);
              }
              
              return Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: SfCalendar(
                    onTap: (calendarTapDetails) {
                        if( calendarTapDetails.appointments![0].id.length != 0 ){
                               Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppbarFooter(
                                      body: AdminBookingOpen(
                                        idBooking: calendarTapDetails.appointments![0].id,
                                     
                                      ),
                                      isUserAdmin: true,
                                      automaticallyImplyLeading: true,
                                    )));
                        
                     }
                    },
                    dataSource: _getCalendarDataSource(_events),
                    controller: calendarController,
                    showDatePickerButton: true,
               
                    headerHeight: 100,
                    timeSlotViewSettings: TimeSlotViewSettings(
                      dateFormat: "dd",
                      timeFormat: "HH:mm",
                      startHour: 5,
                      timeIntervalHeight: 100,
                    ),
                    monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                    ),
                    backgroundColor: Colors.white,
                    appointmentTextStyle: TextStyle(color: Colors.white),
                    firstDayOfWeek: 1,
                    timeZone: 'Romance Standard Time',
                  ));
            }

            return Container();
          }
        });
  }
}

class OperatorsAdminView extends StatefulWidget {
  OperatorsAdminView({
    super.key,
    this.isSelected = false,
    required this.myValue,
  });

  bool isSelected;
  String myValue;
  @override
  State<OperatorsAdminView> createState() => _OperatorsAdminViewState();
}

class _OperatorsAdminViewState extends State<OperatorsAdminView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      width: MediaQuery.of(context).size.width * 0.25,
      height: MediaQuery.of(context).size.height * 0.05,
      decoration: BoxDecoration(
          color: widget.isSelected ? CColors.black : CColors.grey, border: Border.all(color: CColors.grey, width: 2)),
      child: Center(
          child: Text(
        widget.myValue,
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}

_AppointmentDataSource _getCalendarDataSource(List<Appointment> appointments) {
  return _AppointmentDataSource(appointments);
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
