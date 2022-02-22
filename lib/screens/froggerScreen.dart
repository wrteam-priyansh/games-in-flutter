// ignore_for_file: file_names

import 'package:flame/game.dart';
import 'package:flame_playarea/games/froggerGame.dart';
import 'package:flutter/material.dart';

class FroggerScreen extends StatefulWidget {
  const FroggerScreen({Key? key}) : super(key: key);

  @override
  _FroggerScreenState createState() => _FroggerScreenState();
}

class _FroggerScreenState extends State<FroggerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [GameWidget<FroggerGame>(game: FroggerGame())],
      ),
    );
  }
}
