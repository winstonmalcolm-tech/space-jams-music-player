import "package:flutter/material.dart";
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:space_jams_player/data/current_song_info.dart';
import 'package:space_jams_player/routes/about_route.dart';
import 'package:space_jams_player/routes/home_route.dart';
import 'package:space_jams_player/routes/playlist_route.dart';
import 'package:space_jams_player/widgets/miniplayer_widget.dart';

class NavigationRoute extends StatefulWidget {
  const NavigationRoute({super.key});

  @override
  State<NavigationRoute> createState() => _NavigationRouteState();
}

class _NavigationRouteState extends State<NavigationRoute> {

  List<Widget> routes = const [
    HomeRoute(), 
    PlaylistRoute(),
    AboutRoute()
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: (Provider.of<CurrentSongInfo>(context, listen: true).getCurrentSongIndex == null) ? 0 : 70.0),
            child: routes[_selectedIndex],
          ),
          
          const MiniPlayerWidget()
        ]
      ),

      bottomNavigationBar: GNav(
        color: Colors.grey,
        style: GnavStyle.google,
        textStyle: const TextStyle(letterSpacing: 1.2,fontSize: 16, color: Color(0xFFfdbd3e)),
        iconSize: 25,
        backgroundColor: const Color(0xFF560628),
        rippleColor: Colors.grey[800]!,
        hoverColor: Colors.grey[700]!,
        curve: Curves.easeInOut,
        haptic: true,
        tabBorderRadius: 15,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        activeColor: const Color(0xFFfdbd3e),
        selectedIndex: _selectedIndex,
        duration: const Duration(milliseconds: 1000),
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        gap: 3,
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.list,
            text: "Playlists",
          ),
          GButton(
            icon: Icons.info,
            text: "About"
          )
        ]),
    );
  }
}