import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends ChangeNotifier {
    final player = AudioPlayer();
    Duration? duration;
    int? playListID;

    final Map<int,List<SongModel>> _songs = {};
    final Map<int, dynamic> _concatenatingAudioSources = {};

    OnAudioQuery onAudioQuery = OnAudioQuery();
    

    Future<List<SongModel>> getAudios() async {
      final fetchedSongs = await onAudioQuery.querySongs();
      List<AudioSource> sources = [];
      

      for (SongModel song in fetchedSongs) {
          sources.add(
            AudioSource.uri(
              Uri.parse(song.uri!),
              tag: MediaItem(id: song.id.toString(), title: song.displayNameWOExt)
            )
          );
      }

      
      _songs[0] = fetchedSongs;
      _concatenatingAudioSources[0] = ConcatenatingAudioSource(children: sources, shuffleOrder: DefaultShuffleOrder());

      return fetchedSongs;
    }

    Future<void> startSong() async {
      await player.play();
      notifyListeners();
    }
    
    Future<void> playSong(int index, int playlistID) async {

      await player.setAudioSource(_concatenatingAudioSources[playlistID], initialIndex: index, initialPosition: Duration.zero, preload: true);
      
      await player.setLoopMode(LoopMode.all);
      notifyListeners();
    }

    Future<void> stopAudio() async {
      await player.stop();
    }

    Future<void> pauseHandler() async {
      if (!player.playing) {
        await player.play();
      } else {
        await player.pause();
      }
      notifyListeners();
    }

    Future<void> nextSong() async {
      await player.seekToNext();
      notifyListeners();
    }

    Future<void> previousSong() async {
      await player.seekToPrevious();
      notifyListeners();
    }

    set setPlaylistID(int playListID) {
      this.playListID = playListID;
      notifyListeners();
    }


    //Playlist Methods
    Future<void> createPlaylist(String playlistName) async {
      await onAudioQuery.createPlaylist(playlistName);
      notifyListeners();
    }

    Future<List<PlaylistModel>> getPlaylists() async {
      List<PlaylistModel> playlists = await onAudioQuery.queryPlaylists();

      return playlists;
    }

    Future<List<SongModel>> getPlaylistSongs(int playlistID) async {
      List<SongModel> playlistSongs = await onAudioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, playlistID);

      List<AudioSource> sources = [];

      for (SongModel song in playlistSongs) {
          sources.add(
            AudioSource.uri(
              Uri.parse(song.data),
              tag: MediaItem(id: song.id.toString(), title: song.displayNameWOExt)
            )
          );
      }
      _songs[playlistID] = playlistSongs;
      _concatenatingAudioSources[playlistID] = ConcatenatingAudioSource(children: sources, shuffleOrder: DefaultShuffleOrder());

      return playlistSongs;
    }

    Future<void> addSongToPlaylist(int playlistID, int audioID) async {
      await onAudioQuery.addToPlaylist(playlistID, audioID);
      notifyListeners();
    }

    Future<void> deleteSongFromPlaylist(int playlistID, int audioID, List<SongModel> playlistSongs) async {
        updatePlaylist(playlistID, playlistSongs);
        bool result = await onAudioQuery.removeFromPlaylist(playlistID, audioID);
        
        print("DID IT DELETE: $result");
        
        notifyListeners();
    }

    Future<void> deletePlaylist(int id) async{
      await onAudioQuery.removePlaylist(id);
      notifyListeners();
    }

    Future<bool> isSongInPlaylist(int playlistID, int songID) async {
      List<SongModel> songs = await onAudioQuery.queryAudiosFrom(AudiosFromType.PLAYLIST, playlistID);

      for (SongModel song in songs) {
        if (song.id == songID) {
          return true;
        }
      }

      return false;

    }

    void updatePlaylist(int playlistID, List<SongModel> playlistSongs) {

      List<AudioSource> sources = [];

      for (SongModel song in playlistSongs) {
          sources.add(
            AudioSource.uri(
              Uri.parse(song.data),
              tag: MediaItem(id: song.id.toString(), title: song.displayNameWOExt)
            )
          );
      }
      
      _songs[playlistID] = playlistSongs;
      _concatenatingAudioSources[playlistID] = ConcatenatingAudioSource(children: sources, shuffleOrder: DefaultShuffleOrder());
    }

    //Getters
    bool get isPlaying => player.playing;
    bool get hasPrevious => player.hasPrevious;
    bool get isSongCached => player.currentIndex == null;
    int get getPlaylistID => playListID ?? 0;
    Stream<Duration> get playingPosition => player.positionStream;
    Map<int,List<SongModel>> get songPool => _songs;

    Stream<int?> get getCurrentPlayingIndex => player.currentIndexStream;

    set seekProgressPosition(Duration seekedPosition) {
      player.seek(seekedPosition);
      notifyListeners();
    }
}