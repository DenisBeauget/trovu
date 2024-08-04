import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:Trovu/screen/tutorial_one.dart';
import 'package:Trovu/screen/tutorial_three.dart';
import 'package:Trovu/screen/tutorial_two.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: CarouselSlider(
        options: CarouselOptions(
            viewportFraction: 1.1,
            scrollDirection: Axis.horizontal,
            enableInfiniteScroll: false,
            height: double.maxFinite,
            enlargeCenterPage: true,
            initialPage: 0,
            scrollPhysics: const RangeMaintainingScrollPhysics(),
            aspectRatio: 5),
        items: const [TutorialOne(), TutorialTwo(), TutorialThree()],
      ),
    );
  }
}
