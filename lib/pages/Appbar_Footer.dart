import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/admin/bookingsAdmin.dart';
import 'package:randomstylingstore/pages/admin/gestionService.dart';

import 'package:randomstylingstore/pages/admin/notificationPage.dart';
import 'package:randomstylingstore/pages/admin/pointsCollectionAdmin.dart';
import 'package:randomstylingstore/pages/admin/prenotationCalendar.dart';
import 'package:randomstylingstore/pages/admin/usersAdmin.dart';
import 'package:randomstylingstore/pages/auth/login.dart';
import 'package:randomstylingstore/pages/auth/register.dart';
import 'package:randomstylingstore/pages/claimReward.dart';
import 'package:randomstylingstore/pages/home.dart';
import 'package:randomstylingstore/pages/notifications.dart';
import 'package:randomstylingstore/pages/points.dart';
import 'package:randomstylingstore/pages/selectServices&Booking.dart';
import 'package:randomstylingstore/pages/userPage.dart';
import 'package:randomstylingstore/pages/admin/gestionWomanMan.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class AppbarFooter extends StatefulWidget {
  AppbarFooter({
    super.key,
    required this.body,
    required this.isUserAdmin,
    this.removeFooter = false,
    this.automaticallyImplyLeading = false,
  });

  Widget body;
  bool isUserAdmin;
  bool removeFooter;
  bool automaticallyImplyLeading;

  @override
  State<AppbarFooter> createState() => _AppbarFooterState();
}

class _AppbarFooterState extends State<AppbarFooter> {
  bool _isVisible = false;
  bool _isVisibleClock = false;

  void showToast() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void showClock() {
    setState(() {
      _isVisibleClock = !_isVisibleClock;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<IconData> iconList = [
      Iconsax.calendar_1,
      Iconsax.notification,
    ];

    int _bottomNavIndex = 0;

    return WillPopScope(
        onWillPop: () async => widget
            .automaticallyImplyLeading, //disable the android back button if is false
        child: Scaffold(
          drawerEnableOpenDragGesture: false,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: widget.automaticallyImplyLeading
                  ? IconButton(
                      icon: Icon(Icons.arrow_back_ios_sharp),
                      onPressed: () => Navigator.pop(context),
                    )
                  : null,
              elevation: 0,
              title: GestureDetector(
                  onTap: () {},
                  child: Container(
                    child: widget.isUserAdmin
                        ? Row(
                            children: [
                              Builder(
                                  builder:
                                      (context) => // Ensure Scaffold is in context
                                          IconButton(
                                              icon: Icon(Icons.menu),
                                              onPressed: () =>
                                                  Scaffold.of(context)
                                                      .openDrawer())),
                              Image.asset(
                                'media/barberlogo.png',
                                scale: 1.5,
                              )
                            ],
                          )
                        : Image.asset(
                            'media/barberlogo.png',
                            scale: 1.5,
                          ),
                  )),
              actions: <Widget>[
                AppbarMenu(),
                SizedBox(
                  width: 15,
                )
              ]),
          floatingActionButton: widget.removeFooter
              ? null
              : FloatingActionButton(
                  child: Icon(
                    Icons.home_outlined,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AppbarFooter(
                                body: BarberHome(),
                                isUserAdmin: isUserAdminGlobal,
                                automaticallyImplyLeading: false,
                              )),
                    );
                  }),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: widget.removeFooter
              ? null
              : AnimatedBottomNavigationBar(
                  //navigation bar
                  icons: iconList, //list of icons
                  activeIndex: _bottomNavIndex,
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.defaultEdge,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppbarFooter(
                                    body: SelectServicesAndBooking(),
                                    isUserAdmin: isUserAdminGlobal,
                                    automaticallyImplyLeading: true,
                                  )),
                        );
                        break;
                      case 1:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppbarFooter(
                                    body: Notifications(),
                                    isUserAdmin: isUserAdminGlobal,
                                    automaticallyImplyLeading: true,
                                  )),
                        );
                        break;
                      default:
                    }
                  },
                  backgroundColor: CColors.grey,
                ),
          drawer: isUserAdminGlobal
              ? Drawer(
                  child: ListView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: Container(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              size: 80,
                            ),
                            Text(
                              "ADMIN",
                              style:
                                  TextStyle(color: CColors.gold, fontSize: 25),
                            ),
                          ],
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          showToast();
                        },
                        child: Container(
                          color: CColors.grey,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "Clienti",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: _isVisible
                                      ? Icon(Icons.arrow_drop_up)
                                      : Icon(Icons.arrow_drop_down),
                                ),
                              ]),
                        ),
                      ),
                      Visibility(
                          visible: _isVisible,
                          child: Column(
                            children: [
// utenti
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AppbarFooter(
                                                body: UsersPage(),
                                                isUserAdmin: isUserAdminGlobal,
                                                automaticallyImplyLeading: true,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: CColors.grey,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Utenti",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(Icons.person),
                                          )
                                        ]),
                                  )),

//notifiche
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AppbarFooter(
                                                body: NotificationPage(
                                                  toAll: true,
                                                ),
                                                isUserAdmin: isUserAdminGlobal,
                                                automaticallyImplyLeading: true,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: CColors.grey,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Notifiche",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(Icons.message),
                                          )
                                        ]),
                                  )),

//appuntamenti
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AppbarFooter(
                                                body: BookingsAdmin(),
                                                removeFooter: true,
                                                isUserAdmin: isUserAdminGlobal,
                                                automaticallyImplyLeading: true,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: CColors.grey,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Conferma appuntamenti",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(Icons.calendar_today),
                                          )
                                        ]),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AppbarFooter(
                                                body:
                                                    PointsCollectionAdminPage(),
                                                //removeFooter: true,
                                                isUserAdmin: isUserAdminGlobal,
                                                automaticallyImplyLeading: true,
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: CColors.grey,
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Text(
                                              "Gestisci Raccolta Punti",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          Container(
                                            child: Icon(
                                                Icons.tab_unselected_rounded),
                                          )
                                        ]),
                                  )),
                            ],
                          )),
                      Divider(
                        color: CColors.gold,
                        height: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          showClock();
                        },
                        child: Container(
                          color: CColors.grey,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: MediaQuery.of(context).size.height * 0.10,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                    "Attivita",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  child: _isVisibleClock
                                      ? Icon(Icons.arrow_drop_up)
                                      : Icon(Icons.arrow_drop_down),
                                ),
                              ]),
                        ),
                      ),
                      Visibility(
                          visible: _isVisibleClock,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppbarFooter(
                                              body: GestionService(),
                                              isUserAdmin: isUserAdminGlobal,
                                              automaticallyImplyLeading: true,
                                            )),
                                  );
                                },
                                child: Container(
                                  color: CColors.grey,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Orario",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(Icons.timer),
                                        )
                                      ]),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppbarFooter(
                                              body: CalendarView(),
                                              isUserAdmin: isUserAdminGlobal,
                                              automaticallyImplyLeading: true,
                                            )),
                                  );
                                },
                                child: Container(
                                  color: CColors.grey,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Appuntamenti",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(Icons.calendar_month),
                                        )
                                      ]),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AppbarFooter(
                                              body: ContainerGestionManWoman(),
                                              isUserAdmin: isUserAdminGlobal,
                                              automaticallyImplyLeading: true,
                                            )),
                                  );
                                },
                                child: Container(
                                  color: CColors.grey,
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Text(
                                            "Gestione servizi",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        ),
                                        Container(
                                          child: Icon(Icons.cut),
                                        )
                                      ]),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                )
              : null,
          body: widget.body,
        ));
  }
}

class AppbarMenu extends StatelessWidget {
  AppbarMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("points")
            .doc("pointsCollection")
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return PopupMenuButton(
            color: CColors.gold,
            child: Icon(
              Iconsax.user,
              size: 30,
            ),
            itemBuilder: snapshot.hasData && snapshot.data["isEnabled"]
                ? (context) {
                    return [
                      PopupMenuItem<int>(
                        onTap: () async {
                          Future.delayed(
                              const Duration(seconds: 0),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => (AppbarFooter(
                                            isUserAdmin: isUserAdminGlobal,
                                            body: UserPage(
                                                uid: auth.currentUser?.uid),
                                            automaticallyImplyLeading: true,
                                            removeFooter: true,
                                          ))))));
                        },
                        value: 0,
                        child: Text(
                          "Il mio profilo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem<int>(
                        onTap: () async {
                          Future.delayed(
                              const Duration(seconds: 0),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => (AppbarFooter(
                                            isUserAdmin: isUserAdminGlobal,
                                            body: PointsPage(
                                                uid: auth.currentUser?.uid),
                                            removeFooter: true,
                                            automaticallyImplyLeading: true,
                                          ))))));
                        },
                        value: 1,
                        child: Text(
                          "Carta fedeltà",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem<int>(
                        onTap: () async {
                          Future.delayed(
                              const Duration(seconds: 0),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => (AppbarFooter(
                                            isUserAdmin: isUserAdminGlobal,
                                            body: ClaimRewardPage(
                                                uid: auth.currentUser?.uid),
                                            removeFooter: true,
                                            automaticallyImplyLeading: true,
                                          ))))));
                        },
                        value: 1,
                        child: Text(
                          "Premio fedeltà",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem<int>(
                          value: 2,
                          onTap: () async {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: CColors.black,
                                          content: Text(
                                            "Sei sicuro di voler disconnetterti?",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No",
                                                    style: TextStyle(
                                                        color: CColors.gold))),
                                            TextButton(
                                                onPressed: () async {
                                                  logout(context, true);
                                                },
                                                child: Text("Sì",
                                                    style: TextStyle(
                                                        color: CColors.gold))),
                                          ],
                                        );
                                      },
                                    ));
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          )),
                    ];
                  }
                : (context) {
                    return [
                      PopupMenuItem<int>(
                        onTap: () async {
                          Future.delayed(
                              const Duration(seconds: 0),
                              () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => (AppbarFooter(
                                            isUserAdmin: isUserAdminGlobal,
                                            body: UserPage(
                                                uid: auth.currentUser?.uid),
                                            automaticallyImplyLeading: true,
                                            removeFooter: true,
                                          ))))));
                        },
                        value: 0,
                        child: Text(
                          "Il mio profilo",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      PopupMenuItem<int>(
                          value: 2,
                          onTap: () async {
                            Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: CColors.black,
                                          content: Text(
                                            "Sei sicuro di voler disconnetterti?",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No",
                                                    style: TextStyle(
                                                        color: CColors.gold))),
                                            TextButton(
                                                onPressed: () async {
                                                  logout(context, true);
                                                },
                                                child: Text("Sì",
                                                    style: TextStyle(
                                                        color: CColors.gold))),
                                          ],
                                        );
                                      },
                                    ));
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(color: Colors.white),
                          )),
                    ];
                  },
          );
        });
  }
}

class TitleText extends StatelessWidget {
  TitleText(
      {super.key,
      required this.text,
      this.fontWeight,
      this.fontSize = 32,
      this.textAlign});

  FontWeight? fontWeight;
  double? fontSize;
  String text;
  TextOverflow? overflow;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: CColors.gold,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}

class SubTitleText extends StatelessWidget {
  SubTitleText(
      {super.key,
      required this.text,
      this.overflow,
      this.textAlign,
      this.fontSize});

  TextOverflow? overflow;
  String text;
  TextAlign? textAlign;
  double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: fontSize),
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

logout(context, bool log) {
  auth.signOut().then((value) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => log ? LoginPage(
                  firstPage: true,
                ) : 
                RegisterPage(
                  firstPage: true,
                )
                )
                
                ));
  });
}