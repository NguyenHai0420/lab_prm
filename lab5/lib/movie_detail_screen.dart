import 'package:flutter/material.dart';

import 'movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => MovieDetailScreenState();
}

class MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final Movie movie = widget.movie;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),

      // SingleChildScrollView makes
      // the entire detail page scrollable.
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            // Hero banner
            buildHeroBanner(movie),

            // Movie information
            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // Title
                  Text(
                    movie.title,

                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),

                      const SizedBox(width: 6),

                      Text(
                        '${movie.rating}/10',

                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Genres
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,

                    children: movie.genres
                        .map(
                          (genre) => Chip(
                            label: Text(genre),

                            avatar: const Icon(Icons.local_movies, size: 16),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  // Overview
                  const Text(
                    'Overview',

                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    movie.overview,

                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: Colors.grey[300],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions button
                  buildActionButtons(),

                  const SizedBox(height: 28),

                  // Trailers
                  const Text(
                    'Trailers',

                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  buildTrailerList(movie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hero banner
  Widget buildHeroBanner(Movie movie) {
    return SizedBox(
      height: 430,

      width: double.infinity,

      child: Stack(
        fit: StackFit.expand,

        children: [
          // Movie poster
          Hero(
            tag: 'movie-${movie.id}',

            child: Image.network(
              movie.posterUrl,

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[900],

                  child: const Icon(Icons.movie, size: 80),
                );
              },
            ),
          ),

          // Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,

                end: Alignment.bottomCenter,

                colors: [Colors.transparent, Color(0xFF101010)],
              ),
            ),
          ),

          // Title on banner
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,

            child: Text(
              movie.title,

              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,

                shadows: [Shadow(blurRadius: 8, color: Colors.black)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action buttons
  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,

      children: [

        // Favorite
        _ActionButton(
          icon: isFavorite ? Icons.favorite : Icons.favorite_border,

          label: 'Favorite',

          color: isFavorite ? Colors.red : Colors.white,

          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),

        // Rate
        _ActionButton(
          icon: Icons.star_border,

          label: 'Rate',

          onPressed: () {
            _showRateDialog();
          },
        ),

        // Share
        _ActionButton(
          icon: Icons.share,

          label: 'Share',

          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share button pressed!')),
            );
          },
        ),
      ],
    );
  }

  // Rate dialog
  void _showRateDialog() {
    showDialog(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text('Rate Movie'),

          content: const Text('Thank you for rating this movie!'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Trailer list
  Widget buildTrailerList(Movie movie) {
    return ListView.builder(

      // Number of trailers
      itemCount: movie.listOfTrailers.length,

      // Allow the outer
      // SingleChildScrollView to scroll
      shrinkWrap: true,

      physics: const NeverScrollableScrollPhysics(),

      itemBuilder: (context, index) {

        // Because trailers is List<String>
        final String trailerUrl = movie.listOfTrailers[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),

          child: ListTile(
            contentPadding: const EdgeInsets.all(8),

            // Trailer icon
            leading: Container(
              width: 70,
              height: 55,

              decoration: BoxDecoration(
                color: Colors.grey[800],

                borderRadius: BorderRadius.circular(8),
              ),

              child: const Icon(
                Icons.play_circle_fill,
                color: Colors.red,
                size: 34,
              ),
            ),

            // Trailer name
            title: Text(
              'Trailer ${index + 1}',

              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            // Trailer URL
            subtitle: Text(
              trailerUrl,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,
            ),

            // Play button
            trailing: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Playing Trailer ${index + 1}')),
                );
              },

              icon: const Icon(Icons.play_arrow, size: 30),
            ),
          ),
        );
      },
    );
  }
}

// Reusable action button
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          onPressed: onPressed,

          icon: Icon(icon, color: color, size: 28),
        ),

        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
