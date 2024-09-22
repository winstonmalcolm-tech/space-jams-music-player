import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:space_jams_player/data/player_controller.dart';
import 'package:space_jams_player/routes/playlist_songs_route.dart';
import 'package:space_jams_player/styles/text_styles.dart';
import 'package:toastification/toastification.dart';

class PlaylistRoute extends StatefulWidget {
  const PlaylistRoute({super.key});

  @override
  State<PlaylistRoute> createState() => _PlaylistRouteState();
}

class _PlaylistRouteState extends State<PlaylistRoute> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController playlistNameController = TextEditingController();
  
  final ScrollController scrollController = FixedExtentScrollController();
  static const double _itemHeight = 100;

  void showPrompt() {
    showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (context) {
        return AlertDialog(
          
          title: const Text("Playlist name"),
          actions: [
            TextButton(
              onPressed: () { 
                playlistNameController.text = "";     
                Navigator.of(context).pop();
              }, 
              child: const Text("Cancel")
            ),

            TextButton(
              onPressed: () async {

                if (!_formKey.currentState!.validate()) {
                  return;
                }
                
                await Provider.of<PlayerController>(context, listen: false).createPlaylist(playlistNameController.text);
                playlistNameController.text = "";
                Navigator.of(context).pop();
              }, 
              child: const Text("Save")
            ),    
          ], 
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                    controller: playlistNameController,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter a name";
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter playlist name",
                      border: UnderlineInputBorder()
                    ),
                )
              ],
            )
          )
        ); 
      },
    );
  }

  void showConfirmationMessage(int playlistID) {
    
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
              onPressed: () async{
                await Provider.of<PlayerController>(context, listen: false).deletePlaylist(playlistID);
                
                toastification.show(
                  context: context, 
                  title: const Text('Deleted'),
                  type: ToastificationType.error,
                  style: ToastificationStyle.fillColored,
                  autoCloseDuration: const Duration(seconds: 5),
                );     
                Navigator.of(context).pop();          
              }, 
              child: const Text("Remove", style: TextStyle(color: Color.fromARGB(255, 224, 85, 75), letterSpacing: 1.5),)
            )
          ],
        );
      },
      
    );
  }
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151618),
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/cosmos.riv", fit: BoxFit.fill,),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        showPrompt();
                      }, 
                      icon: const Icon(Icons.add, size: 30, color: Color(0xFFfdbd3e),)
                    )
                  ],
                ),
                
                FutureBuilder<List<PlaylistModel>>(
                  future: Provider.of<PlayerController>(context, listen: true).getPlaylists(),
                  builder: (context, snapshot) {
                    
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        
                        return const Expanded(
                          child: Center(
                            child: Text("No Playlist", style: TextStyle(color: Color(0xFFfdbd3e), fontSize: 23),),
                          ),
                        );
                      }
                
                      return Expanded(
                        child: ClickableListWheelScrollView(
                          scrollController: scrollController,  
                          itemHeight: _itemHeight, 
                          itemCount: snapshot.data!.length,
                          child: ListWheelScrollView.useDelegate(
                            controller: scrollController,
                            physics: const FixedExtentScrollPhysics(),
                            itemExtent: _itemHeight, 
                            overAndUnderCenterOpacity: 0.5,
                            perspective: 0.002,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: snapshot.data!.length,
                              builder: (context, index) {
                                PlaylistModel playlist = snapshot.data![index];
                                  return ListTile(
                                    title: Text(playlist.playlist, style: playlistTitleStyle,),
                                    subtitle: Text("${playlist.numOfSongs} songs", style: tileSubtitleStyle,),
                                    trailing: const Icon(Icons.arrow_circle_right, color: Colors.white,),
                                    onLongPress: () {

                                      if (Provider.of<PlayerController>(context, listen: false).getPlaylistID == playlist.id) {
                                        toastification.show(
                                          context: context,
                                          type: ToastificationType.info,
                                          title: const Text('Please close mini-player before removing song.'),
                                          style: ToastificationStyle.fillColored,
                                          autoCloseDuration: const Duration(seconds: 5),
                                        );
                                        return;
                                      }
                                      showConfirmationMessage(playlist.id); 
                                    },
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaylistSongsRoute(playlistData: playlist,))).then((value) => setState(() {}));;
                                    },
                                  );
                                },    
                            )
                          ),
                        )
                      );
                    } else {
                      return const SizedBox();
                    }
                  }, 
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}