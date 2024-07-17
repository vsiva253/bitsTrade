import 'package:bits_trade/screens/bottombar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Error500Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/error.gif', // Replace with your GIF file path
              width: MediaQuery.of(context).size.width * 0.8,
          
            ),
            SizedBox(height: 16),
          
            Text(
              'Oops! Something went wrong.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Container(
              width: 120,
              height: 50,
              child: ElevatedButton(onPressed: (){
                Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>BottomBar()));
              
              }, child: Text('Retry')),
            )
          ],
        ),
      ),
    );
  }
}