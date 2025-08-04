import 'package:flutter/material.dart';

class Emojis {
  List<Icon> emojis = [
    Icon(Icons.sentiment_very_satisfied, color: Colors.orange),
    Icon(Icons.sentiment_satisfied, color: Colors.yellow),
    Icon(Icons.sentiment_neutral, color: Colors.grey),
    Icon(Icons.sentiment_dissatisfied, color: Colors.blue),
    Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
    Icon(Icons.emoji_emotions, color: Colors.amber),
    Icon(Icons.emoji_people, color: Colors.green),
    Icon(Icons.face, color: Colors.purple),
    Icon(Icons.mood, color: Colors.teal),
    Icon(Icons.mood_bad, color: Colors.brown),
    Icon(Icons.thumb_up, color: Colors.blueAccent),
    Icon(Icons.thumb_down, color: Colors.redAccent),
    Icon(Icons.star, color: Colors.yellow),
    Icon(Icons.favorite, color: Colors.pink),
    Icon(Icons.cake, color: Colors.deepPurple),
    Icon(Icons.sunny, color: Colors.amber),
    Icon(Icons.nightlight, color: Colors.indigo),
    Icon(Icons.celebration, color: Colors.pink),
    Icon(Icons.school, color: Colors.blue),
    Icon(Icons.sports_soccer, color: Colors.green),
    Icon(Icons.music_note, color: Colors.deepPurple),
    Icon(Icons.local_pizza, color: Colors.orange),
    Icon(Icons.pets, color: Colors.brown),
    Icon(Icons.directions_car, color: Colors.blueGrey),
    Icon(Icons.flight, color: Colors.teal),
    Icon(Icons.icecream, color: Colors.purple),
    Icon(Icons.rocket_launch, color: Colors.redAccent),
    Icon(Icons.book, color: Colors.deepOrange),
    Icon(Icons.palette, color: Colors.cyan),
    Icon(Icons.camera_alt, color: Colors.black),
  ];
  List<Icon> get personalIcons => emojis;
}
