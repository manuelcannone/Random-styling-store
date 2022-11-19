import 'package:flutter/material.dart';
import 'package:randomstylingstore/pages/auth/register.dart';
import '../../colors.dart';

class BannedPage extends StatelessWidget {
  const BannedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("media/bannedPage.png"),
            SizedBox(
              height: 50,
            ),
            Text(
              "Ci dispiace ma il tuo account è stato disattivato!",
              textAlign: TextAlign.center,
              style: TextStyle(color: CColors.gold, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  print("PROVA");
                  auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegisterPage(
                                firstPage: true,
                              )),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
