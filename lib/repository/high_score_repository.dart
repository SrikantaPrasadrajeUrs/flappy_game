
import 'package:shared_preferences/shared_preferences.dart';

class HighScoreRepository{
  static const String flappyKey = "flappy_high_score";

  Future<int> getHighScore() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(flappyKey) ?? 0;
  }

  Future<void> setHighScore(int score) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(flappyKey, score);
  }

}