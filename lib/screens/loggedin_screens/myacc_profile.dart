import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:travelult/widgets/appbar.dart';
import 'package:travelult/widgets/check_internet.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:travelult/widgets/snacbar.dart';

import '../../backend/authentication.dart';

class MyAccProfile extends StatefulWidget {
  const MyAccProfile({Key? key}) : super(key: key);

  @override
  State<MyAccProfile> createState() => _MyAccProfileState();
}

class _MyAccProfileState extends State<MyAccProfile> {
  final _formKey = GlobalKey<FormState>();
  late bool _isLoading = false;
  final fullnameEditingController = TextEditingController();
  final phoneEditingController = TextEditingController();
  final emailEditingController = TextEditingController();
  late bool _readOnly = true;
  void _toggle() {
    setState(() {
      _readOnly = !_readOnly;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthAPI user = context.read<AuthAPI>();
    emailEditingController.text = user.email!;
    fullnameEditingController.text = user.userName!;
    CheckForInternet.checkForInternet(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 2.5;

    final emailField = TextFormField(
      autofocus: false,
      readOnly: true,
      controller: emailEditingController,
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
    final fullnameField = TextFormField(
      autofocus: _readOnly,
      readOnly: _readOnly,
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
      textInputAction: TextInputAction.done,
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
    return Scaffold(
      appBar: commonAppBar(
        title: "My Account",
        elevation: 0,
        centerTitle: false,
        context: context,
      ),
      body: _isLoading
          ? const LoadingWidget()
          : ListView(
              reverse: true,
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 10,
                          ),
                          CircleAvatar(
                            backgroundColor: const Color(0xFFF6F2D4),
                            radius: 45,
                            child: ClipOval(
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Colors.blue.shade200,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 10,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: fullnameField,
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: ColorFiltered(
                              colorFilter: const ColorFilter.mode(
                                Color.fromRGBO(194, 202, 223, 0.42),
                                BlendMode.modulate,
                              ),
                              child: emailField,
                            ),
                          ),
                          SizedBox(
                            height: height / 10,
                          ),
                          SizedBox(
                              width: width - width / 15,
                              height: height / 15,
                              child: TextButton(
                                onPressed: _readOnly
                                    ? () {
                                        setState(() {
                                          _toggle();
                                          flutterToast("Editing Enabled");
                                        });
                                      }
                                    : () {
                                        CheckForInternet.checkForInternet(
                                          context,
                                        ).then((value) {
                                          if (value == true) {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              setState(
                                                () {
                                                  _toggle();
                                                  _isLoading = true;
                                                  user.account
                                                      .updateName(
                                                          name:
                                                              fullnameEditingController
                                                                  .text)
                                                      .then(
                                                    (value) {
                                                      _isLoading = false;
                                                      flutterToast(
                                                        "Your Profile has been Successfully Updated!",
                                                      );
                                                      Navigator.pop(
                                                        context,
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          } else {
                                            CheckForInternet.checkForInternet(
                                              context,
                                            );
                                          }
                                        });
                                      },
                                style: ButtonStyle(
                                  enableFeedback: false,
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.black,
                                  ),
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.white12,
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  _readOnly ? "Edit Profile" : "Update Profile",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
