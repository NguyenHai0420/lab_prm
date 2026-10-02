import 'package:flutter/material.dart';

class Ex1CoreWidgetsDemo extends StatelessWidget {
  const Ex1CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exercise 1 – Core Widgets: Text, Image, Icon, Card, ListTile',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome to Flutter UI',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Icon(Icons.movie, size: 60, color: Colors.blue),
          const SizedBox(height: 24),
          Image.network(
            'https://picsum.photos/500/600?grayscale',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,

            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 160,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 160,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, size: 48),
              );
            },
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Movie Item'),
              subtitle: const Text('This is a sample ListTile inside a Card.'),
            ),
          ),
        ],
      ),
    );
  }
}
