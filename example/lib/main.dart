import 'package:flutter/material.dart';
import 'package:silver_shimmer/silver_shimmer.dart';

void main() {
  ShimmerTheme().update(
    duration: const Duration(seconds: 2),
    speedFactor: 3.0,
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    direction: ShimmerDirection.leftToRight,
    effect: ShimmerEffect.classic,
    angle: 15,
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
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Silver Shimmer Demo',
      home: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Text('Silver Shimmer',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Profile Section
              Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.shade300,
                    child: _isLoading
                        ? null
                        : ClipOval(
                      child: Image.asset("assets/profile.jpg",
                          fit: BoxFit.cover),
                    ),
                  ).shimmer(shimmer: _isLoading, borderRadius: 1234),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("John Doe",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold))
                          .shimmer(shimmer: _isLoading),
                      const SizedBox(height: 4),
                      Text("Flutter Developer",
                          style: TextStyle(color: Colors.grey.shade600))
                          .shimmer(shimmer: _isLoading),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Card with Image + Text
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Container(
                        height: 160,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: _isLoading
                            ? null
                            : Image.asset(
                          'assets/car.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ).shimmer(shimmer: _isLoading),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Red Sports Car",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                              .shimmer(shimmer: _isLoading),
                          const SizedBox(height: 8),
                          Text(
                            "This is a sample description of the card content.",
                            style: TextStyle(color: Colors.grey.shade600),
                          ).shimmer(shimmer: _isLoading),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ListView Tiles
              Column(
                children: List.generate(
                  3,
                      (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: _isLoading
                              ? null
                              : const Icon(Icons.person, color: Colors.white),
                        ).shimmer(shimmer: _isLoading),

                        // Custom column for title + subtitle with spacing
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Contact Name $index")
                                .shimmer(shimmer: _isLoading),
                            const SizedBox(height: 8), // 8px spacing
                            Text(
                              "Subtitle text goes here",
                              style: TextStyle(color: Colors.grey.shade600),
                            ).shimmer(shimmer: _isLoading),
                          ],
                        ),

                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey.shade500,
                        ).shimmer(shimmer: _isLoading),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
