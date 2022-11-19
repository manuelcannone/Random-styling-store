import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/admin/usersAdmin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../commonWidgets.dart';

class NotificationPage extends StatelessWidget {
  NotificationPage(
      {super.key,
      required this.toAll,
      this.email = "",
      this.testoMail = "",
      this.firstLastName = ""});

  bool toAll;
  String email;
  String firstLastName;
  String testoMail;
  List<String> allEmail = [];
  TextEditingController textController = TextEditingController();

  final key = GlobalKey<FormState>();

  static void Emailsend(String email, String text, List<String> emails) async {
    // is a List

    String username = 'jreadybarberapp@gmail.com';
    String password = "ofrxkrazjczdaowk";
    final smtpServer = gmail(username, password);

      late final message;

      if(emails.length != 0){


       message = Message()

       ..from = Address(username, 'BarberApp')
      
 ..ccRecipients.addAll(emails)
      ..bccRecipients.add(Address(username))
      ..subject = 'Ciao dalla BarberApp!'
      ..text = "Il tuo Barbiere ha qualcosa da dirti!"
      ..html = text;


      }else{

      message = Message()
       ..from = Address(username, 'BarberApp')
      ..recipients.add(email)
      ..bccRecipients.add(Address(username))
      ..subject = 'Ciao dalla BarberApp!'
      ..text = "Il tuo Barbiere ha qualcosa da dirti!"
      ..html = text;
      }
      

   

    try {
      final sendReport = await send(message, smtpServer);

      FirebaseFirestore.instance
          .collection("announcement")
          .add({"date": DateTime.now(), "direct": emails.length == 0 ? email : "all", "notification": text});


           print(text);
    } catch (e) {
 
      print("error");
    }



  }

  @override
  Widget build(BuildContext context) {

  

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(
            text: "Invia Notifica",
            textAlign: TextAlign.center,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.2),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextField(
              maxLength: 80,
              maxLines: 5,
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              controller: textController,
              decoration: InputDecoration(
                  counterStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  hintText: "Scrivi qui il messaggio...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.5))),
            ),
          ),
          toAll
              ? Column(
                  children: [
                    Btn(
                        text: "Invia a...",
                        onTap: () async {
                          await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: CColors.black,
                                  content: SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    width:
                                        MediaQuery.of(context).size.width * .8,
                                    child: FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection("users")
                                          .orderBy("email")
                                          .get(),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return ListView.builder(
                                            itemCount:
                                                snapshot.data.docs.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                  title: TextButton(
                                                      onPressed: () {
                                                        testoMail =
                                                            textController.text;
                                                        if (textController
                                                                .text !=
                                                            "") {
                                                              print("_______________");
                                                          Emailsend(
                                                              snapshot.data
                                                                          .docs[
                                                                      index]
                                                                  ["email"],
                                                              testoMail,
                                                              []);

                                                              

                                                          textController
                                                              .clear();
                                                        Navigator.pop(context);

                                                        } else {}
                                                      },
                                                      child: Text(
                                                        snapshot.data
                                                                .docs[index]
                                                            ["email"],
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      )));
                                            },
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                                  ),
                                );
                              });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection("users")
                            .orderBy("email")
                            .get(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.hasData) {
                              List<String> emails = [];

                              for (var email in snapshot.data.docs) {
                                emails.add(email["email"]);
                              }

                              return Btn(
                                  text: "Invia a tutti",
                                  onTap: () {
                                    if (textController.text != "") {
                                      Emailsend(
                                          email, textController.text, emails);
                                          
                                        

                                      textController.clear();
                                      
                                      barberSnapBar(context, "Notifica inviata", true);
                                    }
                                  });
                            }
                          }
                          return Container();
                        }),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .08,
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Btn(
                      text: "Invia a\n$firstLastName",
                      textAlign: TextAlign.center,
                      fontSize: 18,
                      onTap: () {
                        if (textController.text != "") {
                          
                          Emailsend(firstLastName, textController.text, []);

                          textController.clear();
                          Navigator.pop(context);
                        } else {}
                      }),
                )
        ],
      ),
    );
  }
}
