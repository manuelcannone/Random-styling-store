import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/admin/pointsCollectionAdmin.dart';
import 'package:randomstylingstore/pages/admin/usersAdmin.dart';

class UsersPointsPage extends StatelessWidget {
  UsersPointsPage({super.key});

  var getUsers = FirebaseFirestore.instance
      .collection("users")
      .where("banned", isEqualTo: false)
      .orderBy("email")
      .snapshots();
  String searchName = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: StreamBuilder<Object>(
          stream: getUsers,
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.connectionState == ConnectionState.active
                ? Column(
                    children: [
                      QueryField(onChanged: (value) {}),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return UsersViewPoint(
                                  snapshot: snapshot, index: index);
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 10),
                        child: DecisionButton(
                            borderColor: CColors.gold,
                            backColor: CColors.gold.withAlpha(40),
                            text: "Azzera Punti",
                            function: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    //cant extract this widget
                                    backgroundColor: CColors.black,
                                    content: SubTitleText(
                                      text:
                                          "Facendo così azzererai i punti a tutti gli utenti.\nSei sicuro di voler proseguire?",
                                      fontSize: 20,
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
                                            for (int i = 0;
                                                i < snapshot.data.docs.length;
                                                i++) {
                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(snapshot.data.docs[i].id)
                                                  .update({"points": 0});
                                            }
                                          },
                                          child: Text("Sì",
                                              style: TextStyle(
                                                  color: CColors.gold))),
                                    ],
                                  );
                                },
                              );
                            }),
                      )
                    ],
                  )
                : Container();
          }),
    );
  }
}

class UsersViewPoint extends StatefulWidget {
  UsersViewPoint({super.key, required this.snapshot, required this.index});

  AsyncSnapshot snapshot;
  int index;
  double opacity = 1;

  @override
  State<UsersViewPoint> createState() => _UsersViewPointState();
}

class _UsersViewPointState extends State<UsersViewPoint> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserPointsLabel(
              name: widget.snapshot.data.docs[widget.index]
                  ["firstAndLastNames"],
              email: widget.snapshot.data.docs[widget.index]["email"],
            ),
            Row(
              children: [
                AddRemovePoints(
                    borderColor: CColors.gold,
                    backColor: CColors.gold.withAlpha(40),
                    text: "-",
                    function: () {
                      widget.snapshot.data.docs[widget.index]["points"] == 0
                          ? null
                          : FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.snapshot.data.docs[widget.index].id)
                              .update({
                              "points": widget.snapshot.data.docs[widget.index]
                                      ["points"] -
                                  1
                            });
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.snapshot.data.docs[widget.index]["points"]
                        .toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
                AddRemovePoints(
                    borderColor: CColors.gold,
                    backColor: CColors.gold.withAlpha(40),
                    text: "+",
                    function: () {
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(widget.snapshot.data.docs[widget.index].id)
                          .update({
                        "points": widget.snapshot.data.docs[widget.index]
                                ["points"] +
                            1
                      });
                    }),
              ],
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: CColors.gold,
        )
      ],
    );
  }
}

class AddRemovePoints extends StatefulWidget {
  AddRemovePoints({
    super.key,
    required this.borderColor,
    required this.backColor,
    required this.text,
    required this.function,
  });

  Color borderColor;
  Color backColor;
  String text;
  Function() function;

  @override
  State<AddRemovePoints> createState() => _AddRemovePointsState();
}

class _AddRemovePointsState extends State<AddRemovePoints> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        height: 43,
        width: 43,
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
          ),
          shape: BoxShape.circle,
          color: widget.backColor,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 35),
        ),
      ),
    );
  }
}

class UserPointsLabel extends StatelessWidget {
  UserPointsLabel({Key? key, required this.name, required this.email})
      : super(key: key);

  String name;
  String email;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.person_rounded,
          color: CColors.gold,
        ),
        SizedBox(
          width: 5,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: Text(
                email,
                style: TextStyle(color: CColors.gold, fontSize: 11),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
