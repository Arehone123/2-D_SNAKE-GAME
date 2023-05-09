import 'package:flutter/material.dart';
import 'dart:math';

enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  @override
  _SnakeGameState createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  final int numRows = 20;
  final int numCols = 20;
  final int initSnakeLength = 5;
  final Duration snakeSpeed = Duration(milliseconds: 300);

  List<int> snake = [];
  int food = 0;
  Direction currentDirection = Direction.right;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      snake = [45, 44, 43, 42, 41];
      food = generateRandomFood();
      currentDirection = Direction.right;
    });

    Future.delayed(snakeSpeed, moveSnake);
  }

  int generateRandomFood() {
    Random random = Random();
    int randomNumber = random.nextInt(numRows * numCols);
    while (snake.contains(randomNumber)) {
      randomNumber = random.nextInt(numRows * numCols);
    }
    return randomNumber;
  }

  void moveSnake() {
    setState(() {
      final int head = snake.first;
      int nextCell;

      switch (currentDirection) {
        case Direction.up:
          nextCell = head - numCols;
          if (nextCell < 0) {
            nextCell += numRows * numCols;
          }
          break;
        case Direction.down:
          nextCell = (head + numCols) % (numRows * numCols);
          break;
        case Direction.left:
          nextCell = (head - 1) % numCols == numCols - 1
              ? head - 1 + numCols
              : head - 1;
          break;
        case Direction.right:
          nextCell = (head + 1) % numCols == 0 ? head + 1 - numCols : head + 1;
          break;
      }

      if (snake.contains(nextCell)) {
        gameOver();
        return;
      }

      snake.insert(0, nextCell);

      if (nextCell == food) {
        food = generateRandomFood();
      } else {
        snake.removeLast();
      }
    });

    Future.delayed(snakeSpeed, moveSnake);
  }

  void gameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('You lost!'),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragUpdate: (details) {
      if (currentDirection != Direction.up &&
          details.delta.dy > 0) {
        setState(() {
          currentDirection = Direction.down;
        });
      } else if (currentDirection != Direction.down &&
          details.delta.dy < 0) {
        setState(() {
          currentDirection = Direction.up;
        });
      }
    },
    onHorizontalDragUpdate: (details) {
    if (currentDirection != Direction.left &&
    details.delta.dx > 0) {
    setState(() {
    currentDirection = Direction.right;
    });
    } else if (currentDirection != Direction.right &&
    details.delta.dx < 0) {
    setState(() {
    currentDirection = Direction.left;
    });
    }

    else if (currentDirection != Direction.right &&
        details.delta.dx < 0) {
      setState(() {
        currentDirection = Direction.left;
      });
    }
    },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Snake Game'),
        ),
        body: GridView.builder(
          itemCount: numRows * numCols,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numCols,
          ),
          itemBuilder: (context, index) {
            if (snake.contains(index)) {
              return Container(
                color: Colors.purple,
              );
            } else if (index == food) {
              return Container(
                color: Colors.black,
              );
            } else {
              return Container(
                color: Colors.orange,
              );
            }
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SnakeGame(),
  ));
}
