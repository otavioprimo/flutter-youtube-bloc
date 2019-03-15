import 'package:youtube_favorites_bloc/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_favorites_bloc/models/video.dart';

import 'dart:async';

class VideosBloc implements BlocBase {
  Api api;
  List<Video> videos;

  final StreamController<List<Video>> _videosController =
      StreamController<List<Video>>();

  Stream get outVideos =>
      _videosController.stream; //Retorna os dados para a view

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch =>
      _searchController.sink; //Pega o valor da pesquisa da view

  VideosBloc() {
    api = Api();

    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if (search != null) {
      _videosController.sink.add([]);
      videos = await api.search(search);
    } else {
      videos += await api.nextPage();
    }

    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _searchController.close();
    _videosController.close();
  }
}
