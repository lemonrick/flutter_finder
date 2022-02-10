import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_vyhladavac/screen.dart';

void main() {
  runApp(const BooksSearchApp());
}

class BooksSearchApp extends StatelessWidget {
  const BooksSearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(title: 'Book App'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final dio = Dio();

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _books = [];

  void searchBooks(String query) async {
    final response = await widget.dio.get(
      'https://api.itbook.store/1.0/search/',
      queryParameters: {
        'q' : query
      }
    );
    setState(() {
      _books = response.data['books'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
        backgroundColor: Colors.lightBlueAccent
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchForm(onSearch: searchBooks,),
            _books == _books.isEmpty
                ? const Text('No results to display')
                : Expanded(
                  child: ListView(
              children: _books.map((book) {
                  return ListTile(
                  leading: Image.network(book["image"].toString()),
                  title: Text(book["title"].toString()),
                  subtitle: Text(book["subtitle"].toString()),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Screen(
                        title: book["title"].toString(),
                        subtitle: book["subtitle"].toString(),
                        url: book["image"].toString(),
                        isbn: book["isbn13"].toString(),
                        price: book["price"].toString(),
                      )),
                    );
                  },
                  );
            }).toList(),
            ),
                ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SearchForm extends StatefulWidget {

  SearchForm({required this.onSearch});

  final void Function(String search) onSearch;

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  late bool _autoValidate = false;
  var _search;

  @override
  Widget build(context) {
    return Form(
      key: _formKey,
      child: Column(
          children: [
            TextFormField(
              autovalidate: _autoValidate,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Enter search',
                border: OutlineInputBorder(),
                filled: true,
              ),
              onChanged: (value) {
                _search = value;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a search term';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  final isValid = _formKey.currentState!.validate();
                  if (isValid) {
                    widget.onSearch(_search);
                  } else {
                    setState(() {
                      _autoValidate = true;
                    });
                  }
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.lightBlueAccent,
                ),
                child: Text('Search'),),
            )
          ]),
    );
  }
}
