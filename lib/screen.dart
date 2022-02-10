import 'package:flutter/material.dart';

class Screen extends StatefulWidget {

  final String title;
  final String subtitle;
  final String url;
  final String isbn;
  final String price;

  const Screen({Key? key,
    required this.title,
    required this.subtitle,
    required this.url,
    required this.isbn,
    required this.price,
  }) : super(key: key);


  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('Book App')),
          backgroundColor: Colors.lightBlueAccent
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.lightBlueAccent,
        child: const Icon(Icons.arrow_back),
      ),*/
      //floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      body: Center(
        child: Container(child:
        SingleChildScrollView(child:
        Column(children: [
          Text(widget.title.toString(),
              style: const TextStyle(fontSize: 20.0)),
          const Text(''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.subtitle.toString(),
                style:
                const TextStyle(
                    fontSize: 15.0,
                ),
              textAlign: TextAlign.center,
            ),
          ),
        Image.network(widget.url.toString()),
          Text('ISBN: ' + widget.isbn.toString()),
          const Text(''),
          Text('Price: '  + widget.price.toString()),
        ],)
        ),
        ),
      ),
    );
  }
}
