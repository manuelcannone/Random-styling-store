import 'package:animation_list/animation_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/main.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.08,
          child: Text(
            "Notifiche",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.9,
            child: StreamNotAdmin())
      ],
    );
  }
}

class StreamNotAdmin extends StatelessWidget {
  const StreamNotAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: isUserAdminGlobal
          ? FirebaseFirestore.instance.collection('announcement/').snapshots()
          : FirebaseFirestore.instance
              .collection('announcement/')
              .where("direct", whereIn: ["tutti", auth.currentUser?.email]).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        print(auth.currentUser?.email);
        {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              List data = [];

              for (var notificationData in snapshot.data.docs) {
                data.add([
                  notificationData["notification"],
                  notificationData["direct"],
                  notificationData.id,
                ]);
              }
              return Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.9,
                margin: EdgeInsets.only(bottom: 150),
                child: AnimationList(
                  shrinkWrap: true,
                  children: data.map((item) {
                    return NotificationItem(text: item[0], email: item[1], id: item[2]);
                  }).toList(),
                  duration: 2500,
                  reBounceDepth: 5.0,
                ),
              );
            }
          }
        }
        return Container();
      },
    );
  }
}

class NotificationItem extends StatelessWidget {
  NotificationItem({super.key, required this.text, required this.email, required this.id});

  String text;
  String email;
  dynamic id;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: CColors.grey,
        ),
        margin: EdgeInsets.only(top: 10, bottom: 10),
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Column(children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.50 * 0.90,
                  height: MediaQuery.of(context).size.height * 0.50 * 0.15,
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.90 * 0.90,
                          height: isUserAdminGlobal
                              ? MediaQuery.of(context).size.height * 0.70 * 0.25
                              : MediaQuery.of(context).size.height * 0.25,
                          child: Center(
                            child: Text(
                              text,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )),
                      isUserAdminGlobal
                          ? EmailNotification(
                              date: Timestamp.fromDate(DateTime.now()),
                              id: id,
                              email: email,
                              notification: text,
                            )
                          : Container(color: Colors.red,),
                    ],
                  ))),
        ]),
      ),
    );
  }
}

class EmailNotification extends StatefulWidget {
  EmailNotification({super.key, required this.date, required this.email, required this.id, required this.notification});

  String email;
  dynamic id;
  String notification;
  Timestamp date;

  @override
  State<EmailNotification> createState() => _EmailNotificationState();
}

class _EmailNotificationState extends State<EmailNotification> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95 * 0.90,
      height: MediaQuery.of(context).size.height * 0.30 * 0.25,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.70 * 0.95 * 0.90,
            height: MediaQuery.of(context).size.height * 0.5 * 0.30 * 0.25,
            child: Text(
              widget.email,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          Container(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    _controller.text = widget.notification.toString();

                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: CColors.grey,
                        title: const Text(
                          'Modifica notifica',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: TextField(
                          decoration: InputDecoration(
                            counterStyle: TextStyle(color: Colors.white),
                          ),
                          style: TextStyle(color: Colors.white),
                          maxLength: 80,
                          cursorColor: Colors.white,
                          controller: _controller,
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancella'),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_controller.text != "") {
                                FirebaseFirestore.instance.collection("announcement").doc(widget.id).update(
                                    {"date": DateTime.now(), "direct": widget.email, "notification": _controller.text});
                                _controller.clear();
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Modifica'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15 * 0.95 * 0.90,
                    height: MediaQuery.of(context).size.height * 0.5 * 0.30 * 0.25,
                    color: CColors.grey,
                    child: Center(
                        child: Icon(
                      Icons.edit,
                      size: 20,
                    )),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        backgroundColor: CColors.grey,
                        title: const Text(
                          'Cancella notifica',
                          style: TextStyle(color: Colors.white),
                        ),
                        content: const Text(
                          'Sei sicuro di voler cancellare la notifica?',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseFirestore.instance.collection("announcement").doc(widget.id).delete();
                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('Sì'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.15 * 0.95 * 0.90,
                    height: MediaQuery.of(context).size.height * 0.5 * 0.30 * 0.25,
                    color: CColors.grey,
                    child: Center(
                        child: Icon(
                      Icons.delete,
                      size: 20,
                      color: Colors.red,
                    )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
