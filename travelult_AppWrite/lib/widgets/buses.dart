import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Buses extends StatefulWidget {
  const Buses({Key? key}) : super(key: key);

  @override
  State<Buses> createState() => _BusesState();
}

class _BusesState extends State<Buses> {
  final whereToTextEditingController = TextEditingController();
  final whereFromTextEditingController = TextEditingController();
  final fromDateTextEditingController = TextEditingController();
  final toDateTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;
    final fromDateField = TextFormField(
      autofocus: false,
      controller: fromDateTextEditingController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please specify the check in date of your journey");
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 730),
          ),
        );
        if (dateTime != null) {
          setState(() {
            final dateFormatter = DateFormat(
              'yyyy-MM-dd',
            );
            final dateString = dateFormatter.format(
              dateTime,
            );
            fromDateTextEditingController.text = dateString;
          });
        } else {
          return;
        }
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Travel Date',
      ),
    );

    final whereToTextField = TextFormField(
      autofocus: false,
      controller: whereToTextEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Location cannot be empty.");
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        whereToTextEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Where to?',
      ),
    );
    final whereFromTextField = TextFormField(
      autofocus: false,
      controller: whereFromTextEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Location cannot be empty.");
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        whereFromTextEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Where From?',
      ),
    );
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: width - width / 15,
            child: whereFromTextField,
          ),
          SizedBox(
            height: height / 60,
          ),
          SizedBox(
            width: width - width / 15,
            child: whereToTextField,
          ),
          SizedBox(
            height: height / 60,
          ),
          SizedBox(
            width: width - width / 15,
            child: fromDateField,
          ),
          SizedBox(
            height: height / 60,
          ),
        ]);
  }
}
