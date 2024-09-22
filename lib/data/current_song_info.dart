
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class CurrentSongInfo extends ChangeNotifier {
  SongModel? _song;
  int? _index;
  bool _isSameSong = false;

  set setCurrentSong(SongModel song) {
    _song = song;

    notifyListeners();
  }

  set setCurrentSongIndex(int? index) {
    _index = index;

    notifyListeners();
  }

  set setIsSameSong(int index) {
    _isSameSong = (index != _index) ? false : true;

    notifyListeners();
  }


  SongModel? get getCurrentSong => _song;
  int? get getCurrentSongIndex => _index;
  bool get isSameSong => _isSameSong;
}