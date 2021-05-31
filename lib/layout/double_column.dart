import 'package:fire_caht/screens/auth_screen.dart';
import 'package:flutter/material.dart';

class DoubleColumnLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Container(
                width: double.maxFinite,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      '/logo.jpg',
                      fit: BoxFit.cover,
                    ),
                    Text(
                      'Fire Chat',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(flex: 3, child: AuthScreen()),
        ],
      ),
    );
  }
}
