import 'dart:async';

import 'package:flame_playarea/utils/randomNumber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SnackDirection { left, up, down, right }

class SnackGameScreen extends StatefulWidget {
  const SnackGameScreen({Key? key}) : super(key: key);

  @override
  State<SnackGameScreen> createState() => _SnackGameScreenState();
}

class _SnackGameScreenState extends State<SnackGameScreen> {
  List<int> snake = [];
  Timer? gameLoop;
  late int columns = 0;
  late int score = 0;
  late int rows = 0;
  late bool isLoading = true;
  late SnackDirection snackDirection = SnackDirection.down;
  late bool gameOver = false;
  late int foodIndex = 0;
  late double blockHeightAndWidth = 30.0;

  Color _gridContainerColor(int index) {
    if (snake.contains(index)) return Colors.red;
    if (foodIndex == index) return Colors.greenAccent;
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
      columns = (MediaQuery.of(context).size.width ~/ blockHeightAndWidth);
      rows =
          (MediaQuery.of(context).size.height * (0.7) ~/ blockHeightAndWidth);
      snake.add((columns ~/ 2) * 5);
      snake.add(snake.first - columns);

      isLoading = false;
      foodIndex = RandomNumber.randomInteger(columns * rows);

      setState(() {});
      startTimer();
    });
  }

  void reStart() {
    snake = [];
    snake.add((columns ~/ 2) * 5);
    snake.add(snake.first - columns);

    isLoading = false;
    gameOver = false;
    snackDirection = SnackDirection.down;
    score = 0;
    foodIndex = RandomNumber.randomInteger(columns * rows);
    startTimer();
    setState(() {});
  }

  void startTimer() {
    gameLoop = Timer.periodic(Duration(milliseconds: 400), (timer) {
      if (snackDirection == SnackDirection.down) {
        //check snack is not hitting bottom edge
        if ((rows * columns) - snake.first > columns) {
          snake.insert(0, snake.first + columns);
        } else {
          timer.cancel();
          gameOver = true;
        }
      } else if (snackDirection == SnackDirection.up) {
        //check snack is not hitting bottom edge
        if (snake.first > columns) {
          snake.insert(0, snake.first - columns);
        } else {
          timer.cancel();
          gameOver = true;
        }
      } else if (snackDirection == SnackDirection.right) {
        bool hittingEdge = false;
        for (var i = 0; i < rows; i++) {
          if (snake.first == (columns - 1) + columns * i) {
            hittingEdge = true;
          }
        }

        if (!hittingEdge) {
          snake.insert(0, snake.first + 1);
        } else {
          timer.cancel();
          gameOver = true;
        }
      } else if (snackDirection == SnackDirection.left) {
        //check for left edge
        bool hittingEdge = false;
        for (var i = 0; i < rows; i++) {
          if (snake.first == (i * columns)) {
            hittingEdge = true;
          }
        }

        if (!hittingEdge) {
          snake.insert(0, snake.first - 1);
        } else {
          timer.cancel();
          gameOver = true;
        }
      }
      if (snake.sublist(1).contains(snake.first)) {
        timer.cancel();
        gameOver = true;
      } else {
        if (snake.contains(foodIndex)) {
          score++;
          foodIndex = RandomNumber.randomInteger(columns * rows);
        } else {
          snake.removeLast();
        }
      }

      setState(() {});
    });
  }

  Widget _buildControlMenu() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    if (snackDirection != SnackDirection.down) {
                      snackDirection = SnackDirection.up;
                    }
                  },
                  icon: Icon(Icons.arrow_upward)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        if (snackDirection != SnackDirection.right) {
                          snackDirection = SnackDirection.left;
                        }
                      },
                      icon: Icon(Icons.arrow_back_rounded)),
                  IconButton(
                      onPressed: () {
                        if (snackDirection != SnackDirection.up) {
                          snackDirection = SnackDirection.down;
                        }
                      },
                      icon: Icon(Icons.arrow_downward)),
                  IconButton(
                      onPressed: () {
                        if (snackDirection != SnackDirection.left) {
                          snackDirection = SnackDirection.right;
                        }
                      },
                      icon: Icon(Icons.arrow_forward)),
                ],
              )
            ],
          ),
        ));
  }

  Widget _buildScore() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(left: 30.0, bottom: 30.0),
        child: Text("Score : $score"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                RawKeyboardListener(
                  autofocus: true,
                  focusNode: FocusNode(),
                  onKey: (key) {
                    if (key.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
                      if (snackDirection != SnackDirection.right) {
                        snackDirection = SnackDirection.left;
                      }
                    } else if (key
                        .isKeyPressed(LogicalKeyboardKey.arrowRight)) {
                      if (snackDirection != SnackDirection.left) {
                        snackDirection = SnackDirection.right;
                      }
                    } else if (key.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
                      if (snackDirection != SnackDirection.down) {
                        snackDirection = SnackDirection.up;
                      }
                    } else if (key.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
                      if (snackDirection != SnackDirection.up) {
                        snackDirection = SnackDirection.down;
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.5,
                        vertical: 2.5,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 2.5,
                          mainAxisSpacing: 2.5),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(
                            right: 5.0,
                          ),
                          alignment: Alignment.centerRight,
                          child: snake.first == index
                              ? CircleAvatar(
                                  radius: 5,
                                )
                              : SizedBox(),
                          decoration: BoxDecoration(
                              color: _gridContainerColor(index),
                              borderRadius: BorderRadius.circular(2.5)),
                        );
                      },
                      itemCount: rows * columns,
                    ),
                  ),
                ),
                _buildControlMenu(),
                _buildScore(),
                gameOver
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        alignment: Alignment.center,
                        child: AlertDialog(
                          content: Text("Score $score"),
                          actions: [
                            CupertinoButton(
                                child: Text("Back"),
                                onPressed: () {
                                  //
                                  Navigator.of(context).pop();
                                }),
                            CupertinoButton(
                                child: Text("Play Again"),
                                onPressed: () {
                                  reStart();
                                }),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
