import "package:audio_video_progress_bar/audio_video_progress_bar.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
import "package:space_jams_player/data/player_controller.dart";

class MusicPlayerRoute extends StatefulWidget {

  const MusicPlayerRoute({super.key});

  @override
  State<MusicPlayerRoute> createState() => _MusicPlayerRouteState();
}


class _MusicPlayerRouteState extends State<MusicPlayerRoute> {

  bool isFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF390a3b),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8,8,8,20),
        child: Stack(
          children: [
            const RiveAnimation.asset("assets/music_player_bkgr.riv"),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Icon(Icons.drag_handle_rounded, color: Colors.white,)
                    ),
              
                  Align(
                    alignment: Alignment.center,
                    child: StreamBuilder<int?>(
                      stream: context.watch<PlayerController>().getCurrentPlayingIndex,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20,),
                            Text(context.watch<PlayerController>().songPool[context.watch<PlayerController>().playListID]![snapshot.data ?? 0].displayNameWOExt, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20),),
                            Text(context.watch<PlayerController>().songPool[context.watch<PlayerController>().playListID]![snapshot.data ?? 0].artist ?? "Unknown", style: const TextStyle(color: Colors.grey, fontSize: 18, fontStyle: FontStyle.italic),)
                          ],
                        );
                      }
                    ),
                  ),
                ],
              )
            ),
        
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder<int?>(
                    stream: context.watch<PlayerController>().getCurrentPlayingIndex,
                    builder: (context, result) {
                      return StreamBuilder<Duration>(
                        stream: context.watch<PlayerController>().playingPosition,
                        builder: (context, snapshot) {
    
                          return ProgressBar(
                            progress: snapshot.data ?? const Duration(milliseconds: 0), 
                            total: Duration(milliseconds: context.watch<PlayerController>().songPool[context.watch<PlayerController>().getPlaylistID]![result.data ?? 0].duration!),
                            progressBarColor: Colors.pink,
                            thumbRadius: 5.0,
                            baseBarColor: Colors.white.withOpacity(0.24),
                            thumbColor: Colors.white,
                            timeLabelTextStyle: const TextStyle(color: Colors.white),
                            onSeek: (value) async {
                              Provider.of<PlayerController>(context, listen: false).seekProgressPosition = value;
                            }
                          );
                        }
                      );
                    },  
                  ),
    
                  const SizedBox(height: 20,),
                  StreamBuilder<int?>(
                    stream: context.watch<PlayerController>().getCurrentPlayingIndex,
                    builder: (context, snapshot) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              Provider.of<PlayerController>(context, listen: false).previousSong();
                            }, 
                            icon: Icon(Icons.skip_previous, color: (context.watch<PlayerController>().hasPrevious) ? Colors.pink : null, size: 40,)
                          ),
                      
                          IconButton(
                            onPressed: () async {
                              Provider.of<PlayerController>(context, listen: false).pauseHandler();
                              setState(() {});
                            }, 
                            icon: (context.watch<PlayerController>().isPlaying && !isFinished) ? const Icon(Icons.pause, color: Colors.pink, size: 40,) : const Icon(Icons.play_arrow, color: Colors.pink, size: 40,)
                          ),
                      
                          IconButton(
                            onPressed: (){
                               Provider.of<PlayerController>(context, listen: false).nextSong();
                            }, 
                            icon: const Icon(Icons.skip_next,color: Colors.pink, size: 40,)
                          )
                        ],
                      );
                    }
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}