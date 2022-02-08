import 'package:provider/provider.dart';
import 'package:autisma/games/Game_module/Game_data.dart';
import 'package:flutter/material.dart';
import 'game_tile.dart';

class Games extends StatefulWidget {
  const Games({Key? key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Games> {
  late GameData gamedata;
  @override
  Widget build(BuildContext context) {
    return Consumer<GameData>(builder: (context, gamedata, index) {
      return ListView(
        children: [
          Card(
            color: Colors.blue,
            shadowColor: Colors.red,
            elevation: 8,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Faces Game',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Ink.image(
                    image: AssetImage("images/faces.png"),
                    height: 240,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 200.0,
                        height: 50.0,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.lightBlueAccent),
                          ),
                          icon: Icon(
                            Icons.gamepad,
                            size: 24.0,
                            color: Colors.black,
                          ),
                          label: Text('Play'),
                          onPressed: () =>
                              Navigator.pushNamed(context, 'faces'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final game = gamedata.games[index];
              return ChildGame(
                gameTitle: game.name.toString(),
                image: game.image.toString(),
                onTap: () {
                  Navigator.pushNamed(context, game.route.toString());
                },
              );
            },
            itemCount: gamedata.gameCount,
          ),
        ],
      );
    });
  }
}
