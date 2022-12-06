import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:randomstylingstore/pages/admin/userNotes.dart';
import 'package:randomstylingstore/pages/admin/usersAdmin.dart';

import '../../main.dart';

Stream<QuerySnapshot<Map<String, dynamic>>> getNotes(uid) {
  return FirebaseFirestore.instance
      .collection("usersNotes")
      .where("uid", isEqualTo: uid)
      .orderBy("date", descending: true)
      .snapshots();
}

class UserPageAdmin extends StatelessWidget {
  UserPageAdmin({super.key, required this.uid});
  dynamic uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream:
            FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(
                            height: 20,
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
                          SizedBox(
                            height: 20,
                          ),
                          Label(
                              type: "Nominativo",
                              text: snapshot.data["firstAndLastNames"]),
                          SizedBox(
                            height: 20,
                          ),
                          Label(type: "Email", text: snapshot.data["email"]),
                          SizedBox(
                            height: 20,
                          ),
                          Label(
                              type: "Numero di Telefono",
                              text: snapshot.data["mobile"]),
                          SizedBox(
                            height: 20,
                          ),
                          UsersNotes(
                            uid: uid,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          /*  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Btn(
                                text: snapshot.data["banned"]
                                    ? "Sblocca"
                                    : "Blocca",
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        //cant extract this widget
                                        backgroundColor: CColors.black,
                                        content: RichText(
                                          text: TextSpan(
                                              style: TextStyle(
                                                  color: Colors.white),
                                              text: snapshot.data["banned"]
                                                  ? "Sei sicuro di voler sbloccare l'accesso a "
                                                  : "Sei sicuro di voler bloccare l'accesso a ",
                                              children: [
                                                TextSpan(
                                                    text: snapshot.data[
                                                        "firstAndLastNames"],
                                                    style: TextStyle(
                                                        color: CColors.gold)),
                                                TextSpan(
                                                    text: "?",
                                                    style: TextStyle(
                                                        color: Colors.white))
                                              ]),
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
                                                Navigator.pop(context);
                                                await FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(uid)
                                                    .update({
                                                  "banned":
                                                      !snapshot.data["banned"]
                                                });
                                              },
                                              child: Text("Sì",
                                                  style: TextStyle(
                                                      color: CColors.gold))),
                                        ],
                                      );
                                    },
                                  );

                                  //   await FirebaseFirestore.instance.collection("users").doc(snapshot.data.docs[index].id).update({
                                  //   "banned" : !snapshot.data.docs[index]["banned"]
                                  // });
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ), */
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(
                  color: CColors.gold,
                ));
        });
  }
}

class UsersNotes extends StatelessWidget {
  UsersNotes({
    Key? key,
    required this.uid,
  }) : super(key: key);
  String uid;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CContainer(
          color: CColors.grey.withOpacity(.3),
          width: MediaQuery.of(context).size.width * .88,
          height: 400,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          radius: 5,
          child: Column(
            children: [
              SubTitleText(
                text: "Note",
                fontSize: 20,
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: getNotes(uid),
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.docs.length <= 5
                                ? snapshot.data.docs.length
                                : 5,
                            itemBuilder: (context, index) {
                              return Opacity(
                                opacity: 1 - index * .25,
                                child: UserNote(
                                  text: snapshot.data.docs[index]["text"],
                                  date: snapshot.data.docs[index]["date"],
                                  noteId: snapshot.data.docs[index].id,
                                ),
                              );
                            },
                          )
                        : Container();
                  },
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
              ),
              Row(
                children: [
                  Expanded(
                      child: Btn(
                    fontSize: 15,
                    text: "Visualizza Altro",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppbarFooter(
                                  body: AllUserNotes(
                                    uid: uid,
                                  ),
                                  isUserAdmin: isUserAdminGlobal,
                                  automaticallyImplyLeading: true,
                                  removeFooter: true,
                                  //removeFooter: true,
                                )),
                      );
                    },
                  )),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: Btn(
                    text: "Scrivi Nota",
                    fontSize: 15,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppbarFooter(
                                  body: WriteNote(
                                    uid: uid,
                                  ),
                                  isUserAdmin: isUserAdminGlobal,
                                  automaticallyImplyLeading: true,
                                  //removeFooter: true,
                                )),
                      );
                    },
                  ))
                ],
              )
            ],
          ),
        )
      ],
    );
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
