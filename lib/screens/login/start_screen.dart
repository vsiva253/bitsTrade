import 'package:bits_trade/screens/login/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding( // Add padding to control the content within the Column
          padding: const EdgeInsets.symmetric(horizontal: 20), // Adjust padding as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/logo.svg',
                width: MediaQuery.of(context).size.width / 1.424,
              ),
              const SizedBox(height: 24),
              Text(
                'Your Modern Stock Market Journey',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8), // Add some space between text widgets
              Text(
                'Elevate Your Trading Beyond Expectations',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 83),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  // fixedSize: Size(200, 48),
                         // Fixed height for the button
                
                ),
                onPressed: () {
             Navigator.push(context, CupertinoPageRoute(builder: (context)=> const LoginScreen()));
                },
                child: const Text('Get Started'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}