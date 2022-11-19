
import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/auth/banned.dart';
import 'package:randomstylingstore/pages/auth/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:randomstylingstore/pages/auth/verifyEmail.dart';
import 'package:randomstylingstore/pages/home.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
bool isUserAdminGlobal = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          SfGlobalLocalizations.delegate
        ],
        supportedLocales: [
          Locale('it'),
        ],
        locale: Locale('it'),

        theme: AppTheme().theme,
        debugShowCheckedModeBanner: false,
        home: auth.currentUser == null
            ? RegisterPage(
                firstPage: true,
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection("users").doc(auth.currentUser?.uid).get(),
                builder: ((context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(
                              color: CColors.gold,
                            )));
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Text("NON SEI CONNESSO"),
                    );
                  }
                  if (snapshot.data["banned"]) {
                    //SE L'UTENTE E' BANNATO
                    return BannedPage();
                  } else if (!snapshot.data["verified"]) {
                    //SE L'UTENTE NON E' VERIFICATO
                    return VerifyEmailPage();
                  } else if (!snapshot.data["banned"] && snapshot.data["verified"]) {
                    //SE L'UTENTE E' VERIFICATO E NON BANNATO
                    isUserAdminGlobal = snapshot.data["isAdmin"];
                    return AppbarFooter(body: BarberHome(), isUserAdmin: isUserAdminGlobal);
                  }
                  return Container();
                })),
        //home: auth.currentUser == null ? RegisterPage(firstPage: true,) : AppbarFooter(body: BarberHome(),),
      ),
    );
  }
}
