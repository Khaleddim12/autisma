import 'dart:io';
import 'package:autisma/widgets/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  String result = "";
  File? _image;
  final imagePicker = ImagePicker();
  @override
  void initState() {
    super.initState();
    loadResult();
  }

  loadResult() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      result = (prefs.getString("result"))!;
    });
  }

  Future<void> pickImage() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
    if (_image != null) {
      uploadImage();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                title: Text('Result:'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(result),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }
  }

  Future<void> uploadImage() async {
    String uploadurl = "http://192.168.1.10:8000/predict";
    try {
      final List<int> imageBytes = _image!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);

      http.Response response = await http.post(Uri.parse(uploadurl), body: {
        'image': baseimage,
      });
      if (response.statusCode.toInt() == 200) {
        var jsondata = json.decode(response.body.toString());
        print(jsondata);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
          result = jsondata;
        });
        prefs.setString("result", result);
      } else {
        print(response.statusCode);
        print("else");
        //there is error during connecting to server,
        //status code might be 404 = url not found
      }
    } catch (e) {
      print("$e catch");
      print(e);
      //there is error during converting file image to base64 encoding.
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {},
      child: Scaffold(
        backgroundColor: Colors.lightBlue,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 70,
              ),
              Text(
                'Welcome To Autismile',
                style: TextStyle(
                    color: Colors.blueGrey[600],
                    fontSize: 33,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'MonteCarlo',
                    letterSpacing: 1.2),
              ),
              SizedBox(
                height: 80,
              ),
              Hero(
                tag: 'logoAnimation',
                child: Image.asset(
                  'images/boy.png',
                  fit: BoxFit.cover,
                  height: 300,
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: RoundedButton(
                    color: Colors.white54,
                    title: 'detection',
                    onpressed: () {
                      // Navigator.of(context).pushNamed('mathmetical');
                      pickImage();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 55,
                  width: double.infinity,
                  child: RoundedButton(
                    color: Colors.white54,
                    title: 'Proceed',
                    onpressed: () {
                      Navigator.of(context).pushNamed('login');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
