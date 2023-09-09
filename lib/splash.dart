import 'package:flutter/material.dart';
import 'package:setlog/home.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(title: title)));
    });

    return const Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text("Welcome to SetLog.")),
        ],
      ),
    );
  }
}
