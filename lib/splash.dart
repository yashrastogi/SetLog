import 'package:flutter/material.dart';
import 'package:setlog/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});
  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    Future.delayed(const Duration(milliseconds: 2500), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(title: widget.title)));
    });
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.fitness_center, size: 100, color: Colors.white),
                SizedBox(height: 16),
                Text('Welcome to SetLog',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    )),
                Text('Use this app to track progressive overload',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
