import 'package:coffee_dog/repo/repo.dart';
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

class Indogging extends StatelessWidget {
  @override
  String userName = "";
  String cardId = "";
  final Repo repo;

  String infoText = """
  Register your NTNU student card to get started with your CoffeeDogging experience. 
  Note that registering a card might take a couple of seconds. 
  Be patient!""";

  String helpText =
      'This is the cardno parameter found at https://api.ntnu.no/me api.ntnu.no/me  (do CTRL + F and type "cardno")';

  Indogging({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
