import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lotus/colors.dart';
import 'package:lotus/entity/podcast_entity.dart';

class PodcastPage extends StatefulWidget {
  final Podcast podcast;
  const PodcastPage({Key? key, required this.podcast}): super(key: key);

  @override
  State<PodcastPage> createState() => _PodcastPageState();
}

class _PodcastPageState extends State<PodcastPage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool isLooping = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState(){
    super.initState();
    audioPlayer.setUrl(widget.podcast.url).then((_) {
      audioPlayer.durationStream.listen((d) {
        setState(() {
          duration = d ?? Duration.zero;
        });
      });
      audioPlayer.positionStream.listen((p) {
        setState(() {
          position = p;
        });
      });
      audioPlayer.playerStateStream.listen((state) {
        setState(() {
          isPlaying = state.playing;
        });
        if (state.processingState == ProcessingState.completed) {
          audioPlayer.seek(Duration.zero);
          audioPlayer.pause();
          setState(() {
            isPlaying = false;
          });
        }
      });
    });
  }

    @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
    }

    Future<void> playPause() async{
    if(isPlaying){
      await audioPlayer.pause();
    }else{
      await audioPlayer.play();
    }
    setState(() {
      isPlaying= !isPlaying;
    });
    }

    void rewind(){
    final newPosition = position- const Duration(seconds: 10);
    audioPlayer.seek(newPosition >= Duration.zero ? newPosition:Duration.zero);
    }

    void forward(){
    final newPosition= position+ const Duration(seconds: 10);
    audioPlayer.seek(newPosition <= duration ? newPosition: duration);
    }

    void toggleLoop(){
    isLooping = !isLooping;
    audioPlayer.setLoopMode(isLooping ? LoopMode.one: LoopMode.off);
    setState(() {});
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPink,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.network(
                widget.podcast.image ?? '',
                width: 300,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context,error,stackTrace){
                  return Image.asset("resimler/lotus_resim.png", width: 300,height: 300, fit: BoxFit.cover);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(widget.podcast.title,style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,),
                )
              ],
            ),
          ),
          Slider(
            activeColor: mainPink,
            inactiveColor: Colors.grey,
            min: 0.0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            onChanged: (double value) {
              setState(() {
                audioPlayer.seek(Duration(seconds: value.toInt()));
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.replay_10),
                iconSize: 36,
                onPressed: rewind,
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                iconSize: 36,
                onPressed: playPause,
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                iconSize: 36,
                onPressed: forward,
              ),
              IconButton(
                icon: Icon(isLooping ? Icons.loop : Icons.loop_outlined),
                iconSize: 36,
                color: isLooping ? mainPink : black,
                onPressed: toggleLoop,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
