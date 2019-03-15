import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites_bloc/blocs/favorite_bloc.dart';
import 'package:youtube_favorites_bloc/blocs/videos_bloc.dart';
import 'package:youtube_favorites_bloc/delegates/data_search.dart';
import 'package:youtube_favorites_bloc/models/video.dart';
import 'package:youtube_favorites_bloc/views/favorites.dart';
import 'package:youtube_favorites_bloc/widgets/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final blocVideo = BlocProvider.of<VideosBloc>(context);
    final blocFav = BlocProvider.of<FavoriteBloc>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/yt_logo_rgb_dark.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.black87,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: blocFav.outFav,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data.length}");
                } else {
                  return Container();
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Favorites()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              //Abre a tela de pesquisa
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null)
                blocVideo.inSearch
                    .add(result); //Envia para o bloc o dado de pesquisa
            },
          )
        ],
      ),
      body: StreamBuilder(
        initialData: [],
        stream: blocVideo.outVideos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else if (index > 1) {
                  blocVideo.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else
            return Container();
        },
      ),
    );
  }
}
