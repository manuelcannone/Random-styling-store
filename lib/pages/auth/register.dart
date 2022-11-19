import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/auth/login.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

TextEditingController namesController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController passwordController = TextEditingController();

bool nameError = false;
bool emailError = false;
bool mobileError = false;
bool passwordError = false;

String nameErrorString = "";
String emailErrorString = "";
String mobileErrorString = "";
String passwordErrorString = "";

bool areTermsAccepted = false;
bool areFieldsValid = false;

bool checkFields() {
  if (namesController.text != "" &&
      namesController.text.contains(" ") &&
      EmailValidator.validate(emailController.text) &&
      mobileController.text.length == 10 &&
      passwordController.text.length >= 8 &&
      areTermsAccepted == true) {
    areFieldsValid = true;
  } else {
    areFieldsValid = false;
  }
  return areFieldsValid;
}

void register(dynamic context) async {
  nameError = false;
  emailError = false;
  mobileError = false;
  passwordError = false;
  nameErrorString = "";
  emailErrorString = "";
  mobileErrorString = "";
  passwordErrorString = "";

  if (areFieldsValid) {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .then((value) {
        final user = auth.currentUser;
        print(user != null);
        if (user != null) {
          //create user in firestore
          final uid = user.uid;
          FirebaseFirestore.instance.collection("users").doc(uid).set({
            "firstAndLastNames": namesController.text,
            "email": emailController.text,
            "mobile": mobileController.text,
            "banned": false,
            "isAdmin": false,
            "verified": false,
            "points": 0,
            "reward": []
          });
          namesController.clear();
          emailController.clear();
          mobileController.clear();
          passwordController.clear();
        }
        Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            //builder: (BuildContext context) => VerifyEmailPage(),
            builder: (BuildContext context) => MyApp(),
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: CColors.gold,
          content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Flexible(child: Text("${e.message}"))])));
    }
  } else {
    //all errors listed
    if (namesController.text == "") {
      nameError = true;
      nameErrorString = "Nome mancante";
    } else if (!namesController.text.contains(" ")) {
      nameError = true;
      nameErrorString = "Cognome mancante";
    }

    if (emailController.text == "") {
      emailError = true;
      emailErrorString = "Email mancante";
    } else if (!EmailValidator.validate(emailController.text)) {
      emailError = true;
      emailErrorString = "Email non valida";
    }

    if (mobileController.text == "") {
      mobileError = true;
      mobileErrorString = "Numero mancante";
    } else if (mobileController.text.length != 10) {
      mobileError = true;
      mobileErrorString = "Numero non valido";
    }

    if (passwordController.text == "") {
      passwordError = true;
      passwordErrorString = "Password mancante";
    } else if (passwordController.text.length < 8) {
      passwordError = true;
      passwordErrorString = "Password troppo debole,\nmin. 8 caratteri";
    }

    if (!areTermsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: CColors.gold,
          content: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Flexible(
                child: Text(
                    "Per continuare, accetta i termini e le condizioni di servizio"))
          ])));
    }
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key, this.firstPage = false});
  bool
      firstPage; //if is the first register, disable the back icon on the appbar
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        //resizeToAvoidBottomInset: false,
        appBar: widget.firstPage
            ? null
            : AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                  onPressed: () {
                    namesController.clear();
                    emailController.clear();
                    mobileController.clear();
                    passwordController.clear();
                    Navigator.pop(context);
                  },
                  color: CColors.gold,
                ),
              ),
        body: Center(
          child: CContainer(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * .85,
            radius: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset("media/barberlogo.png"),
                ),
                Column(
                  children: [
                    cTextField(
                      errorString: nameErrorString,
                      errorFlag: nameError,
                      hintText: "Nome e Cognome",
                      controller: namesController,
                    ),
                    cTextField(
                        keyboardType: TextInputType.emailAddress,
                        errorString: emailErrorString,
                        errorFlag: emailError,
                        hintText: "Email",
                        controller: emailController),
                    cTextField(
                        keyboardType: TextInputType.number,
                        errorString: mobileErrorString,
                        errorFlag: mobileError,
                        hintText: "Numero di Telefono",
                        controller: mobileController),
                    cTextField(
                      errorString: passwordErrorString,
                      errorFlag: passwordError,
                      hintText: "Password",
                      controller: passwordController,
                      isPasswordField: true,
                      obscureText: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // TextButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => LoginPage(firstPage: false,)),
                          //       );
                          //     },
                          //     child: Text(
                          //       "Sei già registrato? Tocca qui per accedere",
                          //       style: TextStyle(
                          //       color: Colors.white, fontSize: 14),
                          //     )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TermsCheck(),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: Text(
                                "Accetta i termini e le condizioni di servizio",
                                style: TextStyle(
                                    color: CColors.gold, fontSize: 14),
                              ))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    RegisterButton(
                      onPressed: () {
                        setState(() {
                          checkFields();
                          register(context);
                        });
                      },
                    ),
                    LoginButton()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  RegisterButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  var onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              "Registrati",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )));
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({
    Key? key,
  }) : super(key: key);

  var onPressed = () async {};

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginPage(
                      firstPage: false,
                    )),
          );
        },
        child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * .5,
            child: Text(
              "Accedi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )));
  }
}

class TermsCheck extends StatefulWidget {
  const TermsCheck({
    Key? key,
  }) : super(key: key);

  @override
  State<TermsCheck> createState() => _TermsCheckState();
}

class _TermsCheckState extends State<TermsCheck> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            areTermsAccepted = !areTermsAccepted;
          });
        },
        child: Container(
          height: 20,
          width: 20,
          color: Colors.white,
          child: areTermsAccepted
              ? Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 19,
                )
              : null,
        ));
  }
}

class cTextField extends StatefulWidget {
  cTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.errorFlag,
    required this.errorString,
    this.isPasswordField = false,
    this.obscureText = false,
    this.keyboardType,
  }) : super(key: key);

  String hintText;
  TextEditingController controller;
  bool isPasswordField;
  bool obscureText;
  bool errorFlag;
  String errorString;
  TextInputType? keyboardType;
  @override
  State<cTextField> createState() => _cTextFieldState();
}

class _cTextFieldState extends State<cTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      child: widget.isPasswordField
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .58,
                      child: TextField(
                          //readOnly: readOnly,
                          controller: widget.controller,
                          obscureText: widget.obscureText,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          decoration: InputDecoration(
                              hintText: widget.hintText,
                              hintStyle:
                                  TextStyle(fontSize: 20, color: Colors.white),
                              border: InputBorder.none)),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.obscureText = !widget.obscureText;
                        });
                      },
                      child: widget.obscureText
                          ? Icon(
                              Iconsax.eye,
                              color: Colors.white,
                            )
                          : Icon(
                              Iconsax.eye_slash,
                              color: Colors.white,
                            ),
                    )
                  ],
                ),
                Divider(
                  color: widget.errorFlag ? CColors.gold : Colors.white,
                  thickness: 1,
                ),
                widget.errorFlag
                    ? Text(
                        widget.errorString,
                        style: TextStyle(color: CColors.gold),
                      )
                    : Container()
              ],
            )
          : Column(
              children: [
                TextField(
                    keyboardType: widget.keyboardType,
                    controller: widget.controller,
                    obscureText: widget.obscureText,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                    decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        enabledBorder:
                            widget.errorFlag ? goldenBorder() : whiteBorder(),
                        focusedBorder:
                            widget.errorFlag ? goldenBorder() : whiteBorder())),
                Text(
                  widget.errorString,
                  style: TextStyle(color: CColors.gold),
                )
              ],
            ),
    );
  }

  UnderlineInputBorder goldenBorder() {
    return UnderlineInputBorder(borderSide: BorderSide(color: CColors.gold));
  }

  UnderlineInputBorder whiteBorder() {
    return UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));
  }
}
