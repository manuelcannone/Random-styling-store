import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:ticket_widget/ticket_widget.dart';

class ClaimRewardPage extends StatelessWidget {
  ClaimRewardPage({super.key, required this.uid});

  dynamic uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24, horizontal: 15),
                      child: CContainer(
                        radius: 10,
                        color: CColors.grey,
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TitleText(
                              text: "Il tuo premio",
                              fontWeight: FontWeight.bold,
                            ),
                            CContainer(
                              color: CColors.black.withOpacity(.5),
                              radius: 10,
                              padding: EdgeInsets.all(10),
                              child: snapshot.data["reward"].toString() == "[]"
                                  ? SubTitleText(
                                      text:
                                          "Non hai premi disponibili. Continua a usufruire dei nostri servizi per vincere premi!",
                                      fontSize: 24,
                                      textAlign: TextAlign.center,
                                    )
                                  : TicketWidget(
                                      padding: EdgeInsets.all(20),
                                      isCornerRounded: true,
                                      color: CColors.gold,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Center(
                                        child: Text(
                                          snapshot.data["reward"][0],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 24),
                                        ),
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 9),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SubTitleText(
                                    text:
                                        "Ne hai ancora: x${snapshot.data["reward"].length}",
                                    fontSize: 24,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TitleText(
                            text: "Scorri per riscattare il tuo premio",
                            textAlign: TextAlign.center,
                          ),
                          Divider(
                            thickness: 1,
                            color: CColors.gold,
                          ),
                          CommonSlider(
                            text: "Riscatta",
                            function: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: CColors.black,
                                    content: Text(
                                      "Conferma solo se ti trovi dal tuo barbiere/parrucchiere.\n\nAttenzione: Premendo \"Sì\" riscatterai il buono e non sarà più utilizzabile",
                                      style: TextStyle(color: Colors.white),
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
                                            List<dynamic> rewards = [];
                                            rewards = snapshot.data["reward"];
                                            rewards.removeAt(0);
                                            print(rewards);
                                            FirebaseFirestore.instance
                                                .collection("users")
                                                .doc(uid)
                                                .update({
                                              "reward": rewards
                                            }).then((value) =>
                                                    Navigator.pop(context));
                                          },
                                          child: Text("Sì",
                                              style: TextStyle(
                                                  color: CColors.gold))),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : Container();
      },
    );
  }
}
