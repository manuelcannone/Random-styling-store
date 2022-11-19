import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/admin/notificationPage.dart';
import 'package:randomstylingstore/pages/admin/usersPointsAdmin.dart';
import 'package:randomstylingstore/pages/auth/register.dart';

class PointsCollectionAdminPage extends StatelessWidget {
  const PointsCollectionAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("points")
              .doc("pointsCollection")
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            return snapshot.hasData
                ? snapshot.data["isEnabled"]
                    ? CollectionEnabled(
                        snapshot: snapshot,
                      )
                    : CollectionNotEnabled(
                        snapshot: snapshot,
                      )
                : snapshot.hasError
                    ? Center(
                        child: TitleText(
                          text: "ERRORE ANOMALO! CONTATTA L'ASSISTENZA",
                        ),
                      )
                    : Container();
          }),
    );
  }
}

class CollectionEnabled extends StatelessWidget {
  CollectionEnabled({super.key, required this.snapshot});

  AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleText(
          text: "Informazioni raccolta punti attuale:",
          textAlign: TextAlign.center,
          fontSize: 28,
        ),
        SubTitleText(
          text: snapshot.data["info"],
          textAlign: TextAlign.center,
          fontSize: 24,
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
        ),
        TitleText(
          text: "Premio:",
          textAlign: TextAlign.center,
          fontSize: 28,
        ),
        SubTitleText(
          text: snapshot.data["reward"],
          textAlign: TextAlign.center,
          fontSize: 24,
        ),
        Divider(
          thickness: 2,
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TitleText(
              text: "Punti necessari:",
              textAlign: TextAlign.center,
              fontSize: 28,
            ),
            SubTitleText(
              text: snapshot.data["requestedPoints"].toString(),
              fontSize: 24,
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DecisionButton(
                borderColor: Colors.red,
                backColor: Colors.red.withAlpha(40),
                text: "Elimina",
                function: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: CColors.black,
                        content: SubTitleText(
                          text:
                              "Facendo così eliminerai la raccolta punti attuale. Utilizzare questo comando solo se si vuole iniziare una nuova raccolta punti o eliminare totalmente quella attuale. Per modificare la raccolta punti attuale, usare il tasto \"modifica\".\nSei sicuro di voler eliminare la raccolta punti?",
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
                                FirebaseFirestore.instance
                                    .collection("points")
                                    .doc("pointsCollection")
                                    .update({
                                  "isEnabled": false,
                                  "info": "",
                                  "reward": "",
                                  "requestedPoints": 0,
                                }).then((value) => Navigator.pop(context));
                              },
                              child: Text("Sì",
                                  style: TextStyle(color: Colors.red))),
                        ],
                      );
                    },
                  );
                }),
            DecisionButton(
                borderColor: CColors.gold,
                backColor: CColors.gold.withAlpha(40),
                text: "Modifica",
                function: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditCollectionPage(
                            rewardHint: snapshot.data["reward"],
                            infoHint: snapshot.data["info"],
                            pointsHint:
                                snapshot.data["requestedPoints"].toString())),
                  );
                })
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: DecisionButton(
              borderColor: CColors.gold,
              backColor: CColors.gold.withAlpha(40),
              text: "Gestisci Punti Utenti",
              function: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AppbarFooter(
                            body: UsersPointsPage(),
                            isUserAdmin: isUserAdminGlobal,
                            removeFooter: true,
                            automaticallyImplyLeading: true,
                          )),
                );
              }),
        )
      ],
    );
  }
}

class CollectionNotEnabled extends StatelessWidget {
  CollectionNotEnabled({super.key, required this.snapshot});

  AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: TitleText(
            text: "Il tuo locale non ha una raccolta punti attiva",
            textAlign: TextAlign.center,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: StreamBuilder<Object>(
              stream:
                  FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (context, AsyncSnapshot usersSnapshot) {
                return snapshot.hasData
                    ? DecisionButton(
                        borderColor: CColors.gold,
                        backColor: CColors.gold.withAlpha(40),
                        text: "Attiva Raccolta Punti",
                        function: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateCollectionPage(
                                      snapshot: usersSnapshot,
                                    )),
                          );
                        })
                    : Container();
              }),
        ),
      ],
    );
  }
}

class EditCollectionPage extends StatefulWidget {
  EditCollectionPage(
      {super.key,
      required this.rewardHint,
      required this.infoHint,
      required this.pointsHint});

  String rewardHint;
  String infoHint;
  String pointsHint;

  @override
  State<EditCollectionPage> createState() => _EditCollectionPageState();
}

class _EditCollectionPageState extends State<EditCollectionPage> {
  TextEditingController infoController = TextEditingController();
  TextEditingController rewardController = TextEditingController();
  TextEditingController pointsController = TextEditingController();

  bool rewardError = false;
  bool infoError = false;
  bool pointsError = false;
  String rewardString = "";
  String infoString = "";
  String pointsString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () => Navigator.pop(context),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(
              text: "Modifica Raccolta Punti",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            Column(
              children: [
                cTextField(
                    hintText: widget.rewardHint,
                    controller: rewardController,
                    errorFlag: rewardError,
                    errorString: rewardString),
                cTextField(
                    hintText: widget.infoHint,
                    controller: infoController,
                    errorFlag: infoError,
                    errorString: infoString),
                cTextField(
                    hintText: widget.pointsHint,
                    keyboardType: TextInputType.number,
                    controller: pointsController,
                    errorFlag: pointsError,
                    errorString: pointsString)
              ],
            ),
            DecisionButton(
                borderColor: CColors.gold,
                backColor: CColors.gold.withAlpha(40),
                text: "Modifica Raccolta",
                function: () {
                  if (rewardController.text != "" ||
                      infoController.text != "" ||
                      pointsController.text != "") {
                    rewardError = false;
                    rewardString = "";
                    infoError = false;
                    infoString = "";
                    pointsError = false;
                    pointsString = "";
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: CColors.black,
                          content: RichText(
                            text: TextSpan(
                              text: 'Conferma i dati\n\n',
                              style: TextStyle(fontSize: 20),
                              children: [
                                TextSpan(
                                  text: 'Premio: ',
                                ),
                                TextSpan(
                                    text: rewardController.text != ""
                                        ? rewardController.text
                                        : widget.rewardHint,
                                    style: TextStyle(color: CColors.gold)),
                                TextSpan(text: '\nInformazioni: '),
                                TextSpan(
                                    text: infoController.text != ""
                                        ? infoController.text
                                        : widget.infoHint,
                                    style: TextStyle(color: CColors.gold)),
                                TextSpan(text: '\nPunti richiesti: '),
                                TextSpan(
                                    text: pointsController.text != ""
                                        ? pointsController.text
                                        : widget.pointsHint,
                                    style: TextStyle(color: CColors.gold))
                              ],
                            ),
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
                                  FirebaseFirestore.instance
                                      .collection("points")
                                      .doc("pointsCollection")
                                      .update({
                                    "isEnabled": true,
                                    "info": infoController.text != ""
                                        ? infoController.text
                                        : widget.infoHint,
                                    "reward": rewardController.text != ""
                                        ? rewardController.text
                                        : widget.rewardHint,
                                    "requestedPoints":
                                        pointsController.text != ""
                                            ? int.parse(pointsController.text)
                                            : int.parse(widget.pointsHint),
                                  }).then((value) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text("Sì",
                                    style: TextStyle(color: CColors.gold))),
                          ],
                        );
                      },
                    );
                  } else {
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      ),
    );
  }
}

class CreateCollectionPage extends StatefulWidget {
  CreateCollectionPage({super.key, required this.snapshot});
  AsyncSnapshot snapshot;
  @override
  State<CreateCollectionPage> createState() => _CreateCollectionPageState();
}

class _CreateCollectionPageState extends State<CreateCollectionPage> {
  TextEditingController infoController = TextEditingController();
  TextEditingController rewardController = TextEditingController();
  TextEditingController pointsController = TextEditingController();

  bool rewardError = false;
  bool infoError = false;
  bool pointsError = false;
  String rewardString = "";
  String infoString = "";
  String pointsString = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_sharp),
            onPressed: () => Navigator.pop(context),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(
              text: "Creazione Raccolta Punti",
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            Column(
              children: [
                cTextField(
                    hintText: "Premio",
                    controller: rewardController,
                    errorFlag: rewardError,
                    errorString: rewardString),
                cTextField(
                    hintText: "Informazioni",
                    controller: infoController,
                    errorFlag: infoError,
                    errorString: infoString),
                cTextField(
                    hintText: "Punti Richiesti",
                    keyboardType: TextInputType.number,
                    controller: pointsController,
                    errorFlag: pointsError,
                    errorString: pointsString)
              ],
            ),
            DecisionButton(
                borderColor: CColors.gold,
                backColor: CColors.gold.withAlpha(40),
                text: "Crea Raccolta",
                function: () {
                  if (rewardController.text != "" &&
                      infoController.text != "" &&
                      pointsController.text != "") {
                    rewardError = false;
                    rewardString = "";
                    infoError = false;
                    infoString = "";
                    pointsError = false;
                    pointsString = "";
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: CColors.black,
                          content: RichText(
                            text: TextSpan(
                              text: 'Conferma i dati\n\n',
                              style: TextStyle(fontSize: 20),
                              children: [
                                TextSpan(
                                  text: 'Premio: ',
                                ),
                                TextSpan(
                                    text: rewardController.text,
                                    style: TextStyle(color: CColors.gold)),
                                TextSpan(text: '\nInformazioni: '),
                                TextSpan(
                                    text: infoController.text,
                                    style: TextStyle(color: CColors.gold)),
                                TextSpan(text: '\nPunti richiesti: '),
                                TextSpan(
                                    text: pointsController.text,
                                    style: TextStyle(color: CColors.gold))
                              ],
                            ),
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
                                  FirebaseFirestore.instance
                                      .collection("points")
                                      .doc("pointsCollection")
                                      .update({
                                    "isEnabled": true,
                                    "info": infoController.text,
                                    "reward": rewardController.text,
                                    "requestedPoints":
                                        int.parse(pointsController.text),
                                  }).then((value) {
                                    for (int i = 0;
                                        i < widget.snapshot.data.docs.length;
                                        i++) {
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(widget.snapshot.data.docs[i].id)
                                          .update({"points": 0});
                                    }
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("Sì",
                                    style: TextStyle(color: CColors.gold))),
                          ],
                        );
                      },
                    );
                  }
                  if (rewardController.text == "") {
                    setState(() {
                      rewardError = true;
                      rewardString = "Premio vuoto!";
                    });
                  } else {
                    rewardError = false;
                    rewardString = "";
                  }
                  if (infoController.text == "") {
                    setState(() {
                      infoError = true;
                      infoString = "Informazioni vuote!";
                    });
                  } else {
                    infoError = false;
                    infoString = "";
                  }
                  if (pointsController.text == "") {
                    setState(() {
                      pointsError = true;
                      pointsString = "Punti vuoti!";
                    });
                  } else {
                    pointsError = false;
                    pointsString = "";
                  }
                })
          ],
        ),
      ),
    );
  }
}

class DecisionButton extends StatefulWidget {
  DecisionButton(
      {super.key,
      required this.borderColor,
      required this.backColor,
      required this.text,
      required this.function});

  Color borderColor;
  Color backColor;
  String text;
  Function() function;

  @override
  State<DecisionButton> createState() => _DecisionButtonState();
}

class _DecisionButtonState extends State<DecisionButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.function,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
          ),
          borderRadius: BorderRadius.circular(5),
          color: widget.backColor,
        ),
        alignment: Alignment.center,
        //width: 150,
        //height: 50,
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
    );
  }
}
