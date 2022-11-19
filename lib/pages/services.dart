import 'package:animation_list/animation_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/booking.dart';

String selectServiceSex = "";

class Services extends StatefulWidget {
  Services({super.key, required this.serviceSex});

  String serviceSex;

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  ScrollController animationListController = ScrollController();

  @override
  void dispose() {
    animationListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    selectServiceSex = widget.serviceSex;

    return Container(
      margin: EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("services/")
                .where("type", isEqualTo: widget.serviceSex)
                .snapshots(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Color(0xffAE8952), valueColor: AlwaysStoppedAnimation<Color>(Color(0xff181818))),
                );
              } else {
                if (snapshot.hasData) {
                  List nameAndPrice = [];

                  for (var element in snapshot.data.docs) {
                    nameAndPrice.add([element["name"], element["price"]]);
                  }

                  return AnimationList(
                    controller: animationListController,
                    shrinkWrap: true,
                    children: nameAndPrice.map((item) {
                      return CService(
                        name: item[0],
                        price: item[1],
                      );
                    }).toList(),
                    duration: 2500,
                    reBounceDepth: 5.0,
                  );
                }
              }

              return Container();
            })),
      ),
    );
  }
}

class CService extends StatelessWidget {
  CService({super.key, required this.name, required this.price});

  String name;
  dynamic price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AppbarFooter(
                      body: Booking(
                        sex: selectServiceSex,
                        services: name,
                        price: price,
                      ),
                      isUserAdmin: isUserAdminGlobal,
                      automaticallyImplyLeading: true,
                    )));
      },
      child: CContainer(
        margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.85,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Text(
                        //   type,
                        //   style: TextStyle(
                        //     color: Colors.grey,
                        //     fontSize: 15,
                        //   ),
                        // ),
                        Text(
                          price.toString() + "€",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Transform.rotate(
              angle: 5.2,
              child: Image(width: 40, image: AssetImage("media/shave.png")),
            ),
          ],
        ),
      ),
    );
  }
}
