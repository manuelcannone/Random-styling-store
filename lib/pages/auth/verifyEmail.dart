import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:randomstylingstore/main.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart' as appbarFooterComponents;

class VerifyEmailPage extends StatefulWidget {
  VerifyEmailPage({super.key});
  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  Timer? timer;
  bool isUserVerified = false;

  @override
  void initState() {
    super.initState();
    if (isUserVerified == false) {
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 1), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print(e.toString());
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isUserVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isUserVerified) {
      timer?.cancel();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(appbarFooterComponents.auth.currentUser?.uid)
          .update({"verified": true}).then((value) => Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  //builder: (BuildContext context) => VerifyEmailPage(),
                  builder: (BuildContext context) => MyApp(),
                ),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainSection(
                function: sendVerificationEmail,
              ),
              LogoutSection()
            ],
          ),
        ),
      ),
    );
  }
}

class MainSection extends StatelessWidget {
  MainSection({super.key, required this.function});

  void Function()? function;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
        ),
        Image.asset(
          "media/email.png",
          width: MediaQuery.of(context).size.width,
          height: 150,
        ),
        Text(
          "VERIFICA LA TUA EMAIL!",
          style: TextStyle(fontSize: 35, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        Divider(
          thickness: 2,
          color: CColors.gold,
        ),
        SizedBox(
          height: 10,
        ),
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Abbiamo inviato un'email all'indirizzo ",
                style: TextStyle(color: Colors.white, fontSize: 25),
                children: [
                  TextSpan(text: auth.currentUser?.email, style: TextStyle(color: CColors.gold, fontSize: 25)),
                ])),
        SizedBox(
          height: 20,
        ),
        CommonSlider(text: "Scorri per ricevere nuovamente l'email!", function: function)
      ],
    );
  }
}

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          thickness: 1,
          color: CColors.gold,
        ),
        Text(
            "Hai verificato l'email ma ancora non puoi andare alla home? Prova a effettuare il Logout e accedere nuovamente!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 17, color: Colors.white.withOpacity(.7))),
        SizedBox(
          height: 15,
        ),
        ElevatedButton(
            onPressed: () {
              appbarFooterComponents.logout(context, true);
            },
            child: Text("Logout")),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
