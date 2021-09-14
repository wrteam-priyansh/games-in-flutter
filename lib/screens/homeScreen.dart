// ignore_for_file: file_names

import 'package:flame_playarea/screens/flappyBallScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<String> games = ["Flappy Ball"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Games"),
      ),
      body: ListView.builder(
          itemCount: games.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                if (games[index] == "Flappy Ball") {
                  Navigator.of(context).push(CupertinoPageRoute(builder: (context) => const FlappyBallScreen()));
                }
              },
              title: Text(games[index]),
            );
          }),
    );
  }
}
