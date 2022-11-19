import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:randomstylingstore/main.dart';
import 'register.dart';
import 'package:open_mail_app/open_mail_app.dart';

// TO DO: METTERE GLI ERRORI COME NEL REGISTER

TextEditingController lEmailController = TextEditingController();
TextEditingController lPasswordController = TextEditingController();

//SAME FIELDS AS REGISTER, BUT WITH AN L (THAT STANDS FOR LOGIN)
bool lAreFieldsValid = false;
bool lEmailError = false;
bool lPasswordError = false;
String lEmailErrorString = "";
String lPasswordErrorString = "";
bool verifyEmailSent = false;

final FirebaseAuth auth = FirebaseAuth.instance;

checkFields() {
  if (EmailValidator.validate(lEmailController.text) && lPasswordController.text.length >= 8) {
    lAreFieldsValid = true;
  } else {
    lAreFieldsValid = false;
  }
}

void login(dynamic context) async {
  if (lAreFieldsValid) {
    try {
      lEmailErrorString = "";
      lPasswordErrorString = "";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: CColors.gold,
          content:
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [Flexible(child: Text("Caricamento..."))])));
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: lEmailController.text, password: lPasswordController.text)
          .then((value) {
        lEmailController.clear();
        lPasswordController.clear();
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => MyApp(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 5),
          backgroundColor: CColors.gold,
          content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Flexible(child: Text(e.message!))])));
    }
  } else {
    //all errors listed
    if (lEmailController.text == "") {
      lEmailError = true;
      lEmailErrorString = "Email mancante";
    } else if (!EmailValidator.validate(lEmailController.text)) {
      lEmailError = true;
      lEmailErrorString = "Email non valida";
    }
    if (lPasswordController.text == "") {
      lPasswordError = true;
      lPasswordErrorString = "Password mancante";
    } else if (lPasswordController.text.length < 8) {
      lPasswordError = true;
      lPasswordErrorString = "Password troppo debole,\nmin. 8 caratteri";
    }
  }
}

void showNoMailAppsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Open Mail App"),
        content: Text("No mail apps installed"),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.firstPage});

  bool firstPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  forgottenPassword() {
    if (lEmailController.text.trim() != "") {
      try {
        FirebaseAuth.instance.sendPasswordResetEmail(email: lEmailController.text.trim());
        setState(() {
          verifyEmailSent = true;
          lEmailError = false;
          lEmailErrorString = "";
        });
      } on FirebaseAuthException catch (e) {}
    } else {
      setState(() {
        lEmailError = true;
        lEmailErrorString = "Inserisci una email valida";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: widget.firstPage ? false : true,
          leading: widget.firstPage
              ? null
              : IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    lEmailController.clear();
                    lPasswordController.clear();
                    Navigator.pop(context);
                  },
                  color: CColors.gold,
                ),
        ),
        body: Center(
          child: CContainer(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .6,
            radius: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("media/barberlogo.png"),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    cTextField(
                      hintText: "Email",
                      controller: lEmailController,
                      errorFlag: lEmailError,
                      errorString: lEmailErrorString,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    cTextField(
                      hintText: "Password",
                      controller: lPasswordController,
                      errorFlag: lPasswordError,
                      errorString: lPasswordErrorString,
                      isPasswordField: true,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextButton(
                          onPressed: () {
                            forgottenPassword();
                            if (verifyEmailSent) {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    content: CContainer(
                                      radius: 10,
                                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                                      height: MediaQuery.of(context).size.height * .35,
                                      width: MediaQuery.of(context).size.width * .9,
                                      color: CColors.black,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              RichText(
                                                text: TextSpan(
                                                    text: "Abbiamo inviato una email a ",
                                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                                    children: [
                                                      TextSpan(
                                                          text: "${lEmailController.text.trim()}",
                                                          style: TextStyle(color: CColors.gold, fontSize: 18)),
                                                      TextSpan(
                                                          text: "!",
                                                          style: TextStyle(color: Colors.white, fontSize: 18)),
                                                    ]),
                                              ),
                                              Divider(
                                                thickness: 1,
                                                color: CColors.gold,
                                              ),
                                              Text("Assicurati di controllare anche la casella dello Spam!",
                                                  style: TextStyle(color: Colors.white, fontSize: 12))
                                            ],
                                          ),
                                          CommonSlider(
                                              function: () async {
                                                var result =
                                                    await OpenMailApp.openMailApp(nativePickerTitle: 'Seleziona app');
                                                if (!result.didOpen && !result.canOpen) {
                                                  showNoMailAppsDialog(context);
                                                  // iOS: if multiple mail apps found, show dialog to select.
                                                  // There is no native intent/default app system in iOS so
                                                  // you have to do it yourself.
                                                } else if (!result.didOpen && result.canOpen) {
                                                  showDialog(
                                                    context: context,
                                                    builder: (_) {
                                                      return MailAppPickerDialog(
                                                        mailApps: result.options,
                                                      );
                                                    },
                                                  );
                                                }
                                              },
                                              text: "Scorri per aprire l'app delle tue email"),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Text(
                            "Password dimenticata?",
                            style: TextStyle(color: CColors.gold),
                          )),
                    )
                  ],
                ),
                Column(children: [
                  LoginButton(
                    onPressed: () async {
                      checkFields();
                      lEmailError = false;
                      lPasswordError = false;
                      lEmailErrorString = "";
                      lPasswordErrorString = "";
                      login(context);
                      setState(() {});
                    },
                  ),
                  RegisterButton(),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({Key? key, required this.onPressed}) : super(key: key);

  var onPressed = () async {};

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              "Accedi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )));
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterPage(
                      firstPage: false,
                    )),
          );
        },
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              "Registrati",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )));
  }
}
