import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_api/movies.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MovieHome(),
    );
  }
}

class MovieHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MovieState();
  }
}

class MovieState extends State<MovieHome> {
  var url = "https://api.themoviedb.org/3/movie/top_rated?api_key=186afbd4a6bf37fb67270160c4525761";
  movies movie;

  fetchData() async {
    var data = await http.get(url);
    var json = jsonDecode(data.body);
    movie = movies.fromJson(json);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Top Rated")),
      body: movie == null
      ? Center(child: CircularProgressIndicator())
      : Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: GridView.count(
          childAspectRatio: 0.6,
          crossAxisCount: 2,
          children: movie.results.map((m) => new Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetail(movie: m)));
              },
              child: Hero(
                tag: m.posterPath,
                child: Column(
                  children: [
                    Image.network("https://image.tmdb.org/t/p/w500/"+m.posterPath, fit: BoxFit.fill),
                    SizedBox(height: 10),
                    Text(m.title, maxLines: 2, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center, style: TextStyle(fontSize: 18))
                  ]
                )
              )
            )
          )).toList()
        )
      )
    );
  }
}

class MovieDetail extends StatelessWidget {
  final Results movie;

  MovieDetail({this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image.network("https://image.tmdb.org/t/p/w500/"+movie.posterPath, fit: BoxFit.fill)
            ),
            new Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(movie.title, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rating: ${movie.popularity}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Date: ${movie.releaseDate}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                    ]
                  ),
                  SizedBox(height: 15),
                  Text(movie.overview, style: TextStyle(fontSize: 18))
                ]
              )
            )
          ]
        )
      )
    );
  }
}