import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Sample images from Wikimedia Commons:
  static const List<String> _imgs = [
    'https://ep1.pinkbike.org/p6pb15663890/p6pb15663890.jpg',
    'https://ep1.pinkbike.org/p6pb17685864/p6pb17685864.jpg',
    'https://ep1.pinkbike.org/p6pb12504607/p6pb12504607.jpg',
    'https://ep1.pinkbike.org/p6pb17421853/p6pb17421853.jpg',
    'https://ep1.pinkbike.org/p6pb17693735/p6pb17693735.jpg',
  ];

  int _counter = 0;
  bool _clear = true;
  bool _error = false;

  void _incrementCounter() {
    setState(() {
      if (_clear || _error) { _clear = _error = false; }
      else { _counter = (_counter+1)%_imgs.length; }
    });
  }

  void _clearImage() {
    setState(() {
      _clear = true;
      _error = false;
    });
  }

  void _testError() {
    setState(() {
      _error = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    if (_error) { image = NetworkImage('error.jpg'); }
    else if (!_clear) { image = NetworkImage(_imgs[_counter]); }

    return Scaffold(
      appBar: AppBar(
        title: Text('Showing ' + (_error ? 'error' : _clear ? 'placeholder' : 'image #$_counter from Wikimedia')),
      ),

      body: Stack(children: <Widget>[
        Positioned.fill(child: 
          ImageFade(
            image: image,
            placeholder: Container(
              color: Color(0xFFCFCDCA),
              child: Center(child: Icon(Icons.photo, color: Colors.white30, size: 128.0,)),
            ),
            alignment: Alignment.center,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent event) {
              if (event == null) { return child; }
              return Center(
                child: CircularProgressIndicator(
                  value: event.expectedTotalBytes == null ? 0.0 : event.cumulativeBytesLoaded / event.expectedTotalBytes
                ),
              );
            },
            errorBuilder: (BuildContext context, Widget child, dynamic exception) {
              return Container(
                color: Color(0xFF6F6D6A),
                child: Center(child: Icon(Icons.warning, color: Colors.black26, size: 128.0)),
              );
            },
          )
        )
      ]),

      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Next',
          child: Icon(Icons.navigate_next),
        ),
        SizedBox(width:10.0),
        FloatingActionButton(
          onPressed: _clearImage,
          tooltip: 'Clear',
          child: Icon(Icons.clear),
        ),
        SizedBox(width:10.0),
        FloatingActionButton(
          onPressed: _testError,
          tooltip: 'Error',
          child: Icon(Icons.warning),
        ),
      ]),
    );
  }
}
