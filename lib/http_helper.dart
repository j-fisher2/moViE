import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter_application_movies/movie.dart';
import 'config.dart';

class HttpHelper {
  final String apiKey = Config.apiKey;
  final String urlBase = "https://api.themoviedb.org/3/movie";
  final String urlUpcoming = '/upcoming';
  final String urlLanguage = '&language=en-US';
  final String urlSearchBase = 'https://api.themoviedb.org/3/search/movie';

  Future<List<Movie>> getUpcoming() async {
    final String upcomingUrl = '$urlBase$urlUpcoming?api_key=$apiKey$urlLanguage';
    print('Requesting URL: $upcomingUrl'); // Log the URL being requested

    try {
      http.Response result = await http.get(Uri.parse(upcomingUrl));

      if (result.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(result.body);
        final List<dynamic> moviesMap = jsonResponse['results'];
        List<Movie> movies = moviesMap.map((jsonItem) =>
            Movie.fromJson(jsonItem)).toList();
        return movies;
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      print('Exception during HTTP call: $e');
      throw Exception('Failed to connect to the server');
    }
  }

  Future<List<Movie>> findMovies(String title) async {
    final String query = '$urlSearchBase?api_key=$apiKey&query=$title';
    print(query); // Debug print to check the constructed query
    try {
      final http.Response response = await http.get(Uri.parse(query));
      print(response); // Debug print to check the HTTP response

      if (response.statusCode == HttpStatus.ok) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> moviesMap = jsonResponse['results'];
        print(moviesMap); // Debug print to check the parsed movie results

        List<Movie> movies = moviesMap.map((jsonItem) =>
            Movie.fromJson(jsonItem)).toList();
        return movies;
      } else {
        throw Exception('Failed to load movie search');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }
}
