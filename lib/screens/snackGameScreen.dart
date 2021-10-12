import 'dart:async';

import 'package:flutter/material.dart';

class SnackGameScreen extends StatefulWidget {
  const SnackGameScreen({Key? key}) : super(key: key);

  @override
  State<SnackGameScreen> createState() => _SnackGameScreenState();
}

class _SnackGameScreenState extends State<SnackGameScreen> {
  List<int> snake = [];
  Timer? gameLoop;

  Color _gridContainerColor(int index) {
    if (snake.contains(index)) return Colors.red;
    return Theme.of(context).colorScheme.secondary;
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      snake.add(((MediaQuery.of(context).size.width ~/ 30) ~/ 2) * 5);
      setState(() {});
      startTimer();
    });
  }

  void startTimer() {
    gameLoop = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (snake.first < (MediaQuery.of(context).size.width ~/ 30) * 10) {
        if (snake.length == 1) {
          snake.first = snake.first + (MediaQuery.of(context).size.width ~/ 30);
        } else {}
      } else {
        print("Game Over");
        timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
        ),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: 2.5,
            vertical: 2.5,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).size.width ~/ 30), crossAxisSpacing: 5.0, mainAxisSpacing: 5.0),
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(color: _gridContainerColor(index), borderRadius: BorderRadius.circular(2.5)),
            );
          },
          itemCount: (MediaQuery.of(context).size.width ~/ 30) * 10,
        ),
      ),
    );
  }
}
