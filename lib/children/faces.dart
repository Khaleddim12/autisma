import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class Face extends StatefulWidget {
  const Face({Key? key}) : super(key: key);

  @override
  _FaceState createState() => _FaceState();
}

class _FaceState extends State<Face> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play Faces Game"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: FutureBuilder(
          future: FetchImageData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Ink.image(
                            image: NetworkImage(
                              snapshot.data![index],
                            ),
                            height: 240,
                            fit: BoxFit.cover,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 200.0,
                                height: 50.0,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    ),
                                    icon: Icon(
                                      Icons.volume_up,
                                      size: 24.0,
                                      color: Colors.black,
                                    ),
                                    label: Text('play sound'),
                                    onPressed: () {
                                      playSound();
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data!.length,
                );
              }
            } else if (snapshot.connectionState == ConnectionState.none) {
              return Text("Something Went Wrong");
            }
            return Center(
              child: CircularPercentIndicator(
                radius: 40,
              ),
            );
          },
        ),
      ),
    );
  }
}

FetchImageData() async {
  final url =
      "https://kaleidosblog.s3-eu-west-1.amazonaws.com/flutter_gallery/data.json";
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load');
  }
}

void playSound() {
  final player = AudioCache();
  player.play('example.wav');
}
