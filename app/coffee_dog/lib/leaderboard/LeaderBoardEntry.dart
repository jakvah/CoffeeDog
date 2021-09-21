import 'package:coffee_dog/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderBoardEntry extends StatelessWidget {
  final String image;
  final String name;
  final int score;
  final int rank;
  final int movement;

  const LeaderBoardEntry(
      {Key? key,
      required this.image,
      required this.name,
      required this.score,
      required this.movement,
      required this.rank})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Row(
      children: [
        Padding(padding: EdgeInsets.fromLTRB(width * 0.0, 0, 0, 0)),
        Container(
          width: Theme.of(context).textTheme.headline4!.fontSize!,
          height: Theme.of(context).textTheme.headline4!.fontSize!,
          decoration: BoxDecoration(
              // color: MAIN_COLOR,
              borderRadius: BorderRadius.circular(
                  Theme.of(context).textTheme.headline6!.fontSize!)),
          child: Text(
            "${this.rank}",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Padding(padding: EdgeInsets.fromLTRB(width * 0.02, 0, 0, 0)),
        Stack(
          children: [
            Container(
              width: width * 0.8,
              margin: EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(50, 15, 20, 15)),
                      Text("name",
                          style: TextStyle(
                            color: GREY_COLOR,
                            fontSize:
                                Theme.of(context).textTheme.headline6!.fontSize,
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Score",
                          style: TextStyle(
                            color: GREY_COLOR,
                            fontSize:
                                Theme.of(context).textTheme.headline6!.fontSize,
                          )),
                      Padding(padding: EdgeInsets.fromLTRB(50, 15, 20, 15)),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: SECONDARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
            ),
            Positioned(left: 0, top: 4, child: RoundImage("url")),
          ],
        ),
      ],
    );
  }
}

class RoundImage extends StatelessWidget {
  final String url;
  RoundImage(String url) : this.url = url;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(
                "https://akamai.vgc.no/drfront/images/2021/09/20/c=113,80,1058,723;w=527;h=360;633830.jpg"),
            fit: BoxFit.fill),
      ),
    );
  }
}
