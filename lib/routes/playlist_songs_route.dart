import "package:clickable_list_wheel_view/clickable_list_wheel_widget.dart";
import "package:flutter/material.dart";
import "package:on_audio_query/on_audio_query.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
import "package:space_jams_player/data/current_song_info.dart";
import "package:space_jams_player/data/player_controller.dart";
import "package:space_jams_player/styles/text_styles.dart";
import "package:flutter/src/painting/gradient.dart" as gr;
import "package:space_jams_player/widgets/miniplayer_widget.dart";
import "package:toastification/toastification.dart";

class PlaylistSongsRoute extends StatefulWidget {
  final PlaylistModel playlistData;

  const PlaylistSongsRoute({super.key, required this.playlistData});

  @override
  State<PlaylistSongsRoute> createState() => _PlaylistSongsRouteState();
}

class _PlaylistSongsRouteState extends State<PlaylistSongsRoute> {
  
  List<SongModel> playlistSongs = [];
  List<SongModel> allSongs = [];
  List<SongModel> playlistSongsTemp = [];

  final ScrollController scrollController = FixedExtentScrollController();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((t) async {
      playlistSongs = await Provider.of<PlayerController>(context,listen: false).getPlaylistSongs(widget.playlistData.id);
      allSongs = await Provider.of<PlayerController>(context,listen: false).getAudios();
      
      setState(() {});
    });

    super.initState();
  }

  bool isSongInPlaylist(List<SongModel> playlist, String songTitle) {

    for (SongModel song in playlist) {
      if (song.displayNameWOExt == songTitle) {
        return true;
      }
    }
    
    return false;
  }

  void addSongTolist(SongModel song) {
    playlistSongs.add(song);
    setState(() {});
  }

  void removeSongFromList(int index) {
    playlistSongs.removeAt(index);
    setState(() {
      
    });
  }

  void _showConfirmationMessage(int index, SongModel song) {
    
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("Confirm...", style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(94, 255, 193, 7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.amber, width: 2)
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              }, 
              child: const Text("Cancel", style: TextStyle(color: Colors.white),)
            ),
              
            TextButton(
              onPressed: () async {

                  removeSongFromList(index); 
                  await Provider.of<PlayerController>(context, listen: false).deleteSongFromPlaylist(widget.playlistData.id, song.id, playlistSongs);
                  
                  toastification.show(
                    context: context,
                    type: ToastificationType.warning,
                    title: const Text('Removed from the playlist'),
                    style: ToastificationStyle.fillColored,
                    autoCloseDuration: const Duration(seconds: 5),
                  );
                  

                  var j = await Provider.of<PlayerController>(context,listen: false).getPlaylistSongs(widget.playlistData.id);
                  print("PLAYLIST: ${playlistSongs.length}");
                  print("PLAYLIST2: ${j.length}");
                  Navigator.of(context).pop();
                  
              }, 
              child: const Text("Remove", style: TextStyle(color: Color.fromARGB(255, 224, 85, 75), letterSpacing: 1.5),)
            )
          ],
        );
      },
      
    );
  }

  void showBottomModal(BuildContext context) {

      showModalBottomSheet(
        context: context, 
        backgroundColor: Colors.transparent,
        builder: (context) {
          List<SongModel> remainingSongs = allSongs.where((song) => !isSongInPlaylist(playlistSongsTemp, song.displayNameWOExt)).toList();
          return Container(
                height: 400,
                decoration: const BoxDecoration(
                  gradient: gr.LinearGradient(colors: [Color.fromARGB(255, 151, 113, 37), Color(0xFF560628), ]),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      children: [
                        const Icon(Icons.drag_handle_outlined, color: Colors.white,),
                                  
                        const SizedBox(height: 10,), 
                                  
                        Expanded(
                          child: ListView.builder(
                                  itemCount: remainingSongs.length,
                                  itemBuilder: (context, index) {
                                    
                                    return ListTile(
                                      key: ValueKey(remainingSongs[index].displayNameWOExt),
                                      title: Text(remainingSongs[index].displayNameWOExt, style: tileTitleStyle,),
                                      onTap: () async {
                                        await Provider.of<PlayerController>(context, listen: false).addSongToPlaylist(widget.playlistData.id, remainingSongs[index].id);

                                        addSongTolist(remainingSongs[index]);
                                        Provider.of<PlayerController>(context, listen:false).updatePlaylist(widget.playlistData.id, playlistSongs);
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.success,
                                          title: const Text('Added'),
                                          style: ToastificationStyle.fillColored,
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );
                                          
                                        remainingSongs.removeAt(index);
                                        setState(() { });
                                      }
                                    );
                                  },
                                )
                        ),
                      ],
                    );
                  },
                  
                ),
              );
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/cosmos.riv", fit: BoxFit.fill,),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.playlistData.playlist, style: playlistTitleStyle),
                      TextButton(
                        onPressed: () {
                            showBottomModal(context);
                        }, 
                        child: const Text("Add Song", style: TextStyle(color: Color(0xFFfdbd3e)),)
                      )
                    ],
                  ),
                ),

                (playlistSongs.isEmpty) ? const Expanded(child: Center(child: Text("No songs",style: TextStyle(color: Color(0xFFfdbd3e), fontSize: 30) ),)) : Expanded(
                  child: ClickableListWheelScrollView(
                    scrollController: scrollController,  
                    itemHeight: 100, 
                    itemCount: playlistSongs.length,
                    child: ListWheelScrollView.useDelegate(
                      itemExtent: 100, 
                      overAndUnderCenterOpacity: 0.5,
                      perspective: 0.002,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: playlistSongs.length,
                        builder: (context, index) {
                          playlistSongsTemp = playlistSongs;
                    
                          SongModel song = playlistSongs[index];
                          return ListTile(
                                key: ValueKey(song.displayNameWOExt),
                                title: Text(song.displayNameWOExt, style: playlistTitleStyle,),
                                subtitle: Text(song.artist ?? "Unknown", style: tileSubtitleStyle,),
                                onLongPress: () async {
                                  
                                  if ((Provider.of<PlayerController>(context, listen: false).getPlaylistID == widget.playlistData.id && Provider.of<PlayerController>(context, listen: false).isPlaying) || Provider.of<CurrentSongInfo>(context, listen: false).getCurrentSongIndex == index) {
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.info,
                                      title: const Text('Please close mini-player before removing song.'),
                                      style: ToastificationStyle.fillColored,
                                      autoCloseDuration: const Duration(seconds: 5),
                                    );
                                    return;
                                  } 
                                  _showConfirmationMessage(index, song);
                                },
                                onTap: () {
                                  Provider.of<PlayerController>(context, listen: false).setPlaylistID = widget.playlistData.id;
                                  Provider.of<CurrentSongInfo>(context, listen: false).setIsSameSong = index;
                                  Provider.of<CurrentSongInfo>(context, listen: false).setCurrentSong = playlistSongs[index];
                                  Provider.of<CurrentSongInfo>(context, listen: false).setCurrentSongIndex = index;
                    
                                  
                                  if (!Provider.of<CurrentSongInfo>(context, listen: false).isSameSong) {
                                    Provider.of<PlayerController>(context, listen: false).playSong(index, widget.playlistData.id);
                                    Provider.of<PlayerController>(context, listen: false).startSong();
                                  }
                                },                                   
                              );
                        },
                      )
                    ),
                  ),
                )
      
              ],
            ),
          ),

          const MiniPlayerWidget()
        ],
      ),
    );
  }
}