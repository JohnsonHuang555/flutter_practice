import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_first_app/ball.dart';
import 'package:my_first_app/button.dart';
import 'package:my_first_app/missile.dart';
import 'package:my_first_app/player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Direction { left, right }

class _HomePageState extends State<HomePage> {
  // player variable
  static double playerX = 0;

  double missileX = playerX;
  double missileHeight = 10;
  bool midShot = false;

  // ball variables
  double ballX = 0.5;
  double ballY = 1;
  var ballDirection = Direction.left;

  void startGame() {
    double time = 0;
    double height = 0;
    double velocity = 60; // how strong the jump is

    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      height = -5 * time * time + velocity * time;

      // if the ball reaches the ground, reset the jump
      if (height < 0) {
        time = 0;
      }

      // update the new ball position
      setState(() {
        ballY = heightToPosition(height);
      });

      // if the ball hits the left wall, then change direction to right
      if (ballX - 0.005 < -1) {
        ballDirection = Direction.right;
      }
      // if the ball hits the right wall, then change direction to left
      else if (ballX + 0.005 > 1) {
        ballDirection = Direction.left;
      }

      // move the ball in the correct direction
      if (ballDirection == Direction.left) {
        setState(() {
          ballX -= 0.005;
        });
      } else if (ballDirection == Direction.right) {
        setState(() {
          ballX += 0.004;
        });
      }

      // check if ball hits the player
      if (playerDies()) {
        timer.cancel();
        _showDialog();
      }

      // keep the time going!
      time += 0.1;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
              backgroundColor: Colors.grey,
              title: Text(
                "You dead!",
                style: TextStyle(color: Colors.white),
              ));
        });
  }

  void moveLeft() {
    setState(() {
      if (playerX - 0.1 < -1) {
        // do nothing
      } else {
        playerX -= 0.1;
      }
      // only make the X coordinate the same when it isn't the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void moveRight() {
    setState(() {
      if (playerX + 0.1 > 1) {
        // do nothing
      } else {
        playerX += 0.1;
      }
      // only make the X coordinate the same when it isn't the middle of a shot
      if (!midShot) {
        missileX = playerX;
      }
    });
  }

  void fireMissile() {
    if (midShot == false) {
      Timer.periodic(const Duration(milliseconds: 20), (timer) {
        // shots fired
        midShot = true;

        // missile grows til it hits the top of the screen
        setState(() {
          missileHeight += 10;
        });

        // stop missile when it reaches top of screen
        if (missileHeight > MediaQuery.of(context).size.height * 3 / 4) {
          resetMissile();
          timer.cancel();
        }

        // check if missile has hit the ball
        if (ballY > heightToPosition(missileHeight) &&
            (ballX - missileX).abs() < 0.03) {
          resetMissile();
          ballX = 5;
          timer.cancel();
        }
      });
    }
  }

  // converts height to a position
  double heightToPosition(double height) {
    double totalHeight = MediaQuery.of(context).size.height * 3 / 4;
    double position = 1 - 2 * height / totalHeight;
    return position;
  }

  void resetMissile() {
    missileX = playerX;
    missileHeight = 10;
    midShot = false;
  }

  bool playerDies() {
    // if the ball position and the player position
    // are the same, then player dies
    if ((ballX - playerX).abs() < 0.05 && ballY > 0.95) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        } else if (event.isKeyPressed(LogicalKeyboardKey.space)) {
          fireMissile();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.pink[100],
              child: Center(
                child: Stack(
                  children: [
                    MyBall(ballX: ballX, ballY: ballY),
                    MyMissile(height: missileHeight, missileX: missileX),
                    MyPlayer(
                      playerX: playerX,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MyButton(
                  icon: Icons.play_arrow,
                  function: startGame,
                ),
                MyButton(
                  icon: Icons.arrow_back,
                  function: moveLeft,
                ),
                MyButton(icon: Icons.arrow_upward, function: fireMissile),
                MyButton(icon: Icons.arrow_forward, function: moveRight)
              ],
            ),
          )),
        ],
      ),
    );
  }
}
