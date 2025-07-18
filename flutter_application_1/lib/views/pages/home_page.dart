import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/constants.dart' show KValue;
import 'package:flutter_application_1/views/pages/course_page.dart';
import 'package:flutter_application_1/views/widgets/container_widget.dart';
import 'package:flutter_application_1/views/widgets/hero_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      KValue.basicLayout,
      KValue.basicLayoutDescription,
      KValue.welcomeScreenLottie,
      KValue.welcomeLottie,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0),
            HeroWidget(title: "Welcome to My App", nextPage: CoursePage()),
            SizedBox(height: 10.0),
            ...List.generate(list.length, (index) {
              return ContainerWidget(
                title: list.elementAt(index),
                description: "The description of the layout goes for here",
              );
            }),
          ],
        ),
      ),
    );
  }
}
