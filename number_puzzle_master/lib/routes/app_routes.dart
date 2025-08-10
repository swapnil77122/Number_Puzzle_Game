import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/level_complete/level_complete.dart';
import '../presentation/game_over/game_over.dart';
import '../presentation/game_screen/game_screen.dart';
import '../presentation/game_tutorial/game_tutorial.dart';
import '../presentation/level_selection/level_selection.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String levelComplete = '/level-complete';
  static const String gameOver = '/game-over';
  static const String game = '/game-screen';
  static const String gameTutorial = '/game-tutorial';
  static const String levelSelection = '/level-selection';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    levelComplete: (context) => const LevelComplete(),
    gameOver: (context) => const GameOver(),
    game: (context) => const GameScreen(),
    gameTutorial: (context) => const GameTutorial(),
    levelSelection: (context) => const LevelSelection(),
    // TODO: Add your other routes here
  };
}
