import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:rive/rive.dart";
import "package:space_jams_player/styles/text_styles.dart";
import 'package:url_launcher/url_launcher.dart';

class AboutRoute extends StatelessWidget {
  const AboutRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xFF151618),
      body: Stack(
        children: [
          const RiveAnimation.asset("assets/cosmos.riv", fit: BoxFit.fill),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: ListView(
                
                children: [
                  const Text("About", textAlign: TextAlign.start,style: TextStyle(fontSize: 25, color: Colors.white),),
                  const SizedBox(height: 20,),
                  
                  Text("A free fun and playful media player. Play audios from your device in the app.", style: aboutTextStyle),

                  const SizedBox(height: 50,),
                  Text("How to Use: ", style: aboutTextTitleStyle,),
                  const SizedBox(height: 20,),

                  Text("- Click the + icon on the playlist screen to create a playlist.", style: aboutTextStyle,),
                  const SizedBox(height: 20,),

                  Text("- Press and hold on a playlist to delete.", style: aboutTextStyle,),
                  const SizedBox(height: 20,),

                  Text("- Press and hold on a song in playlist to delete.", style: aboutTextStyle,),
                  
                  const SizedBox(height: 50,),
                  Text("Attributions: ", style: aboutTextTitleStyle,),
                  const SizedBox(height: 20,),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Animation by JcToon via ",
                          style: aboutTextStyle
                        ), 
                        TextSpan(
                          text: "https://rive.app/community/files/194-352-space-coffee/",
                          style: aboutTextLinkStyle,
                          recognizer: TapGestureRecognizer()..onTap = ()async {
                            await launchUrl(Uri.parse("https://rive.app/community/files/194-352-space-coffee/"));
                          }
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 20,),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Animation by Tani via ",
                          style: aboutTextStyle
                        ), 
                        TextSpan(
                          text: "https://rive.app/community/files/1809-3568-cosmos/",
                          style: aboutTextLinkStyle,
                          recognizer: TapGestureRecognizer()..onTap = ()async {
                            await launchUrl(Uri.parse("https://rive.app/community/files/1809-3568-cosmos/"));
                          }
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 20,),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Animation by Godino via ",
                          style: aboutTextStyle
                        ), 
                        TextSpan(
                          text: "https://rive.app/community/files/166-259-disco-de-carga/",
                          style: aboutTextLinkStyle,
                          recognizer: TapGestureRecognizer()..onTap = ()async {
                            await launchUrl(Uri.parse("https://rive.app/community/files/166-259-disco-de-carga/"));
                          }
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 20,),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Title design by textstudio via ",
                          style: aboutTextStyle
                        ), 
                        TextSpan(
                          text: "https://www.textstudio.com/",
                          style: aboutTextLinkStyle,
                          recognizer: TapGestureRecognizer()..onTap = ()async {
                            await launchUrl(Uri.parse("https://www.textstudio.com/"));
                          }
                        )
                      ]
                    )
                  ),
                  const SizedBox(height: 20,),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Animation by JcToon via ",
                          style: aboutTextStyle
                        ), 
                        TextSpan(
                          text: "https://rive.app/community/files/3470-7902-mixing-animations/",
                          style: aboutTextLinkStyle,
                          recognizer: TapGestureRecognizer()..onTap = ()async {
                            await launchUrl(Uri.parse("https://rive.app/community/files/3470-7902-mixing-animations/"));
                          }
                        )
                      ]
                    )
                  ),



                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}