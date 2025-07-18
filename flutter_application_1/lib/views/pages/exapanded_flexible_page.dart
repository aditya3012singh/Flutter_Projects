import 'package:flutter/material.dart';

class ExapandedFlexiblePage extends StatelessWidget {
  const ExapandedFlexiblePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Expanded and Flexible")),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.teal,
                  child: Center(
                    child: Text(
                      "Expanded Widget",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Flexible(
                // flex: 2,
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      "Expanded Widget",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
