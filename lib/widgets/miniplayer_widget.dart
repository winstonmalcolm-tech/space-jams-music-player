import "package:audio_video_progress_bar/audio_video_progress_bar.dart";
import "package:flutter/material.dart";
import "package:miniplayer/miniplayer.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
import "package:space_jams_player/data/current_song_info.dart";
import "package:space_jams_player/data/player_controller.dart";
import "package:space_jams_player/routes/music_player_route.dart";


class MiniPlayerWidget extends StatefulWidget {
  const MiniPlayerWidget({super.key});

  @override
  State<MiniPlayerWidget> createState() => _MiniPlayerWidgetState();
}

class _MiniPlayerWidgetState extends State<MiniPlayerWidget> {
  final MiniplayerController _controller = MiniplayerController();

  @override 
  Widget build(BuildContext context) {
    return Consumer<CurrentSongInfo>(
            builder: (context, value, child) {
              return Offstage(
                offstage: value.getCurrentSongIndex == null,
                child: Miniplayer(
                  minHeight: 70, 
                  maxHeight: MediaQuery.of(context).size.height,
                  controller: _controller,
                  
                  builder: (height, percentage) {
              
                    if (value.getCurrentSongIndex == null) {
                      return const SizedBox.shrink();
                    } 
              
                    if (height <= 70 + 160.0) {
                      
                      return Container(
                        color: const Color(0xFF560628),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      height: 60,
                                      width: 50,
                                      child:  RiveAnimation.asset("assets/spining_cd.riv", fit: BoxFit.cover,)
                                    ),
                                    StreamBuilder<int?>(
                                      stream: context.watch<PlayerController>().getCurrentPlayingIndex,
                                      builder: (context, snapshot) {
                                        return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.8,
                                              child: Text(Provider.of<PlayerController>(context, listen: true).songPool[Provider.of<PlayerController>(context, listen: true).getPlaylistID]![snapshot.data ?? 0].displayNameWOExt,  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white), overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false,)
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width / 1.8,
                                              child: Text(context.watch<PlayerController>().songPool[Provider.of<PlayerController>(context,listen: true).getPlaylistID]![snapshot.data ?? 0].artist ?? "Unknown", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.grey), overflow: TextOverflow.ellipsis, maxLines:  1,)
                                            )
                                          ],
                                        );
                                      }
                                    ),
                                  ],
                                ),
              
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Provider.of<PlayerController>(context, listen: false).pauseHandler();
                                        setState(() {});
                                      }, 
                                      icon: (context.watch<PlayerController>().isPlaying) ? const Icon(Icons.pause, color: Colors.white) : const Icon(Icons.play_arrow, color: Colors.white)
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        Provider.of<PlayerController>(context, listen: false).stopAudio();
                                        Provider.of<CurrentSongInfo>(context, listen: false).setCurrentSongIndex = null;
                                        Provider.of<PlayerController>(context, listen: false).setPlaylistID = 0;
                                      }, 
                                      icon: const Icon(Icons.close, color: Colors.white,)
                                    ),
                                  ],
                                ),
                                
                                
                              ],
                            ),
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
                                      thumbRadius: 0.0,
                                      baseBarColor: Colors.white.withOpacity(0.24),
                                      thumbColor: Colors.white,
                                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                                      barHeight: 3,
                                      timeLabelLocation: TimeLabelLocation.none,
                                    );
                                  }
                                );
                              },  
                            ),
                          ],
                        ),
                      );
                    }
              
                    return const MusicPlayerRoute();
                  },
                ),
              );
            }
          );
  }
}