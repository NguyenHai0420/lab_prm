class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> listOfTrailers;

  Movie(
    this.id,
    this.title,
    this.posterUrl,
    this.overview,
    this.genres,
    this.rating,
    this.listOfTrailers,
  );
}
