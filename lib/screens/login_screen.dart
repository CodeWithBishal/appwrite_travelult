import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travelult/backend/authentication.dart';
import 'package:travelult/main.dart';
import 'package:travelult/screens/signup_screen.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:travelult/widgets/snacbar.dart';

import '../widgets/appbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  logIn() async {
    try {
      final AuthAPI appwrite = context.read<AuthAPI>();
      await appwrite
          .createEmailSession(
        emailController.text,
        passwordController.text,
      )
          .then((value) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
          (route) => false,
        );
        flutterToast("Logged In");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      autofillHints: const [AutofillHints.username],
      keyboardType: TextInputType.emailAddress,
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
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.mail,
          color: Colors.black,
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      autofillHints: const [AutofillHints.password],
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: Colors.black,
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: const Icon(
          Icons.vpn_key,
          color: Colors.black,
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
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
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
                              "Welcome Back!!",
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
                              "Sign in to your account",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Source Sans Pro',
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 10,
                          ),
                          AutofillGroup(
                            child: Column(
                              children: [
                                SizedBox(
                                  width: width - width / 15,
                                  child: emailField,
                                ),
                                SizedBox(
                                  height: height / 30,
                                ),
                                SizedBox(
                                  width: width - width / 15,
                                  child: passwordField,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 30,
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
                                  logIn();
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
                                "Login",
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
                            height: height / 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an Account?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontFamily: 'Source Sans Pro',
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  enableFeedback: false,
                                ),
                                child: const Text(
                                  "Sign up",
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.underline,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 6,
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
