import 'package:flutter/material.dart';

class Ex3LayoutDemo extends StatelessWidget {
  const Ex3LayoutDemo({super.key});

  // Danh sách phim.
  final List<String> movies = const [
    'Interstellar',
    'Inception',
    'The Dark Knight',
    'Avengers: Endgame',
    'Spider-Man: No Way Home',
    'Dune',
    'The Matrix',
    'Inside Out',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercise 3 - Layout Basics')),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Column, Padding
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

            child: Text(
              'Movie Home',

              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),

          // Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),

            child: Row(
              children: [
                const Icon(Icons.local_movies),

                const SizedBox(width: 8),

                Text('${movies.length} movies available'),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Listview

          // ListView nằm trong Column cần Expanded để có chiều cao giới hạn.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              itemCount: movies.length,

              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),

                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),

                    title: Text(movies[index]),

                    subtitle: const Text('Movie item'),

                    trailing: const Icon(Icons.play_circle_outline),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
