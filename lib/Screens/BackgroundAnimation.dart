import 'package:competative_chores/Classes/Formatting.dart';
import 'package:flutter/material.dart';
import 'package:particles_flutter/particles_flutter.dart';

class BackgroundAnimation extends StatelessWidget {
  BackgroundAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(color: Formatting.creame),
      child: CircularParticle(
        randColorList: [Formatting.bannerBlue, Formatting.bannerRed, Formatting.lighterRed, Formatting.lighterRed],
        awayRadius: 500,
        numberOfParticles: 500,
        speedOfParticles: 0.5,
        height: screenHeight,
        width: screenWidth,
        onTapAnimation: true,
        awayAnimationDuration: Duration(milliseconds: 500),
        maxParticleSize: 4,
        isRandSize: true,
        particleColor: Formatting.bannerRed,
        isRandomColor: false,
        awayAnimationCurve: Curves.decelerate,
        connectDots: true, //not recommended
      ),
    );
  }
}
