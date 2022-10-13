import 'package:flutter/material.dart';
import 'package:my_first_app/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // player variable
  double playerX = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.pink[200],
            child: Center(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      alignment: Alignment(playerX, 1),
                      child: Container(
                        color: Colors.deepPurple,
                        height: 50,
                        width: 50,
                      ),
                    ),
                  )
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
              MyButton(icon: Icons.arrow_back),
              MyButton(icon: Icons.arrow_upward),
              MyButton(icon: Icons.arrow_forward)
            ],
          ),
        )),
      ],
    );
  }
}
