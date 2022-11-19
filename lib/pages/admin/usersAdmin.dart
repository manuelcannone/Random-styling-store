import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:randomstylingstore/pages/admin/notificationPage.dart';
import 'package:randomstylingstore/pages/userPage.dart';
import '../../commonWidgets.dart';

var getUsers =
    FirebaseFirestore.instance.collection("users").orderBy("email").snapshots();
String searchName = "";

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
      child: Column(
        children: [
          QueryField(
            onChanged: (value) {
              searchName = value;
            },
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(child: UserList())
        ],
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getUsers,
        builder: (
          context,
          AsyncSnapshot snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var data =
                    snapshot.data.docs[index].data() as Map<String, dynamic>;
                if (searchName.isEmpty) {
                  return UsersView(
                    snapshot: snapshot,
                    index: index,
                  );
                }
                if (data["firstAndLastNames"]
                    .toString()
                    .toLowerCase()
                    .startsWith(searchName.toLowerCase())) {
                  return UsersView(
                    snapshot: snapshot,
                    index: index,
                  );
                }
                return Container();
              },
            );
          } else if (snapshot.hasError) {
            Center(
              child: Text("ERRORE"),
            );
          }
          return Container();
        });
  }
}

class UsersView extends StatelessWidget {
  UsersView({
    Key? key,
    required this.snapshot,
    required this.index,
  }) : super(key: key);

  AsyncSnapshot snapshot;
  int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AppbarFooter(
                  automaticallyImplyLeading: true,
                  body: UserPage(
                      uid: snapshot.data.docs[index].id, fromUsersAdmin: true),
                  isUserAdmin: isUserAdminGlobal,
                )),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserNameAndPhone(
            name: snapshot.data.docs[index]["firstAndLastNames"],
            phone: snapshot.data.docs[index]["mobile"],
            banned: snapshot.data.docs[index]["banned"],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              UserPageBtn(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: CColors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    )),
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        width: double.maxFinite,
                        height: 250,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              snapshot.data.docs[index]["firstAndLastNames"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: CColors.gold,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Divider(
                                color: Colors.white,
                                thickness: 1.5,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Btn(
                                  text: "Invia Notifica",
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AppbarFooter(
                                                automaticallyImplyLeading: true,
                                                body: NotificationPage(
                                                  toAll: false,
                                                  firstLastName:
                                                      snapshot.data.docs[index]
                                                          ["firstAndLastNames"],
                                                  email: snapshot.data
                                                      .docs[index]["email"],
                                                ),
                                                isUserAdmin: isUserAdminGlobal,
                                              )),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                flex: 3,
                text: snapshot.data.docs[index]["email"],
              ),
              SizedBox(
                width: 15,
              ),
              UserPageBtn(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          //cant extract this widget
                          backgroundColor: CColors.black,
                          content: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.white),
                                text: snapshot.data.docs[index]["banned"]
                                    ? "Sei sicuro di voler sbloccare l'accesso a "
                                    : "Sei sicuro di voler bloccare l'accesso a ",
                                children: [
                                  TextSpan(
                                      text: snapshot.data.docs[index]
                                          ["firstAndLastNames"],
                                      style: TextStyle(color: CColors.gold)),
                                  TextSpan(
                                      text: "?",
                                      style: TextStyle(color: Colors.white))
                                ]),
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
                                  Navigator.pop(context);
                                  await FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(snapshot.data.docs[index].id)
                                      .update({
                                    "banned": !snapshot.data.docs[index]
                                        ["banned"]
                                  });
                                },
                                child: Text("Sì",
                                    style: TextStyle(color: CColors.gold))),
                          ],
                        );
                      },
                    );

                    //   await FirebaseFirestore.instance.collection("users").doc(snapshot.data.docs[index].id).update({
                    //   "banned" : !snapshot.data.docs[index]["banned"]
                    // });
                  },
                  flex: 1,
                  text: snapshot.data.docs[index]["banned"]
                      ? "Sblocca"
                      : "Blocca")
            ],
          ),
          Divider(
            color: CColors.gold,
            thickness: 1.5,
          )
        ],
      ),
    );
  }
}

class Btn extends StatelessWidget {
  Btn(
      {Key? key,
      required this.text,
      required this.onTap,
      this.fontSize = 30,
      this.textAlign})
      : super(key: key);

  String text;
  void Function() onTap;
  double fontSize;
  TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: CColors.gold),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Text(
          text,
          style: TextStyle(color: Colors.white, fontSize: fontSize),
          textAlign: textAlign,
        ),
      ),
    );
  }
}

class UserNameAndPhone extends StatelessWidget {
  UserNameAndPhone(
      {Key? key, required this.name, required this.phone, required this.banned})
      : super(key: key);

  String name;
  String phone;
  bool banned;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        UserLabel(
          isName: true,
          text: name,
          banned: banned,
        ),
        UserLabel(
          isName: false,
          text: phone,
          banned: banned,
        )
      ],
    );
  }
}

class UserLabel extends StatelessWidget {
  UserLabel(
      {Key? key,
      required this.isName,
      required this.text,
      required this.banned})
      : super(key: key);

  bool isName;
  String text;
  bool banned;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isName ? Icons.person_rounded : Icons.phone,
          color: banned ? Colors.red.shade700 : CColors.gold,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class UserPageBtn extends StatelessWidget {
  UserPageBtn({
    required this.flex,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  int flex;
  String text;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
              height: 30,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                  color: CColors.gold.withOpacity(.2),
                  border: Border.all(color: CColors.gold),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Text(
                text,
                style: TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              )),
        ));
  }
}

class QueryField extends StatelessWidget {
  QueryField({Key? key, required this.onChanged}) : super(key: key);

  void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CContainer(
      width: double.maxFinite,
      radius: 10,
      color: CColors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Cerca...",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(.7))),
              cursorColor: Colors.white,
              onChanged: onChanged,
            ),
          ),
          Icon(
            Icons.search,
            color: Colors.white.withOpacity(.7),
          )
        ],
      ),
    );
  }
}
