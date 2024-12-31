import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text Input Field with integrated Search button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Search Books',
                  border: OutlineInputBorder(),
                  suffixIcon: ElevatedButton(
                    onPressed: () {
                      // Add your search functionality here
                      print('Search button clicked');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('Search'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
