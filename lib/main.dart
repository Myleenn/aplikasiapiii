import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const JokeFetcherApp());
}

class JokeFetcherApp extends StatelessWidget {
  const JokeFetcherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'freak Joke',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const JokePage(),
    );
  }
}

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  _JokePageState createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  String joke = '';
  String errorMessage = '';

  Future<void> fetchJoke() async {
    setState(() {
      joke = '';
      errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse('https://official-joke-api.appspot.com/random_joke'),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Print the response body

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          joke = '${data['setup']} \n\n${data['punchline']}'; // Extract the joke
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load joke.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Freak Joke'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchJoke,
              child: const Text('Try me!'),
            ),
            const SizedBox(height: 20.0),
            if (errorMessage.isNotEmpty) ...[
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 20.0),
            Text(
              joke,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}