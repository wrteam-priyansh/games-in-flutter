// ignore_for_file: file_names

import 'package:flame_playarea/screens/flappyBallScreen.dart';
import 'package:flame_playarea/screens/froggerScreen.dart';
import 'package:flame_playarea/screens/snackGameScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> games = ["Flappy Ball", "Frogger", "Snack"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Games"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Size size = MediaQuery.of(context).size;
          Rect rect = Rect.fromLTWH(size.width * (0.25), 0, size.width * (0.3), size.height * (0.5));
          Rect otherRect = Rect.fromLTWH(size.width * (0.75), 0, size.width * (0.3), size.height * (0.5));
          Rect intersectRect = rect.intersect(otherRect);

          debugPrint(intersectRect.height.toString());

          debugPrint(intersectRect.width.toString());
        },
      ),
      body: ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                if (games[index] == "Flappy Ball") {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const FlappyBallScreen()));
                } else if (games[index] == "Frogger") {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const FroggerScreen()));
                } else if (games[index] == "Snack") {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const SnackGameScreen()));
                }
              },
              title: Text(games[index]),
            );
          }),
    );
  }
}
