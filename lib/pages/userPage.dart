import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:randomstylingstore/pages/admin/userPageAdmin.dart';
import 'package:randomstylingstore/pages/admin/usersAdmin.dart';


import 'admin/bookingAdminOpen.dart';
import 'auth/register.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class UserPage extends StatelessWidget {
  UserPage({super.key, required this.uid});
  dynamic uid;
  bool verifyEmailSent = false;

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Open Mail App"),
          content: Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  resetPassword(String email) {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      verifyEmailSent = true;
    } on FirebaseAuthException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TitleText(
                            text: "Profilo utente",
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(360),
                              child: Image.network(
                                  "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-portrait-176256935.jpg"),
                            ),
                          )
                        ],
                      ),
                      Label(
                          type: "Nominativo",
                          text: snapshot.data["firstAndLastNames"]),
                      Label(type: "Email", text: snapshot.data["email"]),
                      Label(
                          type: "Numero di Telefono",
                          text: snapshot.data["mobile"]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              resetPassword(snapshot.data["email"]);
                              if (verifyEmailSent) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: CContainer(
                                        radius: 10,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 15),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        color: CColors.black,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                      text:
                                                          "Abbiamo inviato una email a ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18),
                                                      children: [
                                                        TextSpan(
                                                            text:
                                                                "${snapshot.data["email"]}",
                                                            style: TextStyle(
                                                                color: CColors
                                                                    .gold,
                                                                fontSize: 18)),
                                                        TextSpan(
                                                            text: "!",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18)),
                                                      ]),
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                  color: CColors.gold,
                                                ),
                                                Text(
                                                    "Assicurati di controllare anche la casella dello Spam!",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12))
                                              ],
                                            ),
                                            CommonSlider(
                                                function: () async {
                                                  var result = await OpenMailApp
                                                      .openMailApp(
                                                          nativePickerTitle:
                                                              'Seleziona app');
                                                  if (!result.didOpen &&
                                                      !result.canOpen) {
                                                    showNoMailAppsDialog(
                                                        context);
                                                    // iOS: if multiple mail apps found, show dialog to select.
                                                    // There is no native intent/default app system in iOS so
                                                    // you have to do it yourself.
                                                  } else if (!result.didOpen &&
                                                      result.canOpen) {
                                                    showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return MailAppPickerDialog(
                                                          mailApps:
                                                              result.options,
                                                        );
                                                      },
                                                    );
                                                  }
                                                },
                                                text:
                                                    "Scorri per aprire l'app delle tue email"),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cambia Password",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: ((context) {
                                    return AlertDialog(
                                      backgroundColor: Colors.transparent,
                                      content: CContainer(
                                        radius: 10,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 15),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .35,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .9,
                                        color: CColors.black,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "Il tuo account verrà eliminato",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 21),
                                                ),
                                                TextSpan(
                                                  text: " permanentemente",
                                                  style: TextStyle(
                                                      color: CColors.gold,
                                                      fontSize: 21),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ". Sei sicuro di voler continuare?",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 21),
                                                )
                                              ],
                                            )),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                DecisionButton(
                                                  widthB: 80,
                                                  heightB: 45,
                                                    function:(){
                                                      Navigator.pop(context);      
                                                    },
                                                    borderColor:
                                                        Color(0xffC50707),
                                                    backColor: Color.fromARGB(
                                                        40, 255, 0, 0),
                                                    text: "NO"),
                                                DecisionButton(
                                                  widthB: 80,
                                                  heightB: 45,
                                                  function:()  {
                                                    FirebaseFirestore.instance.collection("users/").doc(uid).delete();
                                                    var user = auth.currentUser;
                                                    user?.delete();
                                                    logout(context);
                                                  },
                                                  borderColor:
                                                      Color(0xff0EB100),
                                                  backColor: Color.fromARGB(
                                                      40, 15, 177, 0),
                                                  text: "SI",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }));
                            },
                            child: Padding(
                                padding: EdgeInsets.all(7.5),
                                child: Text(
                                  "Elimina account",
                                  style: TextStyle(fontSize: 24),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [JreadyLabel()],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: CColors.gold,
                ));
        });
  }
}

class Label extends StatelessWidget {
  Label({super.key, required this.type, required this.text});

  String type;
  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 22.5,
              color: Colors.white,
              overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }
}

class JreadyLabel extends StatelessWidget {
  const JreadyLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "App sviluppata da:",
          style: TextStyle(
              fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .1,
            child: Image.asset("media/JreadyLogo.png"))
      ],
    );
  }
}