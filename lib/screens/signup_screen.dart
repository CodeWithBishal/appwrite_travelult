import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travelult/screens/login_screen.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:travelult/widgets/snacbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend/authentication.dart';
import '../backend/url_launcher.dart';
import '../widgets/appbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final fullnameEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  final passwordEditingController = TextEditingController();
  final confirmpasswordEditingController = TextEditingController();
  late bool _obscureText = true;
  String? errorMessage;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  createAccount() async {
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite
          .createdUser(
        email: emailEditingController.text,
        password: passwordEditingController.text,
        fullName: fullnameEditingController.text,
        context: context,
      )
          .then((value) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          flutterToast("Account Created. Login with the Email & Password");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
      });
    } on AppwriteException catch (e) {
      setState(() {
        _isLoading = false;
      });
      flutterToast(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final fullnameField = TextFormField(
      autofocus: false,
      autofillHints: const [AutofillHints.name],
      controller: fullnameEditingController,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Please Enter your Full Name");
        }
        if (!regex.hasMatch(value)) {
          return ("Please Enter your Full Name");
        }
        return null;
      },
      keyboardType: TextInputType.name,
      onSaved: (value) {
        fullnameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.account_box,
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        hintText: "Full Name",
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.username],
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp('[ ]'),
        ),
      ],
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please Enter a valid Email Address");
        }
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("Please Enter a valid Email Address");
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        hintText: "Email ID",
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      autofillHints: const [AutofillHints.newPassword],
      controller: passwordEditingController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp('[ ]'),
        ),
      ],
      validator: (value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Please Enter a valid Password");
        }
        if (!regex.hasMatch(value)) {
          return ("Password must be 6 or more characters long");
        }
        return null;
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.vpn_key,
          color: Colors.black,
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        hintText: "Password",
        focusColor: Colors.black,
        suffixIcon: IconButton(
          enableFeedback: false,
          onPressed: _toggle,
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.black,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: const Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );

    final confirmpasswordField = TextFormField(
      autofocus: false,
      autofillHints: const [AutofillHints.newPassword],
      controller: confirmpasswordEditingController,
      inputFormatters: [
        FilteringTextInputFormatter.deny(
          RegExp('[ ]'),
        ),
      ],
      validator: (value) {
        if (confirmpasswordEditingController.text !=
            passwordEditingController.text) {
          return ("Password Do not match.");
        }
        return null;
      },
      onSaved: (value) {
        confirmpasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: Colors.black,
      obscureText: _obscureText,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.vpn_key,
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        hintText: "Confirm Password",
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isLoading
          ? null
          : commonAppBar(
              title: "",
              elevation: 0,
              centerTitle: true,
              context: context,
            ),
      body: _isLoading
          ? const LoadingWidget()
          : Center(
              child: ListView(
                reverse: true,
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Container(
                    color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: width - width / 15,
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 36,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: const Text(
                              "Create an account so you", //TODOO
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: const Text(
                              "can manage your trips", //TODOO
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 25,
                          ),
                          SizedBox(
                              width: width - width / 15, child: fullnameField),
                          SizedBox(
                            height: height / 40,
                          ),
                          AutofillGroup(
                              child: Column(
                            children: [
                              SizedBox(
                                width: width - width / 15,
                                child: emailField,
                              ),
                              SizedBox(
                                height: height / 40,
                              ),
                              SizedBox(
                                width: width - width / 15,
                                child: passwordField,
                              ),
                              SizedBox(
                                height: height / 40,
                              ),
                              SizedBox(
                                width: width - width / 15,
                                child: confirmpasswordField,
                              ),
                            ],
                          )),
                          SizedBox(
                            height: height / 40,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: const Text(
                              "Password must be 6 or more characters long & should contain a mix of upper & lower case letters.", //TODOO
                              style: TextStyle(
                                fontSize: 18,
                                color: Color.fromRGBO(84, 84, 84, 1),
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            height: height / 15,
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  createAccount();
                                }
                              },
                              style: ButtonStyle(
                                enableFeedback: false,
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.black),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.white12),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Create an Account",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          const Text(
                            "By signing up you agree to our",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  LaunchUrl.openLink(
                                    url:
                                        "https://travelult.com/terms-and-conditions",
                                    context: context,
                                    launchMode: LaunchMode.externalApplication,
                                  );
                                },
                                style: ButtonStyle(
                                  enableFeedback: false,
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  overlayColor:
                                      MaterialStateProperty.all(Colors.white12),
                                ),
                                child: const Text("Terms of Service",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    )),
                              ),
                              const Text(
                                " & ",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    LaunchUrl.openLink(
                                      url:
                                          "https://travelult.com/privacy-policy",
                                      context: context,
                                      launchMode:
                                          LaunchMode.externalApplication,
                                    );
                                  },
                                  style: ButtonStyle(
                                    enableFeedback: false,
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    overlayColor: MaterialStateProperty.all(
                                        Colors.white12),
                                  ),
                                  child: const Text(
                                    " Privacy Policy",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: height / 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
