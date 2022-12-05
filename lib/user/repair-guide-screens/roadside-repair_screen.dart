import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:siklero/model/repair_guide/repair.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RoadsideRepairScreen extends StatefulWidget {
  const RoadsideRepairScreen({super.key});

  @override
  State<RoadsideRepairScreen> createState() => _RoadsideRepairScreenState();
}

class _RoadsideRepairScreenState extends State<RoadsideRepairScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: const Color(0xffed8f5b),
          title: const Text('Preparation', style: TextStyle(fontFamily: 'OpenSans', fontSize: 24),),
          centerTitle: true,
          elevation: 0,
      ),
      body: ListView(
        children: repairs.map(buildCard).toList(),
      )
    );
  }
  
  Widget buildCard(Repair repair) => Padding(
    padding: const EdgeInsets.all(10),

    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              repair.imagePath,
              fit: BoxFit.fitWidth,
            )
          ),
          ExpansionTile(
            title: Text(repair.title),
            subtitle: Text("Courtesy: " + repair.courtesy),
            children: [ListTile(title: Text(repair.description),), buildYoutubeVideo(repair.videoLink)],
          )
        ],
      ),
    ),
  );
  
  Widget buildYoutubeVideo(String videoLink) {
    String videoID;
    videoID = YoutubePlayer.convertUrlToId(videoLink)!;

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoID,
      flags: const YoutubePlayerFlags(
          autoPlay: false,
      ),
    );

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: const ProgressBarColors(
              playedColor: Colors.amber,
              handleColor: Colors.amber
            ),
          ),
          //FullScreenButton()
        ],
      ),
      builder: (context, player) {
        return Stack(
          children: <Widget>[
            player,
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed:() => launchUrlString(videoLink), 
                icon: Image.asset("asset/img/youtube-logo.png")
              ),
            ),
          ],
        );
      },

    );
  } 
}