import 'dart:ui';

import 'package:Vairoo/src/features/practice/domain/entities/practice_game.dart';

const practiceGames = [
  PracticeGame(
    title: 'Змейка',
    tag: 'Отвлечение',
    duration: Duration(seconds: 30),
    storeUrl:
        'https://apps.apple.com/us/app/classic-snake-game-1997-retro/id1465321784',
    emoji: '🐍',
    color: Color(0xFF5CC6C1),
  ),
  PracticeGame(
    title: 'Тетрис',
    tag: 'Антистресс',
    duration: Duration(seconds: 30),
    storeUrl: 'https://apps.apple.com/us/app/tetris/id1491074310',
    emoji: '🧱',
    color: Color(0xFF7A8FE3),
  ),
  PracticeGame(
    title: 'Шарики',
    tag: 'Антистресс',
    duration: Duration(seconds: 30),
    storeUrl:
        'https://apps.apple.com/us/app/bubble-shooter-pop-puzzle/id1483491017',
    emoji: '🔵',
    color: Color(0xFFFFB74D),
  ),
];
