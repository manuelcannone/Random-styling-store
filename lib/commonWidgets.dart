import 'package:flutter/material.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/Appbar_Footer.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shirne_dialog/shirne_dialog.dart';

//accept and refuse booking

void barberSnapBar(context, String text, bool error) {
  //error == true  IconType.error
  //error == false  IconType.success
  MyDialog.of(context).toast(
    text,
    style: MyDialog.theme.toastStyle?.top(),
    iconType: error ? IconType.success : IconType.error,
  );
}

//THEME
Map<int, Color> color = {
  50: Color.fromRGBO(174, 137, 82, 1),
  100: Color.fromRGBO(174, 137, 82, 1),
  200: Color.fromRGBO(174, 137, 82, 1),
  300: Color.fromRGBO(174, 137, 82, 1),
  400: Color.fromRGBO(174, 137, 82, 1),
  500: Color.fromRGBO(174, 137, 82, 1),
  600: Color.fromRGBO(174, 137, 82, 1),
  700: Color.fromRGBO(174, 137, 82, 1),
  800: Color.fromRGBO(174, 137, 82, 1),
  900: Color.fromRGBO(174, 137, 82, 1),
};
MaterialColor colorCustom = MaterialColor(0xFFAE8952, color);

class AppTheme {
  final theme = ThemeData(
    timePickerTheme: TimePickerThemeData(
        backgroundColor: CColors.grey,
        hourMinuteTextColor: Colors.white,
        dialTextColor: Colors.white),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: colorCustom)
        .copyWith(secondary: Color.fromRGBO(174, 137, 82, 1)),
    drawerTheme: DrawerThemeData(backgroundColor: CColors.grey),
    primaryIconTheme: IconThemeData(color: Colors.white),
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: CColors.grey),
    iconTheme: IconThemeData(color: Colors.white, size: 35),
    appBarTheme: AppBarTheme(
      backgroundColor: CColors.black,
      actionsIconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    fontFamily: "Inter",
    primaryColor: Colors.white,
    scaffoldBackgroundColor: CColors.black,
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: CColors.gold,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: CColors.gold,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3))),
    ),
  );
}

// COMMON CONTAINER
class CContainer extends StatelessWidget {
  CContainer(
      {super.key,
      this.alignment,
      this.padding,
      this.margin,
      this.width,
      this.height,
      this.radius = 0,
      this.color = CColors.grey,
      this.child});

  double? width;
  double? height;
  double radius;
  Color color;
  Widget? child;
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;
  AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}

// BEGIN COMMON TEXTFIELD FIELD SECTION
class CTextField extends StatefulWidget {
  CTextField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.isPasswordField = false,
      this.obscureText = false})
      : super(key: key);

  String hintText;
  TextEditingController controller;
  bool isPasswordField;
  bool obscureText;

  @override
  State<CTextField> createState() => _CTextFieldState();
}

class _CTextFieldState extends State<CTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
      child: widget.isPasswordField
          ? Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .58,
                      child: TextField(
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
                  color: Colors.white,
                  thickness: 1,
                )
              ],
            )
          : TextField(
              obscureText: widget.obscureText,
              style: TextStyle(fontSize: 20, color: Colors.white),
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                  enabledBorder: whiteBorder(),
                  focusedBorder: whiteBorder())),
    );
  }

  UnderlineInputBorder whiteBorder() {
    return UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));
  }
}

//END OF COMMONTEXTFIELD SECTION

class CommonSlider extends StatelessWidget {
  CommonSlider({
    Key? key,
    required this.function,
    required this.text,
  }) : super(key: key);

  final void Function()? function;
  String text;

  @override
  Widget build(BuildContext context) {
    return SlideAction(
      //height: 50,
      borderRadius: 10,
      outerColor: CColors.grey,
      innerColor: CColors.gold,
      elevation: 0,
      onSubmit: function,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 30, right: 30),
        child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: Colors.white),
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }
}

//LOADINGPAGE

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  // @override
  // void initState() {
  //   _navigate();
  //   super.initState();
  // }

  // _navigate() async {
  //   await Future.delayed(Duration(milliseconds: 2500), (){});
  //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AppbarFooter(body: SelectServicesAndBooking(), isUserAdmin: isUserAdminGlobal,)));
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CColors.black,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: SpinKitCircle(
          size: 50,
          color: CColors.gold,
        ),
      ),
    );
  }
}
