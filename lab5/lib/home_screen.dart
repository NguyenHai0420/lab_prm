import 'package:flutter/material.dart';
import 'package:lab5/movie.dart';
import 'package:lab5/movie_detail_screen.dart';
import 'package:lab5/sample_data.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movie app',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: movies.length,

        itemBuilder: (context, index) {
          final Movie movie = movies[index];

          return _MovieCard(movie: movie);
        },
      ),
    );
  }
}

class _MovieCard extends StatelessWidget {
  final Movie movie;

  const _MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),

      clipBehavior: Clip.antiAlias,

      child: InkWell(
        onTap: () {
          // Navigate to the detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movie: movie),
            ),
          );
        },

        child: SizedBox(
          height: 170,

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Movie poster
              Hero(
                tag: 'movie-${movie.id}',

                child: Image.network(
                  movie.posterUrl,

                  width: 110,
                  height: 170,

                  fit: BoxFit.cover,

                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 110,
                      height: 170,
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, size: 40),
                    );
                  },
                ),
              ),

              // Movie information
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        movie.title,

                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),

                          const SizedBox(width: 5),

                          Text(
                            movie.rating.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Genres
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,

                        children: movie.genres
                            .take(2)
                            .map(
                              (genre) => Chip(
                                label: Text(
                                  genre,
                                  style: const TextStyle(fontSize: 11),
                                ),

                                padding: EdgeInsets.zero,

                                visualDensity: VisualDensity.compact,
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
