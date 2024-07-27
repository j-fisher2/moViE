import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetail extends StatelessWidget{
  final Movie movie;
  final String imgPath='https://image.tmdb.org/t/p/w500/';
  final String defaultPath='https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';
  MovieDetail(this.movie);
  @override Widget build(BuildContext context){
    String path=(movie.posterPath!=null) ? imgPath+movie.posterPath : defaultPath;
    double height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(title:Text(movie.title)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Container(
                  padding: EdgeInsets.all(16),
                  height: height / 1.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16), // Set the radius here
                    child: Image.network(
                      path,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16.0), // Adjust padding as needed
                child: Text(
                  movie.overview,
                  style: TextStyle(fontSize: 16.0),) // Adjust text style as needed
                ),
            ],
          ),
        ),
      ),
    );
  }
}