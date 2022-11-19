import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:scratcher/widgets.dart';
import 'package:confetti/confetti.dart';
import 'package:ticket_widget/ticket_widget.dart';

class RewardPage extends StatefulWidget {
  RewardPage(
      {super.key,
      required this.uid,
      required this.reward,
      required this.userPoints,
      required this.requestedPoints,
      required this.userRewards});

  dynamic uid;
  String reward;
  int userPoints;
  int requestedPoints;
  List<dynamic> userRewards;

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  double brushSize = 25;
  late ConfettiController confettiController = ConfettiController();

  @override
  void initState() {
    confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  Path drawStar(Size size) {
    //path to draw confetti all over the screen
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(alignment: AlignmentDirectional.center, children: [
        CContainer(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * .5,
          width: double.maxFinite,
          radius: 10,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TitleText(
                  text: "Gratta il premio",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Scratcher(
                        brushSize: brushSize,
                        color: Colors.grey,
                        threshold: 40,
                        onThreshold: () {
                          List<dynamic> rewards = [];
                          rewards = widget.userRewards;
                          rewards.add(widget.reward);
                          setState(() {
                            brushSize = 1000;
                          });
                          confettiController.play();
                          FirebaseFirestore.instance
                              .collection("users")
                              .doc(widget.uid)
                              .update({
                            "points":
                                widget.userPoints - widget.requestedPoints,
                            "reward": rewards
                          });
                          Future.delayed(const Duration(milliseconds: 250), () {
                            showDialog(
                              context: context,
                              builder: ((context) => AlertDialog(
                                    backgroundColor: CColors.grey,
                                    title: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: SubTitleText(
                                          text:
                                              "Complimenti! Hai vinto:\n${widget.reward}",
                                        )),
                                  )),
                            );
                          });
                        },
                        child: Opacity(
                          opacity: .7,
                          child: CContainer(
                            radius: 10,
                            color: CColors.black,
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: TicketWidget(
                              padding: EdgeInsets.all(20),
                              isCornerRounded: true,
                              color: CColors.gold,
                              height: MediaQuery.of(context).size.height * 0.2,
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Center(
                                child: Text(
                                  "${widget.reward}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: true,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple
          ], // manually specify the colors to be used
          createParticlePath: drawStar,
        ),
      ]),
    );
  }
}
