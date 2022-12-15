import 'dart:developer';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/admin/gestionService.dart';
import 'package:randomstylingstore/pages/booking.dart';
import 'package:randomstylingstore/pages/home.dart';
import 'package:randomstylingstore/pages/selectServices&Booking.dart';
import 'package:randomstylingstore/pages/services.dart';
import 'package:tcard/tcard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_core/firebase_core.dart';

class ContainerGestionManWoman extends StatelessWidget {
  const ContainerGestionManWoman({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GestionWomanMan(
          type: "man",
        ),
        GestionWomanMan(
          type: "woman",
        )
      ],
    );
  }
}

// UOMO O DONNA COLLAPSED => CollpasedService Crea la lista => ServiceItem Crea elemento
class GestionWomanMan extends StatefulWidget {
  GestionWomanMan({super.key, required this.type});

  String type;

  @override
  State<GestionWomanMan> createState() => _GestionWomanManState();
}

class _GestionWomanManState extends State<GestionWomanMan> {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Card(
        color: CColors.black,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  iconColor: Colors.white,
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Container(
                    child: Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Text(
                    widget.type == "man" ? "Uomo" : "Donna",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                )),
                collapsed: SizedBox(height: 0),

                // list of service
                expanded: CollapedService(
                  type: widget.type,
                ),

                builder: (_, collapsed, expanded) {
                  return Container(
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CollapedService extends StatefulWidget {
  CollapedService({super.key, required this.type});

  String type;

  @override
  State<CollapedService> createState() => _CollapedServiceState();
}

class _CollapedServiceState extends State<CollapedService> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("services/")
            .where("type", isEqualTo: widget.type)
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          //loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * 0.2,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            List<Widget> services = [];

            for (var service in snapshot.data!.docs) {
              services.add(ServiceItem(
                  name: service["name"],
                  price: service["price"],
                  id: service?.id));
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  children: services,
                ),

                //bottone per aggiungere una prenotazione
                AddService(type: widget.type)
              ],
            );
          } else if (snapshot.hasError) {
            Center(
              child: Container(
                child: Text(
                  'ERRORE, RIPROVA PIÙ TARDI',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }

          return Container();
        });
  }
}

class ServiceItem extends StatelessWidget {
  ServiceItem(
      {super.key, required this.name, required this.price, required this.id});

  String name;
  dynamic price;
  String id;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(),
        margin: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name + " " + price.toString() + "€",
              style: TextStyle(color: Colors.white, fontSize: 25),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.red,
              ),
              height: 40,
              width: 40,
              child: IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 20,
                color: Colors.white,
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("services/")
                      .doc(id)
                      .delete();
                },
              ),
            ),
          ],
        ));
  }
}

// aggiungi servizio

class AddService extends StatefulWidget {
  AddService({super.key, required this.type});

  String type;
  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  Future<void> _displayTextInputDialog(BuildContext context) async {

    TextEditingController _textFieldControllerService = TextEditingController();
    TextEditingController _textFieldControllerPrice = TextEditingController();
    String? _dropDownValue = null;

    return showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (context
      ) {
          

        return AlertDialog(
            
                
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     TextField(
                      cursorColor: Colors.white,
                      controller: _textFieldControllerService,
                      decoration: InputDecoration(
                          hintText: "Servizio",
                          hintStyle:
                              TextStyle(fontSize: 16.0, color: Colors.grey)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.white,
                      controller: _textFieldControllerPrice,
                      decoration: InputDecoration(
                          hintText: "Prezzo",
                          hintStyle:
                              TextStyle(fontSize: 16.0, color: Colors.grey)),
                    ),

                  DropdownButton<String>(
                    hint: Text("Tempistica") ,

                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(child: 
                      Text("Normale"),
                      value: "",
                    ),

                       DropdownMenuItem(child: 
                      Text("Veloce"),
                      value: "1",
                    ),
                          DropdownMenuItem(child: 
                      Text("lento"),
                      value: "2",
                    ),
                  ],
                  onChanged: (val){
                    setState(() {
                       _dropDownValue = val!;

                    });
                    
                  },

                ),


                  SizedBox(
                    height: 20,
                  ),
                      Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                     
                 
                      

                      ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                      }, child: Text('Annulla',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white)),),
                      

ElevatedButton(
                        style: ButtonStyle(    backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
),
                        onPressed: (){
                        setState(() {
                              FirebaseFirestore.instance
                                  .collection("services/")
                                  .doc()
                                  .set(
                                {
                                  'name': _textFieldControllerService.text,
                                  'price': _textFieldControllerPrice.text,
                                  'type': widget.type,
                                  "typology" : _dropDownValue,
                                },
                              );
                              print(_textFieldControllerService.text);
                                Navigator.pop(context);
                            });
                          

                      }, child: Text('Invia',
                                  style: TextStyle(
                                      fontSize: 20.0, color: CColors.gold)),
                            ),

                    
                    ],
                  ),
                  ],
                ),
              ),
            );
          },
        );

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: GestureDetector(
        onTap: () {
          print(
              '********************************************************************************');
          _displayTextInputDialog(context);
        },
        child: Text(
          '+ Aggiungi ora',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
