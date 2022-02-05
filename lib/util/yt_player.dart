import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YtPlayer extends StatefulWidget {
  YtPlayer({required this.url});

  final url;

  @override
  State<YtPlayer> createState() => YtPlayerState();
}

class YtPlayerState extends State<YtPlayer>{
  late YoutubePlayerController ytController;

  @override
  void initState() {
    print(widget.url);
    super.initState();
    ytController = YoutubePlayerController(
      initialVideoId: widget.url,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false,
        privacyEnhanced: true,
        useHybridComposition: true,
      ),
    );
    ytController.onEnterFullscreen = () {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    };
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerIFrame(
      controller: ytController,
      aspectRatio: 16 / 9,
    );
  }


}
