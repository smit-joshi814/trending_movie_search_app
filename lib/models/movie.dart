import 'dart:convert';

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final int releaseYear;
  final double imdbRating;
  final double popularity;

  Movie(
      {required this.id,
      required this.title,
      required this.posterPath,
      required this.releaseYear,
      required this.imdbRating,
      required this.popularity});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'releaseYear': releaseYear,
      'imdbRating': imdbRating,
      'popularity': popularity
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
        title: map['title'] as String,
        posterPath: map['posterPath'] as String,
        releaseYear: map['releaseYear'] as int,
        imdbRating: map['imdbRating'] as double,
        popularity: map['popularity'] as double,
        id: map['id'] as int);
  }

  String toJson() => json.encode(toMap());

  factory Movie.fromJson(String source) =>
      Movie.fromMap(json.decode(source) as Map<String, dynamic>);
}
