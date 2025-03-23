
import 'package:shared_preferences/shared_preferences.dart';

class HighScoreRepository{
  static const String flappyKey = "flappy_high_score";

  Future<String> getHighScore() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(flappyKey) ?? "00:00";
  }

  Future<void> setHighScore(String score) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(flappyKey, score);
  }

}