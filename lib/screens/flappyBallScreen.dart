// ignore_for_file: file_names

import 'package:flame/game.dart';
import 'package:flame_playarea/games/game.dart';
import 'package:flutter/material.dart';

class FlappyBallScreen extends StatefulWidget {
  const FlappyBallScreen({Key? key}) : super(key: key);

  @override
  State<FlappyBallScreen> createState() => _FlappyBallScreenState();
}

class _FlappyBallScreenState extends State<FlappyBallScreen> {
  late bool isGameOver = false;
  late FlappyBirdGame flappyBirdGame =
      FlappyBirdGame(isGameOver: changeGameOver);

  void changeGameOver() {
    isGameOver = !isGameOver;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget<FlappyBirdGame>(game: flappyBirdGame),
          isGameOver
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white30,
                  child: AlertDialog(
                    title: const Text("Game Over"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              isGameOver = !isGameOver;
                              flappyBirdGame =
                                  FlappyBirdGame(isGameOver: changeGameOver);
                            });
                          },
                          child: const Text("Play Agian")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Go Back")),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
