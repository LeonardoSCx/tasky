import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Cargando...', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.teal),)
          ],
        ),
      ),
    );
  }
}
