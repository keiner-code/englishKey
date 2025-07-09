import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:flutter/material.dart';

class StartPriority {
  static List<Widget> amountPriority(String priority) {
    late List<Widget> amountStart = [];
    if (priority == Priority.baja.name) {
      amountStart.add(Icon(Icons.star, color: Colors.yellow[200]));
      return amountStart;
    }
    if (priority == Priority.media.name) {
      amountStart.add(Icon(Icons.star, color: Colors.yellow[400]));
      amountStart.add(Icon(Icons.star, color: Colors.yellow[400]));
      return amountStart;
    }

    amountStart.add(Icon(Icons.star, color: Colors.yellow[600]));
    amountStart.add(Icon(Icons.star, color: Colors.yellow[600]));
    amountStart.add(Icon(Icons.star, color: Colors.yellow[600]));
    return amountStart;
  }
}
