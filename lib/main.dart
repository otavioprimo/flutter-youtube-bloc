import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_favorites_bloc/blocs/favorite_bloc.dart';
import 'package:youtube_favorites_bloc/blocs/videos_bloc.dart';
import 'package:youtube_favorites_bloc/views/home.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.black87);
    FlutterStatusbarcolor.setNavigationBarColor(Colors.black87);
    return BlocProvider(
        bloc: VideosBloc(),
        child: BlocProvider(
          bloc: FavoriteBloc(),
          child: MaterialApp(
            title: 'Youtube Favorites',
            home: Home(),
          ),
        ));
  }
}
