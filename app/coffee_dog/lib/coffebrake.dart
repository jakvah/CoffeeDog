import 'package:coffee_dog/repo/repo.dart';
import 'package:coffee_dog/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

enum LoginStatus { NoDogging, Dogging }

class UserPreferences {
  Future<bool> saveUser(int user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("uid", user);

    return prefs.commit();
  }

  Future<LoginStatus> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? user = prefs.getInt("uid");
    if (user != null) {
      return LoginStatus.Dogging;
    }

    return LoginStatus.NoDogging;
  }
}

// Define a custom Form widget.
class IndoggingForm extends StatefulWidget {
  final Repo repo;
  const IndoggingForm({Key? key, required this.repo}) : super(key: key);
  @override
  _IndoggingFormState createState() => _IndoggingFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _IndoggingFormState extends State<IndoggingForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  String userName = "";
  String cardId = "";

  String infoText =
      "Register your NTNU student card to get started with your CoffeeDogging experience. Note that registering a card might take a couple of seconds. Be patient!";

  String helpText =
      'This is the cardno parameter found at https://api.ntnu.no/me api.ntnu.no/me  (do CTRL + F and type "cardno")';

  final _textController = TextEditingController();

  _IndoggingFormState();

  // @override
  // void initState() {
  //   super.initState();
  //   _textController.addListener(() {
  //     final String text = _textController.text.toLowerCase();
  //     _textController.value = _textController.value.copyWith(
  //       text: text,
  //       selection:
  //           TextSelection(baseOffset: text.length, extentOffset: text.length),
  //       composing: TextRange.empty,
  //     );
  //   });
  // }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Flexible(
            child: Text(
              infoText,
              softWrap: true,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 10, 10),
          child: Flexible(
            child: Text(
              helpText,
              softWrap: true,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            controller: _textController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter cardno',
            ),
          ),
        ),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: DARK_BROWN, textStyle: const TextStyle(fontSize: 20)),
            onPressed: () {},
            child: const Text('Dogg in'),
          ),
        ),
      ],
    );
  }
}
