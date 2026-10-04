import 'package:flutter/material.dart';

void main() {
  runApp(const Lab6ReposiveUIApp());
}

/*
Đối tượng Movie
 */
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating});
}

/*
Dữ liệu ví dụ cho Movie
 */
const List<Movie> sampleMovies = [
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Drama', 'Sci-Fi'],
    posterUrl: 'https://tse1.mm.bing.net/th/id/OIP.DVYDQX85lQdcPGsSxAd-rgHaKy?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
    rating: 8.4,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/seed/darkknight/400/600',
    rating: 9.0,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://tse2.mm.bing.net/th/id/OIP.Rt7dy6EVY4xT6wngC0jFLwHaLH?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
    rating: 7.7,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Drama'],
    posterUrl: 'https://tse4.mm.bing.net/th/id/OIP.oUXT49Fgo3Ew6NZYJ6GZnAHaKx?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
    rating: 8.7,
  ),
  Movie(
    title: 'The Notebook',
    year: 2004,
    genres: ['Romance', 'Drama'],
    posterUrl: 'https://i5.walmartimages.com/seo/The-Notebook-Movie-Poster-11-x-17_5d1b11af-3e8b-470b-8f0a-3c55b5a4cd75.0f591bb30c5e225ba46718ba252d04c0.jpeg',
    rating: 7.8,
  ),
  Movie(
    title: 'John Wick',
    year: 2014,
    genres: ['Action'],
    posterUrl: 'https://tse1.mm.bing.net/th/id/OIP.5V84l8YITuUH4FqYA-5aswHaLB?r=0&rs=1&pid=ImgDetMain&o=7&rm=3',
    rating: 7.5,
  ),
];

/*
Ứng dụng
 */
class Lab6ReposiveUIApp extends StatelessWidget {
  const Lab6ReposiveUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Responsive Movie Browser',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF7F7FA),
      ),
      home: const GenresScreen(),
    );
  }
}

/*
Thể loại phim
 */
class GenresScreen extends StatefulWidget {
  const GenresScreen({super.key});

  @override
  State<GenresScreen> createState() => GenresScreenState();
}

class GenresScreenState extends State<GenresScreen> {
  // Nội dung cần tìm
  String searchQuery = '';

  // Chọn thể loại phim
  final Set<String> selectedGenres = {};

  // Chọn kiểu sắp xếp mong muốn
  String selectedSort = 'A-Z';

  // Danh sách các thể loại phù hợp
  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Romance',
  ];

  /*
  Lọc và Sắp xếp
   */
  List<Movie> get visibleMovies {
    // Tạo danh sách mới để sắp xếp
    List<Movie> movies = sampleMovies.where((movie){

      // Tìm kiến theo lựa chọn lọc
      final matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      // Lọc theo thể loại
      final matchesGenres =
          selectedGenres.isEmpty || movie.genres.any((genres) => selectedGenres.contains(genres),
      );
      return matchesSearch && matchesGenres;
    }).toList();

    // Sắp xếp
    switch (selectedSort) {
      case 'A-Z':
        movies.sort(
            (a, b) => a.title.toLowerCase().compareTo(
              b.title.toLowerCase(),
            ),
        );
        break;

      case 'Z-A':
        movies.sort(
              (a, b) => b.title.toLowerCase().compareTo(
            a.title.toLowerCase(),
          ),
        );
        break;

      case 'Year':
        movies.sort(
            (a, b) => b.year.compareTo(a.year),
        );
        break;

      case 'Rating':
        movies.sort(
              (a, b) => b.rating.compareTo(a.rating),
        );
        break;
    }
    return movies;
  }

  /*
  Thay đổi thể loại phim
   */
  void toggleGenre(String genre) {
    setState(() {
      if (selectedGenres.contains(genre)) {
        selectedGenres.remove(genre);
      } else {
        selectedGenres.add(genre);
      }
    });
  }

  /*
  Xóa hết các lựa chọn lọc
   */
  void clearFilters() {
    setState(() {
      searchQuery = '';
      selectedGenres.clear();
      selectedSort = 'A-Z';
    });
  }

  /*
  Widget build
   */
  @override
  Widget build(BuildContext context) {
    // MediaQuery dùng để lấy độ rộng màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth >= 800 ? 32 : 16,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Header
              buildHeader(),

              const SizedBox(height: 20),
              // Search bar
              buildSearchBar(),

              const SizedBox(height: 20),

              // Genres section
              buildGenreSection(),

              const SizedBox(height: 20),

              // Sort bar
              buildSortBar(),

              const SizedBox(height: 16),

              // Movie list
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Breakpoint:
                    // < 800px  -> ListView
                    // >= 800px -> GridView with 2 columns
                    if (constraints.maxWidth < 800) {
                      return buildMovieList();
                    } else {
                      return buildMovieGrid();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
  Widget header
   */
  Widget buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find a Movie',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Thể loại đã chọn
        if (selectedGenres.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${selectedGenres.length} selected',
              style: TextStyle(
                color: Colors.deepPurple.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  /*
  Widget thanh tìm kiếm
   */
  Widget buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search movies...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
          onPressed: () {
            setState(() {
              searchQuery = '';
            });
          },
          icon: const Icon(Icons.clear),
        )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Colors.deepPurple,
            width: 2,
          ),
        ),
      ),
    );
  }

  /*
  Widget thể loại
   */
  Widget buildGenreSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Genres',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            if (selectedGenres.isNotEmpty)
              TextButton(
                onPressed: clearFilters,
                child: const Text('Clear'),
              ),
          ],
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: genres.map((genre) {
            final isSelected = selectedGenres.contains(genre);

            return FilterChip(
              label: Text(genre),
              selected: isSelected,
              onSelected: (_) {
                toggleGenre(genre);
              },
              avatar: isSelected
                  ? const Icon(
                Icons.check,
                size: 18,
              )
                  : null,
              selectedColor: Colors.deepPurple.shade100,
              checkmarkColor: Colors.deepPurple,
            );
          }).toList(),
        ),
      ],
    );
  }

  /*
  Widget thanh sắp xếp
   */
  Widget buildSortBar() {
    return Row(
      children: [
        Text(
          '${visibleMovies.length} movies',
          style: TextStyle(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),

        const Spacer(),

        const Text(
          'Sort by:',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(width: 8),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedSort,
              items: const [
                DropdownMenuItem(
                  value: 'A-Z',
                  child: Text('A-Z'),
                ),
                DropdownMenuItem(
                  value: 'Z-A',
                  child: Text('Z-A'),
                ),
                DropdownMenuItem(
                  value: 'Year',
                  child: Text('Year'),
                ),
                DropdownMenuItem(
                  value: 'Rating',
                  child: Text('Rating'),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  selectedSort = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  /*
  Widget danh sách phim
   */
  Widget buildMovieList() {
    if (visibleMovies.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      itemCount: visibleMovies.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: MovieCard(
            movie: visibleMovies[index],
            isGrid: false,
          ),
        );
      },
    );
  }

  /*
  Widget giao diện lưới hiển thị phim
   */
  Widget buildMovieGrid() {
    if (visibleMovies.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2.1,
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      children: visibleMovies.map((movie) {
        return MovieCard(
          movie: movie,
          isGrid: true,
        );
      }).toList(),
    );
  }

  /*
  Widget trạng thái trống
   */
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.movie_filter_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No movies found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try changing your search or filters.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

/*
Thẻ phim
 */
class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isGrid;

  const MovieCard({
    super.key,
    required this.movie,
    required this.isGrid,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {

        // Phản hồi kích thước phù hợp
        final posterWidth = isGrid
            ? constraints.maxWidth * 0.28
            : 110.0;

        final posterHeight = posterWidth * 1.45;

        return Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [

                // Poster
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    movie.posterUrl,
                    width: posterWidth,
                    height: posterHeight,
                    fit: BoxFit.cover,

                    // Thông báo khi đang tải ảnh
                    loadingBuilder:
                        (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        width: posterWidth,
                        height: posterHeight,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },

                    // Lỗi nếu không tải được ảnh
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return Container(
                        width: posterWidth,
                        height: posterHeight,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.movie_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(width: 14),

                // Thông tin phim
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '${movie.year}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Đánh giá
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Thể loại phim
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: movie.genres.map((genre) {
                          return Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.shade50,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              genre,
                              style: TextStyle(
                                fontSize: 11,
                                color:
                                Colors.deepPurple.shade700,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}