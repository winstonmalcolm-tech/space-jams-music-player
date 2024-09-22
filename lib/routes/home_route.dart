import "package:device_info_plus/device_info_plus.dart";
import "package:flutter/material.dart";
import "package:on_audio_query/on_audio_query.dart";
import "package:permission_handler/permission_handler.dart";
import "package:provider/provider.dart";
import "package:rive/rive.dart";
import "package:space_jams_player/data/current_song_info.dart";
import "package:space_jams_player/data/player_controller.dart";
import "package:space_jams_player/styles/text_styles.dart";

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  List<SongModel> songs = [];
  List<SongModel> searchedSongs = [];
  bool shouldShowSearchBar = false;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission().then((value) {
         WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
          songs = await Provider.of<PlayerController>(context, listen: false).getAudios();
          searchedSongs = songs;
          setState(() {});
        });
    },); 
  }

  Future<void> requestPermission() async {

    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

    if (build.version.sdkInt >= 33) {
      
      PermissionStatus status = await Permission.audio.request();

      if (status.isDenied) {
        await openAppSettings();
      } else if(status.isPermanentlyDenied) {
        await openAppSettings();
      }

    } else if (await Permission.storage.isDenied || await Permission.storage.shouldShowRequestRationale) {
      await Permission.storage.request();

    } else if (await Permission.storage.isPermanentlyDenied) {
      await openAppSettings();
    } 
  } 

  int getSongindexFromMainList(String songName) {
    int index = 0;

    for (int i=0; i<songs.length; i++) {
      if (songs[i].displayNameWOExt == songName) {
        index = i;
      }
    }

    return index;

  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF151618),
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/space_coffee.riv", fit: BoxFit.fill,),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: (shouldShowSearchBar) ? searchBar() : header() 
                ),
                const SizedBox(height: 10,),

                Expanded(
                  child: ListView.builder(
                          itemCount: searchedSongs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(searchedSongs[index].displayNameWOExt, style: tileTitleStyle,),
                              subtitle: Text("${searchedSongs[index].artist}", style: tileSubtitleStyle ),
                              leading: const Icon(Icons.music_note, color: Color(0xFFfdbd3e), size: 40,),
                              onTap: () {
                                int mainIndex = getSongindexFromMainList(searchedSongs[index].displayNameWOExt);


                                Provider.of<PlayerController>(context, listen: false).setPlaylistID = 0;
                                        
                                Provider.of<CurrentSongInfo>(context, listen: false).setIsSameSong = mainIndex;
                                Provider.of<CurrentSongInfo>(context, listen: false).setCurrentSong = songs[mainIndex];
                                Provider.of<CurrentSongInfo>(context, listen: false).setCurrentSongIndex = mainIndex;
                                        
                                if (!Provider.of<CurrentSongInfo>(context, listen: false).isSameSong) {
                                    Provider.of<PlayerController>(context, listen: false).playSong(mainIndex, 0);
                                    Provider.of<PlayerController>(context, listen: false).startSong();
                                }
                              },
                            );
                          },
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          if (value.isEmpty) {
            searchedSongs = songs;
          } else {
            searchedSongs = songs.where((song) => song.displayNameWOExt.toLowerCase().contains(value.toLowerCase())).toList();
          }

          setState(() {
            
          });
          
        },
        style: const TextStyle(color: Color.fromARGB(255, 202, 202, 202)),
        decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 189, 189, 189), width: 3),

          ),
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                searchController.text = "";
                searchedSongs = songs;
                shouldShowSearchBar = !shouldShowSearchBar;
              });
            }, 
            icon: const Icon(Icons.close, color: Colors.white,)
          ),
          hintText: "Search...",
        ),
      ),
    );
  }

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset("assets/space_jams_update.png", width: MediaQuery.of(context).size.width / 1.8,),

        IconButton(
          onPressed: () {
            setState(() {
               setState(() {
                shouldShowSearchBar = !shouldShowSearchBar;
              });
            });
          }, 
          icon: const Icon(Icons.search, color: Colors.white, size: 25,)
        )
      ],
    );
  }
}