import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_iframe_example/widgets/meta_data_section.dart';
import 'package:youtube_player_iframe_example/widgets/play_pause_button_bar.dart';
import 'package:youtube_player_iframe_example/widgets/player_state_section.dart';
import 'package:youtube_player_iframe_example/widgets/source_input_section.dart';
import 'package:youtube_player_iframe_example/widgets/volume_slider.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

///
class OldDemo extends StatefulWidget {
  @override
  _YoutubeAppDemoState createState() => _YoutubeAppDemoState();
}

class _YoutubeAppDemoState extends State<OldDemo> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'Twc3c_9Wg6o', // livestream example
      params: YoutubePlayerParams(
        playlist: [
          'Twc3c_9Wg6o',
          "MnrJzXM7a6o",
          "FTQbiNvZqaY",
          "iYKXdt0LRs8",
        ],
        //startAt: Duration(minutes: 1, seconds: 5),
        showControls: true,
        showFullscreenButton: true,
        desktopMode: false, // true for youtube design
        autoPlay: false,
        enableCaption: true,
        showVideoAnnotations: false,
        enableJavaScript: true,
        privacyEnhanced: true,
        playsInline: true, // iOS only - Auto fullscreen or not
      ),
    )..listen((value) {
        if (value.isReady && !value.hasPlayed) {
          _controller..hidePauseOverlay();
          //..play()
          Timer(Duration(seconds: 5), () {
            _controller.hideTopMenu();
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    const player = YoutubePlayerIFrame();
    return YoutubePlayerControllerProvider(
      // Passing controller to widgets below.
      controller: _controller,
      child: YoutubeValueBuilder(
        key: UniqueKey(),
        builder: (context, value) {
          if (value!.isReady && !value.hasPlayed) {
            Timer(Duration(seconds: 30), () {
              _controller.showTopMenu();
            });
          }
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              elevation: 0,
              brightness: Brightness.dark,
              title: const Text('Inline Demo'),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (kIsWeb && constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: player),
                      const SizedBox(
                        width: 500,
                        child: SingleChildScrollView(
                          child: Controls(),
                        ),
                      ),
                    ],
                  );
                }
                return ListView(
                  children: [
                    player,
                    const Controls(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.showTopMenu();
    super.dispose();
  }
}

///
class Controls extends StatelessWidget {
  ///
  const Controls();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _space,
          MetaDataSection(),
          _space,
          SourceInputSection(),
          _space,
          PlayPauseButtonBar(),
          _space,
          VolumeSlider(),
          _space,
          PlayerStateSection(),
        ],
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
