import 'package:autisma/children/game_list.dart';
import 'package:autisma/games/Game_module/Game_data.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class Play extends StatefulWidget {
  const Play({Key? key}) : super(key: key);

  @override
  _PlayState createState() => _PlayState();
}

class _PlayState extends State<Play> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play Games"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ChangeNotifierProvider(
                create: (_) => GameData(), child: Games()),
          ),
        ],
      ),
    );
  }
}
