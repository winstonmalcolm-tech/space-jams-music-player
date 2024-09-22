import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:space_jams_player/data/current_song_info.dart';
import 'package:space_jams_player/data/player_controller.dart';
import 'package:space_jams_player/routes/navigation_route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

    await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlayerController()),
        ChangeNotifierProvider(create: (_) => CurrentSongInfo()) 
      ],
      child: const MainApp(),
    )
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        colorSchemeSeed: Colors.pink
      ),
      home: const NavigationRoute()
    );
  }
}
