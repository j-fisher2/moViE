import 'package:flutter/material.dart';
import 'http_helper.dart';
import 'movie.dart';
import 'movie_detail.dart';
import 'main.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  int moviesCount = 0;
  List<Movie> result = []; // Initial state message
  String title='Popular';
  String searchMovie = '';
  HttpHelper httpHelper = HttpHelper();
  final String iconBase = 'https://image.tmdb.org/t/p/w92/';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isSearching=false;

  @override
  void initState() {
    super.initState();
    fetchData();
    searchFocusNode=FocusNode();
  }

  void fetchData() async {
    try {
      List<Movie> upcomingMovies = await httpHelper.getUpcoming();
      setState(() {
        result = upcomingMovies; // Update state with fetched data
        moviesCount = result.length;
        print('Fetched ${result.length} movies.');
        print(result); // Print the fetched movies for debugging
      });
    } catch (e) {
      print('Error fetching upcoming movies: $e');
      // Handle error scenario: display error message or retry logic
    }
  }

  void fetchMovieSearch() async{
    try{
      if(searchMovie.isNotEmpty){
        print(searchMovie);
        String search=searchMovie.replaceAll(' ','-');
        List<Movie> searchResult = await httpHelper.findMovies(searchMovie);
        print('await result');
        print(searchResult[0].id);
        setState((){
          result=searchResult;
          moviesCount=result.length;
        });
      }
    }
    catch (e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image = NetworkImage(defaultImage);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: isSearching ? TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchMovie = value;
            });
          },
        ) : Text(
          searchMovie!='' ? searchMovie : "Popular",
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  FocusScope.of(context).unfocus();
                } else {
                  searchFocusNode.requestFocus();
                }
              });
            },
          ),
          if (isSearching)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                fetchMovieSearch();
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                    FocusScope.of(context).unfocus();
                  } else {
                    searchFocusNode.requestFocus();
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  searchMovie = '';
                  fetchData();
                });
              },
            ),
        ],
      ),
      drawer:MyDrawer(),
      body: ListView.builder(
        itemCount: moviesCount,
        itemBuilder: (BuildContext context, int index) {
          /*
          if (searchMovie.isEmpty ||
              result[index].title.toLowerCase().contains(searchMovie.toLowerCase())) {
            if (result[index].posterPath != null) {
              image = NetworkImage(iconBase + result[index].posterPath);
            }
            */
            image = NetworkImage(iconBase + result[index].posterPath);
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(backgroundImage: image),
                title: Text(result[index].title),
                subtitle: Text('Released: ' + result[index].releaseDate),
                onTap: () {
                  MaterialPageRoute route =
                  MaterialPageRoute(builder: (_) => MovieDetail(result[index]));
                  Navigator.push(context, route);
                },
              ),
            );

        },
      ),
    );
  }
}