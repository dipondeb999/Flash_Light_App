import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_controller/torch_controller.dart';

class FlashLightScreen extends StatefulWidget {
  const FlashLightScreen({Key? key}) : super(key: key);

  @override
  State<FlashLightScreen> createState() => _FlashLightScreenState();
}

class _FlashLightScreenState extends State<FlashLightScreen> with TickerProviderStateMixin{

  late AnimationController _animatedController;
  Color color = Colors.white;
  double fontSize = 20;
  bool isClicked = true;
  final controller = TorchController();

  final DecorationTween decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black),
      boxShadow: const [
        BoxShadow(
          color: Colors.white,
          spreadRadius: 5,
          blurRadius: 20,
          offset: Offset(0, 0),
        ),
      ],
    ),
    end: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black),
      boxShadow: const [
        BoxShadow(
          color: Colors.red,
          spreadRadius: 30,
          blurRadius: 15,
          offset: Offset(0, 0),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _animatedController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (isClicked) {
                _animatedController.forward();
                fontSize = 24;
                color = Colors.red;
                HapticFeedback.lightImpact();
              }else{
                _animatedController.reverse();
                fontSize = 20;
                color = Colors.white;
                HapticFeedback.lightImpact();
              }
              isClicked =! isClicked;
              controller.toggle();
              setState(() {});
            },
            child: Center(
              child: DecoratedBoxTransition(
                position: DecorationPosition.background,
                decoration: decorationTween.animate(_animatedController),
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: Center(
                    child: Icon(
                      Icons.power_settings_new,
                      color: isClicked? Colors.black : Colors.red,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height / 1.4,
            alignment: Alignment.bottomCenter,
            child: AnimatedDefaultTextStyle(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 200),
              child: Text(!isClicked? "FlashLight ON" : "Flashlight OFF"),
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
