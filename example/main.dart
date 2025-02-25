import 'package:flutter/material.dart';
import 'package:silver_flutter_shimmer/src/shimmer_direction.dart';
import 'package:silver_flutter_shimmer/src/shimmer_effect.dart';
import 'package:silver_flutter_shimmer/src/shimmer_extension.dart';
import 'package:silver_flutter_shimmer/src/shimmer_theme.dart';

void main() {
  ShimmerTheme().update(
    duration: Duration(seconds: 3),
    speedFactor: 3.5,
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    direction: ShimmerDirection.leftToRight,
    effect: ShimmerEffect.wave,
    angle: 45
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Shimmer on Text')),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: _isLoading
                            ? null
                            : Image.network(
                          'https://source.unsplash.com/300x200/?nature',
                          fit: BoxFit.cover,
                        ),
                      ).shimmer(shimmer: _isLoading),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Beautiful Nature View',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ).shimmer(shimmer: _isLoading),
                          const SizedBox(height: 10),
                           Text(
                            'This is a sample description of the card content.',
                            style: TextStyle(color: Colors.grey[600]),
                          ).shimmer(shimmer: _isLoading),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
