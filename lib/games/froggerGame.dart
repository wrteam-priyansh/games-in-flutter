// ignore_for_file: file_names

import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/keyboard.dart';
import 'package:flame_playarea/utils/randomNumber.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FroggerGame extends BaseGame with KeyboardEvents {
  late Rect frog;
  final double frogWidthHeightPercentage = 0.04;
  final double vehiclesPerRow = 3;
  late double frogHeightWidth;

  final double vehicleHeightPercentage = 0.05;
  late double vehicleHeight;

  late Size screenSize;
  late Rect nonWaterLine;
  late Rect waterLine;

  late Rect firstVehicle;
  late Rect secondVehicle;
  late Rect thirdVehicle;

  late Rect fourthVehicle;
  late Rect fifthVehicle;
  late Rect sixthVehicle;

  late Rect seventhVehicle;
  late Rect eighthVehicle;
  late Rect ninthVehicle;

  late List<Rect> bottomVehicles = [];

  int generateVehicleSpace() {
    Random random = Random.secure();
    return random.nextInt(1);
  }

  void addVehicles() {
    //add bottom vehicles
    //inbetween space so frog can move across them

    //bottom vehicles top screenSize.height - vehicleHeight - (frogHeightWidth * 1.25)
    for (int i = 0; i < vehiclesPerRow; i++) {
      //
      if (i == 0) {
        bottomVehicles.add(Rect.fromLTWH(
            0,
            screenSize.height - vehicleHeight - (frogHeightWidth * 1.25),
            screenSize.width * RandomNumber.randomDouble(0.2, 0.4),
            vehicleHeight));
      } else {
        Rect previousVehicle = bottomVehicles[i - 1];
        bottomVehicles.add(Rect.fromLTWH(
            previousVehicle.left -
                previousVehicle.width -
                (frogHeightWidth *
                    (RandomNumber.randomDouble(0.5, 0.75) + 1.0)),
            previousVehicle.top,
            screenSize.width * RandomNumber.randomDouble(0.2, 0.3),
            vehicleHeight));
      }
      debugPrint(
          "Vehicle $i left - ${bottomVehicles[i].left.toStringAsFixed(2)}");
    }
  }

  @override
  Future<void> onLoad() async {
    screenSize = size.toSize();
    frogHeightWidth = screenSize.width * frogWidthHeightPercentage;
    vehicleHeight = screenSize.width * vehicleHeightPercentage;

    nonWaterLine = Rect.fromLTWH(0, screenSize.height * (0.5), screenSize.width,
        screenSize.width * frogWidthHeightPercentage);
    waterLine = Rect.fromLTWH(0, screenSize.height * (0.05), screenSize.width,
        screenSize.width * frogWidthHeightPercentage);
    frog = Rect.fromLTWH(screenSize.width * (0.5) - frogHeightWidth,
        screenSize.height - frogHeightWidth, frogHeightWidth, frogHeightWidth);

    addVehicles();
    /*
    //three, six and nine
    thirdVehicle = Rect.fromLTWH(0, screenSize.height - (screenSize.width * vehicleHeightPercentage) - (frogHeightWidth * 1.25), screenSize.width * vehicleHeightPercentage * 2, screenSize.width * vehicleHeightPercentage);
    //sixth vehicle height and top will be same as third
    sixthVehicle = Rect.fromLTWH(thirdVehicle.left + thirdVehicle.width + screenSize.width * 0.1, thirdVehicle.top, thirdVehicle.width + screenSize.width * vehicleHeightPercentage, thirdVehicle.height);
    //ninth vehicle
    ninthVehicle = Rect.fromLTWH(sixthVehicle.left + (screenSize.width * 0.25) + (sixthVehicle.width + screenSize.width * vehicleHeightPercentage), sixthVehicle.top, sixthVehicle.width + screenSize.width * vehicleHeightPercentage, sixthVehicle.height);

    //second,five and eight
    secondVehicle = Rect.fromLTWH(screenSize.width - (screenSize.width * vehicleHeightPercentage * 3), screenSize.height - (screenSize.width * vehicleHeightPercentage * 2) - (frogHeightWidth * 1.55), screenSize.width * vehicleHeightPercentage * 3,
        screenSize.width * vehicleHeightPercentage);

    fifthVehicle = Rect.fromLTWH(secondVehicle.left - (screenSize.width * vehicleHeightPercentage * 2.5) - (screenSize.width * 0.15), screenSize.height - (screenSize.width * vehicleHeightPercentage * 2) - (frogHeightWidth * 1.55),
        screenSize.width * vehicleHeightPercentage * 2.5, screenSize.width * vehicleHeightPercentage);

    eighthVehicle = Rect.fromLTWH(fifthVehicle.left - (screenSize.width * vehicleHeightPercentage * 1.0 + fifthVehicle.width) - (screenSize.width * 0.2), screenSize.height - (screenSize.width * vehicleHeightPercentage * 2) - (frogHeightWidth * 1.55),
        (screenSize.width * vehicleHeightPercentage * 1.0 + fifthVehicle.width), screenSize.width * vehicleHeightPercentage);

    //first ,fourth and seventh
    firstVehicle = Rect.fromLTWH(0, screenSize.height - (screenSize.width * vehicleHeightPercentage * 3) - (frogHeightWidth * 1.85), screenSize.width * vehicleHeightPercentage * 2.5, screenSize.width * vehicleHeightPercentage);
    fourthVehicle = Rect.fromLTWH(firstVehicle.left + firstVehicle.width + (screenSize.width * vehicleHeightPercentage * 2.75) + screenSize.width * (0.15), screenSize.height - (screenSize.width * vehicleHeightPercentage * 3) - (frogHeightWidth * 1.85),
        (screenSize.width * vehicleHeightPercentage * 2.75), screenSize.width * vehicleHeightPercentage);
    seventhVehicle = Rect.fromLTWH(fourthVehicle.left + (screenSize.width * vehicleHeightPercentage * 1.5 + fourthVehicle.width) + screenSize.width * (0.225), screenSize.height - (screenSize.width * vehicleHeightPercentage * 3) - (frogHeightWidth * 1.85),
        (screenSize.width * vehicleHeightPercentage * 1.5 + fourthVehicle.width), screenSize.width * vehicleHeightPercentage);

    */
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    Paint paint = Paint()..color = Colors.white;

    canvas.drawRect(nonWaterLine, Paint()..color = Colors.green);
    canvas.drawRect(waterLine, Paint()..color = Colors.green);

    for (var i = 0; i < vehiclesPerRow; i++) {
      canvas.drawRect(bottomVehicles[i], Paint()..color = Colors.blue);
    }

    /*
    //draw vehicle
    canvas.drawRect(thirdVehicle, Paint()..color = Colors.blue);
    canvas.drawRect(sixthVehicle, Paint()..color = Colors.purpleAccent);
    canvas.drawRect(ninthVehicle, Paint()..color = Colors.orangeAccent);

    //
    canvas.drawRect(secondVehicle, Paint()..color = Colors.purple);
    canvas.drawRect(fifthVehicle, Paint()..color = Colors.deepOrangeAccent);
    canvas.drawRect(eighthVehicle, Paint()..color = Colors.blueAccent);
    //
    canvas.drawRect(firstVehicle, Paint()..color = Colors.deepOrange);
    canvas.drawRect(fourthVehicle, Paint()..color = Colors.blueAccent);
    canvas.drawRect(seventhVehicle, Paint()..color = Colors.purpleAccent);
    */

    //
    canvas.drawRect(frog, paint);

    super.render(canvas);
  }

  @override
  void update(double dt) {
    moveVehicles(dt);
    super.update(dt);
  }

  void moveVehicles(double dt) {
    for (var i = 0; i < vehiclesPerRow; i++) {
      Rect bottomVehicle = bottomVehicles[i];

      if (bottomVehicle.left < (screenSize.width + bottomVehicle.width)) {
        bottomVehicles[i] = Rect.fromLTWH(bottomVehicle.left + (dt * 150),
            bottomVehicle.top, bottomVehicle.width, bottomVehicle.height);
      } else {
        bottomVehicles[i] = Rect.fromLTWH(-bottomVehicle.width,
            bottomVehicle.top, bottomVehicle.width, bottomVehicle.height);
      }
    }

    /*
    //move third vehicle
    if (thirdVehicle.left < (screenSize.width + thirdVehicle.width)) {
      thirdVehicle = Rect.fromLTWH(thirdVehicle.left + (dt * 150), thirdVehicle.top, thirdVehicle.width, thirdVehicle.height);
    }
    //move sixth vehicle
    if (sixthVehicle.left < (screenSize.width + sixthVehicle.width)) {
      sixthVehicle = Rect.fromLTWH(sixthVehicle.left + (dt * 150), sixthVehicle.top, sixthVehicle.width, sixthVehicle.height);
    }

    //move ninth vehicle
    if (ninthVehicle.left < (screenSize.width + ninthVehicle.width)) {
      ninthVehicle = Rect.fromLTWH(ninthVehicle.left + (dt * 150), ninthVehicle.top, ninthVehicle.width, ninthVehicle.height);
    }

    

    //move second vehicle
    if (secondVehicle.left > -(secondVehicle.width)) {
      secondVehicle = Rect.fromLTWH(secondVehicle.left - (dt * 150), secondVehicle.top, secondVehicle.width, secondVehicle.height);
    }
    //move fifth vehicle
    if (fifthVehicle.left > -(fifthVehicle.width)) {
      fifthVehicle = Rect.fromLTWH(fifthVehicle.left - (dt * 150), fifthVehicle.top, fifthVehicle.width, fifthVehicle.height);
    }
    //move eigth vehicle
    if (eighthVehicle.left > -(eighthVehicle.width)) {
      eighthVehicle = Rect.fromLTWH(eighthVehicle.left - (dt * 150), eighthVehicle.top, eighthVehicle.width, eighthVehicle.height);
    }

    //move first vechile
    if (firstVehicle.left < (screenSize.width + firstVehicle.width)) {
      firstVehicle = Rect.fromLTWH(firstVehicle.left + (dt * 150), firstVehicle.top, firstVehicle.width, firstVehicle.height);
    }
    //move fourth vechile
    if (fourthVehicle.left < (screenSize.width + fourthVehicle.width)) {
      fourthVehicle = Rect.fromLTWH(fourthVehicle.left + (dt * 150), fourthVehicle.top, fourthVehicle.width, fourthVehicle.height);
    }
    //move seventh vechile
    if (seventhVehicle.left < (screenSize.width + seventhVehicle.width)) {
      seventhVehicle = Rect.fromLTWH(seventhVehicle.left + (dt * 150), seventhVehicle.top, seventhVehicle.width, seventhVehicle.height);
    }
    */
  }

  @override
  void onKeyEvent(RawKeyEvent event) {
    if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
      if (frog.top > 0) {
        frog = Rect.fromLTWH(
            frog.left, frog.top - frogHeightWidth, frog.width, frog.height);
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
      if (frog.top < (screenSize.height - frogHeightWidth)) {
        frog = Rect.fromLTWH(
            frog.left, frog.top + frogHeightWidth, frog.width, frog.height);
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
      if (frog.left > 0) {
        frog = Rect.fromLTWH(
            frog.left - frogHeightWidth, frog.top, frog.width, frog.height);
      }
    } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
      if (frog.left < (screenSize.width - frogHeightWidth)) {
        frog = Rect.fromLTWH(
            frog.left + frogHeightWidth, frog.top, frog.width, frog.height);
      }
    }
  }
}
