import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/rewardPage.dart';

class PointsPage extends StatelessWidget {
  PointsPage({super.key, required this.uid});

  dynamic uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("points")
              .doc("pointsCollection")
              .snapshots(),
          builder: (context, AsyncSnapshot pointsSnapshot) {
            return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  return snapshot.hasError
                      ? Text("Error")
                      : snapshot.hasData
                          ? SingleChildScrollView(
                              child: Column(
                                children: [
                                  FidelityCard(
                                    snapshot: snapshot,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Points(
                                    pointsSnapshot: pointsSnapshot,
                                    snapshot: snapshot,
                                    uid: uid,
                                  ),
                                ],
                              ),
                            )
                          : Container();
                });
          }),
    );
  }
}

class Points extends StatelessWidget {
  Points(
      {super.key,
      required this.snapshot,
      required this.pointsSnapshot,
      required this.uid});

  dynamic uid;
  AsyncSnapshot snapshot;
  AsyncSnapshot pointsSnapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "I Tuoi Punti: ${snapshot.data["points"]} / ${pointsSnapshot.data["requestedPoints"]}",
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: ((context) => AlertDialog(
                          backgroundColor: CColors.grey,
                          title: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: SubTitleText(
                                text: pointsSnapshot.data["info"],
                              )),
                        )),
                  );
                },
                child: Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ))
          ],
        ),
        Divider(
          thickness: 1,
          color: CColors.gold,
        ),
        SizedBox(
          height: 20,
        ),
        snapshot.data["points"] >= pointsSnapshot.data["requestedPoints"]
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppbarFooter(
                                        isUserAdmin: isUserAdminGlobal,
                                        automaticallyImplyLeading: true,
                                        body: RewardPage(
                                          uid: uid,
                                          reward: pointsSnapshot.data["reward"],
                                          userPoints: snapshot.data["points"],
                                          requestedPoints: pointsSnapshot
                                              .data["requestedPoints"],
                                          userRewards: snapshot.data["reward"],
                                        ),
                                        removeFooter: true,
                                      )),
                            );
                          },
                          child: Text("Riscatta il tuo premio!")),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              )
            : Container(),
        SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: GridView.builder(
              //physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
              ),
              itemBuilder: (context, index) => SinglePoint(
                isEarned: snapshot.data["points"] >= index + 1,
                index: index,
              ),
              itemCount: snapshot.data["points"] <=
                      pointsSnapshot.data["requestedPoints"]
                  ? pointsSnapshot.data["requestedPoints"]
                  : snapshot.data["points"],
            ),
          ),
        )
      ],
    );
  }
}

class SinglePoint extends StatelessWidget {
  SinglePoint({super.key, required this.isEarned, required this.index});

  bool isEarned;
  int index;

  @override
  Widget build(BuildContext context) {
    return CContainer(
      radius: 360,
      alignment: Alignment.center,
      color: isEarned ? CColors.gold : CColors.grey,
      child: Text(
        isEarned ? "${index + 1}" : "",
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class PointsScratch extends StatelessWidget {
  const PointsScratch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class FidelityCard extends StatelessWidget {
  FidelityCard({super.key, required this.snapshot});

  AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return CContainer(
      padding: EdgeInsets.all(16),
      height: 200,
      width: double.maxFinite,
      radius: 10,
      color: Colors.black.withAlpha(240),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(
              text: "Fidelity Card",
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  snapshot.data["firstAndLastNames"],
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                    height: 50, child: Image.asset("media/barberlogo.png")),
              ],
            )
          ]),
    );
  }
}
