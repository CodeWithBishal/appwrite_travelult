import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Hotels extends StatefulWidget {
  const Hotels({Key? key}) : super(key: key);

  @override
  State<Hotels> createState() => _HotelsState();
}

class _HotelsState extends State<Hotels> {
  final whereToTextEditingController = TextEditingController();
  final fromDateTextEditingController = TextEditingController();
  final toDateTextEditingController = TextEditingController();
  late int _guestCount = 1;
  late int _roomCount = 1;
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
          initialDate: toDateTextEditingController.text.isEmpty
              ? DateTime.now()
              : DateTime.parse(toDateTextEditingController.text)
                  .subtract(const Duration(days: 1)),
          firstDate: toDateTextEditingController.text.isEmpty
              ? DateTime.now()
              : DateTime.now(),
          lastDate: toDateTextEditingController.text.isEmpty
              ? DateTime.now().add(
                  const Duration(days: 365),
                )
              : DateTime.parse(toDateTextEditingController.text)
                  .subtract(const Duration(days: 1)),
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
        labelText: 'Check in',
      ),
    );
    final toDateField = TextFormField(
      autofocus: false,
      controller: toDateTextEditingController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please specify the check out date of your journey");
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: fromDateTextEditingController.text.isEmpty
              ? DateTime.now().add(const Duration(days: 1))
              : DateTime.parse(fromDateTextEditingController.text).add(
                  const Duration(days: 1),
                ),
          firstDate: fromDateTextEditingController.text.isEmpty
              ? DateTime.now().add(const Duration(days: 1))
              : DateTime.parse(fromDateTextEditingController.text).add(
                  const Duration(days: 1),
                ),
          lastDate: DateTime.now().add(
            const Duration(days: 365),
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
            toDateTextEditingController.text = dateString;
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
        labelText: 'Check Out',
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: width - width / 15,
            child: whereToTextField,
          ),
          SizedBox(
            height: height / 60,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  SizedBox(
                    width: width / 2 - 15,
                    child: fromDateField,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: width / 2 - 15,
                    child: toDateField,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: height / 60,
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Guests",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                _guestCount != 1
                    ? IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() => _guestCount--),
                        enableFeedback: false,
                      )
                    : const IconButton(
                        icon: Icon(Icons.remove),
                        enableFeedback: false,
                        onPressed: null,
                      ),
                Text(_guestCount.toString()),
                _guestCount >= 12
                    ? const IconButton(
                        icon: Icon(Icons.add),
                        onPressed: null,
                        enableFeedback: false,
                      )
                    : IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() => _guestCount++),
                        enableFeedback: false,
                      ),
                const Text(
                  "Rooms",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                _roomCount != 1
                    ? IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => setState(() {
                          _roomCount--;
                        }),
                        enableFeedback: false,
                      )
                    : const IconButton(
                        icon: Icon(Icons.remove),
                        enableFeedback: false,
                        onPressed: null,
                      ),
                Text(_roomCount.toString()),
                _roomCount >= 10
                    ? const IconButton(
                        icon: Icon(Icons.add),
                        onPressed: null,
                        enableFeedback: false,
                      )
                    : IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => setState(() {
                          _roomCount++;
                        }),
                        enableFeedback: false,
                      )
              ],
            ),
          ),
        ]);
  }
}
