
import 'package:flame_audio/flame_audio.dart';

class AudioManager{
  static int isBgmPlaying = 0;
  static final Map<String,AudioPlayer> _audioCache = {};

  static Future<void> playAudio(String audioPath,{bool isBg = false, double volume = 1.0})async{
    if(isBg){
      isBgmPlaying = 1;
      await FlameAudio.bgm.play(audioPath, volume: volume);
    }else{
      await FlameAudio.play(audioPath, volume: volume);
    }
  }

  static stopAudio(String audioPath,{bool isBg = false})async{
    if(isBg){
      isBgmPlaying = 2;
      await FlameAudio.bgm.stop();
    }else{
      await _audioCache[audioPath]?.stop();
    }
  }

  static Future<void> loadAudio()async{
    await FlameAudio.audioCache.loadAll([
      "trap_basic_sound.mp3",
      "zombie.mp3",
      "zombie1.mp3",
      "trap_hit.mp3",
      "home_page_song.mp3",
    ]);
  }
}