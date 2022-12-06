import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:intl/intl.dart';
import 'package:randomstylingstore/pages/admin/userPageAdmin.dart';
import 'package:randomstylingstore/pages/admin/usersAdmin.dart';
import '../../commonWidgets.dart';

TextEditingController textController = TextEditingController();

class AllUserNotes extends StatelessWidget {
  AllUserNotes({super.key, required this.uid});

  String uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(uid)
                .snapshots(),
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? SubTitleText(
                      text: "Note di ${snapshot.data["firstAndLastNames"]}",
                      fontSize: 20,
                    )
                  : Container();
            },
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
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return UserNote(
                            text: snapshot.data.docs[index]["text"],
                            date: snapshot.data.docs[index]["date"],
                            noteId: snapshot.data.docs[index].id,
                          );
                        },
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WriteNote extends StatelessWidget {
  WriteNote({super.key, required this.uid});

  String uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(uid)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SubTitleText(
                        fontSize: 28,
                        text:
                            "Nuova nota per ${snapshot.data["firstAndLastNames"]}",
                        textAlign: TextAlign.center,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      SendNote(
                        uid: uid,
                      )
                    ],
                  )
                : Container();
          }),
    );
  }
}

class SendNote extends StatelessWidget {
  SendNote({Key? key, required this.uid}) : super(key: key);

  String uid;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
        SizedBox(
          height: 15,
        ),
        Btn(
            text: "Aggiungi Nota",
            onTap: () {
              FirebaseFirestore.instance
                  .collection("usersNotes")
                  .add({
                    "text": textController.text,
                    "date": DateTime.now(),
                    "uid": uid
                  })
                  .then((value) => textController.clear())
                  .then((value) => Navigator.pop(context));
            })
      ],
    );
  }
}

class UserNote extends StatelessWidget {
  UserNote(
      {super.key,
      required this.text,
      required this.date,
      required this.noteId});

  String text;
  String noteId;
  Timestamp date;

  @override
  Widget build(BuildContext context) {
    return CContainer(
      radius: 5,
      height: 110,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 0,
          ),
          SubTitleText(
            text: text,
            textAlign: TextAlign.start,
            //overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(
                  Icons.delete,
                  color: CColors.gold,
                  size: 20,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: CColors.black,
                        content: Text(
                          "Sei sicuro di voler cancellare \n\"$text\"?",
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No",
                                  style: TextStyle(color: CColors.gold))),
                          TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection("usersNotes")
                                    .doc(noteId)
                                    .delete()
                                    .then((value) => Navigator.pop(context));
                              },
                              child: Text("Sì",
                                  style: TextStyle(color: CColors.gold))),
                        ],
                      );
                    },
                  );
                },
              ),
              SubTitleText(
                  text: DateFormat('kk:mm - dd/MM/yy')
                      .format(date.toDate())
                      .toString()),
            ],
          )
        ],
      ),
    );
  }
}
