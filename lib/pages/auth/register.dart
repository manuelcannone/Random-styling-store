import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:randomstylingstore/colors.dart';
import 'package:randomstylingstore/commonWidgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:randomstylingstore/main.dart';
import 'package:randomstylingstore/pages/auth/login.dart';
import 'package:flutter/gestures.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class AlterdialogPrivacyAndPolicy extends StatefulWidget {
  AlterdialogPrivacyAndPolicy({
    super.key,
    required this.titlePrivacy,
    required this.decriptionPrivacy,
  });
  dynamic titlePrivacy;
  dynamic decriptionPrivacy;

  @override
  State<AlterdialogPrivacyAndPolicy> createState() =>
      _AlterdialogPrivacyAndPolicyState();
}

class _AlterdialogPrivacyAndPolicyState
    extends State<AlterdialogPrivacyAndPolicy> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.titlePrivacy,
      content: SingleChildScrollView(
        child: new Column(
          children: [
            widget.decriptionPrivacy,
            TextButton(
              onPressed: () => Navigator.pop(context, 'Chiudi'),
              child: const Text('Chiudi'),
            ),
          ],
        ),
      ),
    );
  }
}

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
          print('fatto');
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TermsCheck(),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Accetto la normativa sulla',
                                      style: TextStyle(
                                          color: CColors.gold, fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: ' privacy\n',
                                      style: TextStyle(
                                          color: CColors.gold,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          showDialog<String>(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlterdialogPrivacyAndPolicy(
                                                    titlePrivacy: Text(
                                                        '''Informativa sulla privacy e l'utilizzo dei dati''',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    decriptionPrivacy:Text.rich( 
                                                     TextSpan(
                                                        text:
                                                            '''Gentile utente,
La informiamo che il Regolamento UE 2016/679 relativo alla protezione delle persone fisiche con riguardo al trattamento dei dati personali, nonché alla libera circolazione di tali dati, Regolamento Generale sulla Protezione dei Dati (di seguito “Regolamento” o “GDPR” "), prevede la tutela delle persone fisiche rispetto al trattamento dei dati personali. Ai sensi della predetta normativa, il trattamento dei Suoi dati personali sarà improntato ai principi di correttezza, liceità, trasparenza e di tutela della Sua riservatezza e dei Suoi diritti. La presente costituisce l'informativa resa agli interessati ai sensi dell'Art. 13 GDPR.
 ''',
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text:
                                                                  '''1. Titolare del trattamento''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                          TextSpan(
                                                            text:
                                                                '''Il titolare del trattamento è di Gianmarco Tomai, Codice Fiscale:  , Titolare di Mc Infinity sede legale in Viterbo, Via Carlo Minciotti 15, P.IVA 02228580565.
Il trattamento verrà svolto in via manuale ed elettronica con l’ausilio di strumenti informatici.
Il Titolare ha nominato un Responsabile della protezione dei dati (Data Protection Officer, di seguito “DPO”), contattabile al seguente recapito:''',
                                                          ),

                                                           TextSpan(
                                                            text:
                                                                '''info@jreadydev.com\n''',style: TextStyle(color: Colors.blue)
                                                          ),

                                                           TextSpan(
                                                              text:
                                                                  '''2. Finalità e base giuridica del trattamento dei dati personali\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                            TextSpan(
                                                            text:
                                                                '''I dati personali e le eventuali variazioni sono trattati per la finalità dello svolgimento dell'attività di comunicazione tra Titolare Gianmarco Tomai e i suoi clienti, che utilizzano l'applicazione con lo scopo di pianificare la registrazione di appuntamenti e l’invio attraverso email di comunicazioni promozionali e/o informative. La mancata accettazione ne determina l'impossibilità di ricezione delle informazioni.\n''',
                                                          ),

                                                            TextSpan(
                                                              text:
                                                                  '''3. Dati oggetto del trattamento\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                            TextSpan(
                                                            text:
                                                                '''I dati trattati solo ed esclusivamente venga fornito il consenso da parte dell’utente sono:\n
- dati anagrafici e identificativi, quali ad esempio nominativo, numero di telefono, e-mail;\n''',
                                                          ),

                                                           TextSpan(
                                                              text:
                                                                  '''4. Modalità del trattamento\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                            TextSpan(
                                                            text:
                                                                '''Il trattamento sarà effettuato con l’ausilio di mezzi elettronici e manuali in base a logiche e procedure coerenti con le finalità sopra indicate e nel rispetto del GDPR, compresi i profili di confidenzialità, sicurezza e minimizzazione.\n''',
                                                          ),

                                                           TextSpan(
                                                              text:
                                                                  '''5. Soggetti o categorie di soggetti ai quali possono essere comunicati i dati\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                            TextSpan(
                                                            text:
                                                                '''I dati personali sono accessibili al personale del Titolare debitamente autorizzato ed istruito dal Titolare medesimo, secondo criteri di necessità, e sono comunicati ad autorità ed enti pubblici per i rispettivi fini istituzionali, quando la comunicazione è richiesta da leggi e regolamenti.
I Suoi dati personali sono inoltre comunicati ai fornitori del Titolare, quali, ad esempio, collaboratori autonomi, anche in forma associata, società di formazione, fornitori di servizi di natura tecnica, informatica ed organizzativa funzionali alle finalità sopra indicate. Il Titolare fornisce a tali soggetti solo i dati necessari per eseguire i servizi concordati e gli stessi, quali Responsabili del trattamento, nominati dal Titolare ai sensi dell’art. 28 del Regolamento, agiscono sulla base di istruzioni ricevute dal Titolare stesso.\nIn ogni caso i dati trattati non saranno oggetto di diffusione.\n''',
                                                          ),

                                                          TextSpan(
                                                              text:
                                                                  '''6. Conservazione dei dati\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                          TextSpan(
                                                            text:
                                                                '''I dati personali trattati per finalità di selezione del personale sono conservati per un periodo di 10 anni dalla registrazione.\n''',
                                                          ),

                                                          TextSpan(
                                                              text:
                                                                  '''7. Trasferimento dei dati al di fuori dell’Unione Europea\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                          TextSpan(
                                                            text:
                                                                '''I dati non saranno oggetto di trasferimento al di fuori dell’Unione Europea.\n''',
                                                          ),

                                                          TextSpan(
                                                              text:
                                                                  '''8. Diritti degli interessati\n''',
                                                              style: TextStyle(fontWeight:FontWeight.bold)),

                                                          TextSpan(
                                                            text:
                                                                '''Lei ha il diritto, in qualunque momento, di chiedere al Titolare l’accesso ai Suoi dati personali, la rettifica, l’integrazione, la cancellazione degli stessi e la limitazione del trattamento. Inoltre, ha il diritto di opporsi in qualsiasi momento al trattamento dei Suoi dati nonché il diritto alla portabilità dei dati stessi. Per esercitare i suddetti diritti, nonché gli ulteriori diritti previsti agli artt. 15 e seguenti del Reg. UE n. 679/2016, l’interessato potrà rivolgersi al Titolare, scrivendo all’indirizzo mail: \n''',
                                                          ),

                                                          TextSpan(
                                                            text:
                                                                '''centauro1908@gmail.com\n''',style: TextStyle(color: Colors.blue)
                                                          ),

                                                          TextSpan(
                                                            text:
                                                                '''oppure scrivendo alla componente tecnica info@jreadydev.com\nQualora ravvisasse una violazione dei Suoi diritti, Lei potrà rivolgersi all’autorità di controllo competente, restando sempre salva la possibilità di adire direttamente l’autorità giudiziaria.\n''',
                                                          ),



                                                        ])),
                                                  ));
                                        },
                                    ),
                                    TextSpan(
                                      text: ' e i',
                                      style: TextStyle(
                                          color: CColors.gold, fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: ' termini e condizioni',
                                      style: TextStyle(
                                          color: CColors.gold,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () {
                                          print('PROVA');
                                          showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlterdialogPrivacyAndPolicy(
                                              titlePrivacy:
                                                  Text('Termini e condizioni'),
                                              decriptionPrivacy:
                                                  RichText(text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: "Scaricando o utilizzando l'app, questi termini si applicheranno automaticamente a te: assicurati quindi di leggerli attentamente prima di utilizzare l'app. Non è consentito copiare o modificare l'app, alcuna parte dell'app o i nostri marchi in alcun modo. Non sei autorizzato a tentare di estrarre il codice sorgente dell'app e non dovresti nemmeno provare a tradurre l'app in altre lingue o creare versioni derivate. L'app stessa, e tutti i marchi, diritti d'autore, diritti di database e altri diritti di proprietà intellettuale ad essa correlati, appartengono ancora a Mc infinity di Monia Cirillo, P.IVA 02228580565.", style: TextStyle(color: Colors.black) 
                                                      ),
                                                      TextSpan(
                                                        text:"Mc infinity di Monia Cirillo, P.IVA 02228580565 si impegna affinché l'app sia quanto più utile ed efficiente possibile. Per questo motivo, ci riserviamo il diritto di apportare modifiche all'app o di addebitare i suoi servizi, in qualsiasi momento e per qualsiasi motivo. Non ti addebiteremo mai l'app o i suoi servizi senza chiarirti esattamente per cosa stai pagando." ,style: TextStyle(color: Colors.black 
                                                      ), 
                                                      ),
                                                      TextSpan(text: "L'app Random styling store archivia ed elabora i dati personali che ci hai fornito per fornire il nostro Servizio. È tua responsabilità proteggere il tuo telefono e l'accesso all'app. Ti consigliamo quindi di non eseguire il jailbreak o il root del tuo telefono, che è il processo di rimozione delle restrizioni e limitazioni del software imposte dal sistema operativo ufficiale del tuo dispositivo. Potrebbe rendere il tuo telefono vulnerabile a malware/virus/programmi dannosi, compromettere le funzionalità di sicurezza del tuo telefono e potrebbe significare che l'app Random styling store non funzionerà correttamente o non funzionerà affatto.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "L'app utilizza servizi di terze parti che dichiarano i propri Termini e condizioni.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan( text: "Collegamento a Termini e condizioni dei fornitori di servizi di terze parti utilizzati dall'app",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Servizi Google Play Google Analytics per Firebase Firebase Crashlytics Devi essere consapevole che ci sono alcune cose per le quali Mc infinity di Monia Cirillo, P.IVA 02228580565 non si assume alcuna responsabilità. Alcune funzioni dell'app richiedono che l'app disponga di una connessione Internet attiva. La connessione può essere Wi-Fi o fornita dal tuo gestore di rete mobile, ma Mc infinity di Monia Cirillo, P.IVA 02228580565 non può assumersi la responsabilità per il mancato funzionamento dell'app a piena funzionalità se non hai accesso al Wi-Fi, e non hai più alcun dato disponibile.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Se stai utilizzando l'app al di fuori di un'area con Wi-Fi, tieni presente che i termini dell'accordo con il tuo gestore di rete mobile continueranno ad essere applicati. Di conseguenza, il tuo gestore di telefonia mobile potrebbe addebitarti il costo dei dati per la durata della connessione durante l'accesso all'app o altri addebiti di terze parti. Utilizzando l'app, accetti la responsabilità di eventuali addebiti di questo tipo, inclusi gli addebiti per i dati in roaming se utilizzi l'app al di fuori del tuo territorio nazionale (ovvero regione o paese) senza disattivare il roaming dei dati. Se non sei il pagatore del conto per il dispositivo su cui stai utilizzando l'app, tieni presente che presumiamo che tu abbia ricevuto il permesso dal pagatore per l'utilizzo dell'app.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Sulla stessa linea, Mc infinity di Monia Cirillo, P.IVA 02228580565 non può sempre assumersi la responsabilità del modo in cui utilizzi l'app, ovvero devi assicurarti che il tuo dispositivo rimanga carico, se si scarica e non puoi girare per usufruire del Servizio, Mc infinity di Monia Cirillo, P.IVA 02228580565 non si assume alcuna responsabilità.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Per quanto riguarda la responsabilità di Mc infinity di Monia Cirillo, P.IVA 02228580565 per il tuo utilizzo dell'app, quando utilizzi l'app, è importante tenere presente che, sebbene ci impegniamo a garantire che sia sempre aggiornata e corretta , facciamo affidamento su terze parti per fornirci informazioni in modo da poterle mettere a vostra disposizione. Mc infinity di Monia Cirillo, P.IVA 02228580565 non si assume alcuna responsabilità per eventuali perdite, dirette o indirette, subite a seguito dell'affidamento totale a questa funzionalità dell'app.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Ad un certo punto, potremmo voler aggiornare l'app. L'app è attualmente disponibile su iOS: i requisiti per il sistema (e per eventuali sistemi aggiuntivi a cui decidiamo di estendere la disponibilità dell'app) potrebbero cambiare e dovrai scaricare gli aggiornamenti se desideri continuare a utilizzare l'app . Mc infinity di Monia Cirillo, P.IVA 02228580565 non promette che aggiornerà sempre l'app in modo che sia pertinente per te e/o funzioni con la versione iOS che hai installato sul tuo dispositivo. Tuttavia, prometti di accettare sempre gli aggiornamenti dell'applicazione quando ti vengono offerti. Potremmo anche voler interrompere la fornitura dell'app e potremmo interrompere l'utilizzo in qualsiasi momento senza darti preavviso di risoluzione. A meno che non vi diciamo diversamente, in caso di risoluzione, (a) i diritti e le licenze concessi all'utente in questi termini cesseranno; (b) devi smettere di usare l'app e (se necessario) eliminarla dal tuo dispositivo.",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Modifiche a questi termini e condizioni",style: TextStyle(color: Colors.black 
                                                      ),),
                                                      TextSpan(text: "Potremmo aggiornare i nostri Termini e condizioni di volta in volta. Pertanto, si consiglia di rivedere periodicamente questa pagina per eventuali modifiche",style: TextStyle(color: Colors.black 
                                                      ),)
                                                    ]
                                                  ),
                                                    
                                                  ),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              )
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
