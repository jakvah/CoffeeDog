import 'package:coffee_dog/main.dart';
import 'package:coffee_dog/repo/repo.dart';
import 'package:coffee_dog/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Define a custom Form widget.
class IndoggingForm extends StatefulWidget {
  final Repo repo;
  final Function loginCallback;
  final LoginStatus loginStatus;
  const IndoggingForm(
      {Key? key,
      required this.repo,
      required this.loginCallback,
      required this.loginStatus})
      : super(key: key);
  @override
  _IndoggingFormState createState() => _IndoggingFormState(this.loginStatus);
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _IndoggingFormState extends State<IndoggingForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  String userName = "";
  String cardId = "";
  var _loginStatus;

  final String infoText =
      "Register your NTNU student card to get started with your CoffeeDogging experience. \n";
  final String link = "api.ntnu.no/me";
  final String helpText1 = '\nThis is the cardno parameter found at ';
  final String helpText2 = ' (do CTRL + F and type "cardno")';

  final _textController = TextEditingController();
  final _usernameTextController = TextEditingController();

  _IndoggingFormState(this._loginStatus);

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

  inDogging() async {
    print(_textController.text);
    var doggingstatus = await widget.repo.login(_textController.text);
    widget.loginCallback(doggingstatus);
    if (mounted) {
      setState(() {
        _loginStatus = doggingstatus;
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textController.dispose();
    _usernameTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 30, 15, 10),
            child: RichText(
              text: TextSpan(
                text: infoText,
                style: DefaultTextStyle.of(context).style,
                children: <TextSpan>[
                  TextSpan(
                      text: helpText1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                  TextSpan(
                    text: link,
                    style: new TextStyle(color: Colors.blue),
                    recognizer: new TapGestureRecognizer()
                      ..onTap = () {
                        var url = "https://api.ntnu.no/me";
                      },
                  ),
                ],
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
          if (_loginStatus == LoginStatus.CreateDog)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextField(
                controller: _usernameTextController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter user name',
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.all(0),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: DARK_BROWN,
                  textStyle: const TextStyle(fontSize: 20)),
              onPressed: inDogging,
              child: const Text('Dogg in'),
            ),
          ),
        ],
      ),
    );
  }
}
