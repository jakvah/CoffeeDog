import 'package:coffee_dog/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LeaderBoardEntry extends StatelessWidget {
  final String image;
  final String name;
  final int score;
  final int movement;

  const LeaderBoardEntry(
      {Key? key,
      required this.image,
      required this.name,
      required this.score,
      required this.movement})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Row(
      children: [
        Padding(padding: EdgeInsets.all(20)),
        Stack(
          children: [
            Container(
              width: width * 0.6,
              margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(50, 10, 20, 10)),
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
                      Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 10)),
                    ],
                  ),
                ],
              ),
              decoration: BoxDecoration(
                  color: SECONDARY_COLOR,
                  borderRadius: BorderRadius.all(Radius.circular(40))),
            ),
            Positioned(left: 0, top: 12.5, child: RoundImage("url")),
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
