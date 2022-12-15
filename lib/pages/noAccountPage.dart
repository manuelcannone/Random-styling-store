import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/auth/login.dart';
import 'package:randomstylingstore/pages/auth/register.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NoAccountPage extends StatelessWidget {
  NoAccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 3,
                  child: Container(
                    child: FlutterMap(
                      options: MapOptions(
                          center: LatLng(globalLat, globalLng),
                          zoom: 13,
                          maxZoom: 50,
                          //bounds: LatLngBounds(
                          //  LatLng(51.74920, -0.56741),
                          //  LatLng(51.25709, 0.34018),
                          // ),
                          interactiveFlags: InteractiveFlag.none),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.randomstylingstore',
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 8,
                  child: Container(
                    color: Colors.transparent,
                  ))
            ],
          ),
          Column(children: [
            Expanded(
                flex: 1,
                child: Container(
                  color: Colors.transparent,
                )), //MAP
            Expanded(
              flex: 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("media/barberlogo.png"),
                    Address(addressText: "Via Carlo Minciotti n.15"),
                    Services(),
                    SizedBox()
                  ],
                ),
                decoration: BoxDecoration(
                    color: CColors.grey,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
              ),
            ) //CI TROVI QUI
          ]),
        ],
      ),
    );
  }
}

class Address extends StatelessWidget {
  Address({super.key, required this.addressText});
  String addressText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleText(
          text: "CI TROVI QUI:",
          fontSize: 28,
        ),
        SizedBox(
          height: 10,
        ),
        SubTitleText(
          text: addressText,
          textAlign: TextAlign.center,
          fontSize: 24,
        ),
      ],
    );
  }
}

class Services extends StatelessWidget {
  const Services({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleText(
          text: "Per usufruire dei nostri servizi:",
          fontSize: 26,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Text("Registrati")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                firstPage: false,
                              )));
                },
                child: Text("Accedi")),
          ],
        )
      ],
    );
  }
}
