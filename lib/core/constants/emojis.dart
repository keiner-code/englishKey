import 'package:flutter/material.dart';

class Emojis {
  List<Map<String, Icon>> emojis = [
    {
      'sentiment_very_satisfied': Icon(
        Icons.sentiment_very_satisfied,
        color: Colors.orange,
      ),
    },
    {
      'sentiment_satisfied': Icon(
        Icons.sentiment_satisfied,
        color: Colors.yellow,
      ),
    },
    {'sentiment_neutral': Icon(Icons.sentiment_neutral, color: Colors.grey)},
    {
      'sentiment_dissatisfied': Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.blue,
      ),
    },
    {
      'sentiment_very_dissatisfied': Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
      ),
    },
    {'emoji_emotions': Icon(Icons.emoji_emotions, color: Colors.amber)},
    {'emoji_people': Icon(Icons.emoji_people, color: Colors.green)},
    {'face': Icon(Icons.face, color: Colors.purple)},
    {'mood': Icon(Icons.mood, color: Colors.teal)},
    {'mood_bad': Icon(Icons.mood_bad, color: Colors.brown)},
    {'thumb_up': Icon(Icons.thumb_up, color: Colors.blueAccent)},
    {'thumb_down': Icon(Icons.thumb_down, color: Colors.redAccent)},
    {'star': Icon(Icons.star, color: Colors.yellow)},
    {'favorite': Icon(Icons.favorite, color: Colors.pink)},
    {'cake': Icon(Icons.cake, color: Colors.deepPurple)},
    {'sunny': Icon(Icons.sunny, color: Colors.amber)},
    {'nightlight': Icon(Icons.nightlight, color: Colors.indigo)},
    {'celebration': Icon(Icons.celebration, color: Colors.pink)},
    {'school': Icon(Icons.school, color: Colors.blue)},
    {'sports_soccer': Icon(Icons.sports_soccer, color: Colors.green)},
    {'music_note': Icon(Icons.music_note, color: Colors.deepPurple)},
    {'local_pizza': Icon(Icons.local_pizza, color: Colors.orange)},
    {'pets': Icon(Icons.pets, color: Colors.brown)},
    {'directions_car': Icon(Icons.directions_car, color: Colors.blueGrey)},
    {'flight': Icon(Icons.flight, color: Colors.teal)},
    {'icecream': Icon(Icons.icecream, color: Colors.purple)},
    {'rocket_launch': Icon(Icons.rocket_launch, color: Colors.redAccent)},
    {'book': Icon(Icons.book, color: Colors.deepOrange)},
    {'palette': Icon(Icons.palette, color: Colors.cyan)},
    {'camera_alt': Icon(Icons.camera_alt, color: Colors.black)},
  ];

  List<Map<String, Icon>> get personalIcons => emojis;
}
