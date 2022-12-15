import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/selectServices&Booking.dart';
import 'package:randomstylingstore/pages/services.dart';
import 'package:tcard/tcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randomstylingstore/main.dart';
import "package:randomstylingstore/toChange.dart" as globalString;


final FirebaseAuth auth = FirebaseAuth.instance;



List<Widget> cards = List.generate(
  globalString.images.length,
  (index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 17),
            blurRadius: 23.0,
            spreadRadius: -13.0,
            color: Colors.black54,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          globalString.images[index],
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  backgroundColor: CColors.gold,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xff181818))),
            );
          },
        ),
      ),
    );
  },
);

class BarberHome extends StatelessWidget {
  BarberHome({super.key});

  // dynamic userId;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(auth.currentUser?.uid)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //se lo stato dello snapshot e` in attesa:

            return Container(
              child: Center(
                child: CircularProgressIndicator(
                    backgroundColor: CColors.gold,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff181818))),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 20.0,
                ),
                height: MediaQuery.of(context).size.height * 0.90,
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Benvenuto su ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 27),
                                        ),
                                        TextSpan(
                                          text: globalString.adminName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 27),
                                        ),
                                        TextSpan(
                                          text: snapshot
                                              .data['firstAndLastNames'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: CColors.gold,
                                              fontSize: 27,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                  padding: const EdgeInsets.only(
                                    top: 80.0,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: ElevatedButton(
                                    child: Text(
                                      'Prenota',
                                      style: TextStyle(fontSize: 20),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AppbarFooter(
                                                  body:
                                                      const SelectServicesAndBooking(),
                                                  isUserAdmin:
                                                      isUserAdminGlobal,
                                                  automaticallyImplyLeading:
                                                      true,
                                                  removeFooter: true,
                                                )),
                                      );
                                    },
                                  ))
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        height: MediaQuery.of(context).size.height * 0.54,
                        child: TCardPage(),
                      ),
                    ]),
              );
            }
            if (snapshot.hasError) {
              return Container(
                child: Text('errore'),
              );
            }
          }
          return Container();
        });
  }
}

class TCardPage extends StatefulWidget {
  @override
  _TCardPageState createState() => _TCardPageState();
}

class _TCardPageState extends State<TCardPage> {
  TCardController _controller = TCardController();

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height * 0.60;
    double sizeWidth = MediaQuery.of(context).size.height * 0.60;
    return Scaffold(
      body: Center(
        child: TCard(
          size: Size(sizeWidth, sizeHeight),
          cards: cards,
          controller: _controller,
          onForward: (index, info) {
            _index = index;
            //_index == cards.length-- ? cards.addAll(cards) : null;
            print(info.direction);
            setState(() {});
          },
          onBack: (index, info) {
            _index = index;
            setState(() {});
          },
          onEnd: () {
            print('end');
            _controller.reset();
          },
        ),
      ),
    );
  }
}
